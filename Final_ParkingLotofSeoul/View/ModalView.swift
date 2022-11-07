//
//  ModalView.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import UIKit

protocol ModalViewDelegate: AnyObject {
    func scrollDown()
    func accessToReport(location:String)
    func popAlarm()
}

class ModalView:UIView{
    
    //MARK: - Properties
    
    var delegate:ModalViewDelegate?
    
    var viewModel:ModalViewViewModel?{
        didSet{
            tableView.reloadData()
        }
    }
        
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.setHeight(5)
        view.setWidth(40)
        view.layer.cornerRadius = 5  / 2
        return view
    }()
        
    private var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    private let toastLabel = UILabel().toastLabel(text: "복사되었습니다")
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        self.backgroundColor = .white
        self.addSubview(topView)
        topView.centerX(inView: self)
        topView.anchor(top: self.topAnchor, paddingTop: 10)
        
        self.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ModalHeader.self, forHeaderFooterViewReuseIdentifier: ModalHeader.identifier)
        tableView.register(ModalFooter.self, forHeaderFooterViewReuseIdentifier: ModalFooter.identifier)
        tableView.register(ModalCell.self, forCellReuseIdentifier: ModalCell.identifier)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        tableView.anchor(top: topView.bottomAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor,trailing: self.trailingAnchor, paddingTop: 20)
    }
    
    //MARK: - Actions
    func showUp() {
        tableView.anchor(top: topView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingTop: 20)
        tableView.isScrollEnabled = true
    }
    
    func showDown() {
        self.addSubview(topView)
        topView.centerX(inView: self)
        topView.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        
        tableView.anchor(top: topView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingTop: 20)
        tableView.contentOffset = CGPoint(x: 0, y: 0 - (tableView.contentInset.top))
        tableView.isScrollEnabled = false
    }
    
    private func showToast() {
            self.addSubview(toastLabel)
            toastLabel.centerX(inView: self)
            toastLabel.anchor(bottom: self.bottomAnchor, paddingBottom: 50,width: 200)
       
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.toastLabel.removeFromSuperview()
        }
    }
}

extension ModalView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModalCell.identifier, for: indexPath) as! ModalCell
        guard let viewModel = viewModel else {return cell}
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.detailLabel.text = viewModel.parkingLotType
            cell.cellLabel.text = "주차장 유형"
            return cell
        case 1:
            cell.detailLabel.text = String(viewModel.capacity)
            cell.cellLabel.text = "총 주차면"
            return cell
        case 2:
            cell.detailLabel.text = "\(viewModel.runtime[0]) ~ \(viewModel.runtime[1])"
            cell.cellLabel.text = "유료 운영시간(금일)"
            return cell
        case 3:
            cell.detailLabel.text = "\(viewModel.minimumRate)"
            cell.cellLabel.text = "기본요금"
            return cell
        case 4:
            cell.detailLabel.text = "\(viewModel.extraRate)"
            cell.cellLabel.text = "추가요금"
            return cell
        case 5:
            cell.detailLabel.text = "\(viewModel.maximumDailyRate)"
            cell.cellLabel.text = "일 최대요금"
            return cell
        default:
            return cell
        }
    }
}

extension ModalView:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ModalHeader.identifier) as! ModalHeader
        guard let viewModel = viewModel else {return header}
        header.nameLabel.text = viewModel.name
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ModalFooter.identifier) as! ModalFooter
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
}

extension ModalView:UIScrollViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (tableView.contentOffset.y) < 0 {
            delegate?.scrollDown()
        }
    }
}

extension ModalView:ModalHeaderDelegate{
    func tapReport() {
        guard let viewModel = viewModel else {return}
        delegate?.accessToReport(location: viewModel.name)
    }
    
    func tapNavi() {
        guard let viewModel = viewModel else {return}
        UIPasteboard.general.string = viewModel.name
        showToast()
    }
    
    func tapCall() {
        guard let viewModel = viewModel else {return}
        if viewModel.phoneNumber == ""{
            delegate?.popAlarm()
            return
        }
        if let url = URL(string: "tel://" + "\(viewModel.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

