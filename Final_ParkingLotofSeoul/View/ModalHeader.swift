//
//  ModalHeader.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import UIKit

protocol ModalHeaderDelegate:AnyObject {
    func tapCall()
    func tapNavi()
    func tapReport()
}

class ModalHeader:UITableViewHeaderFooterView{
    static let identifier = "ModalHeader"
    
    //MARK: - Properties
    
    var delegate:ModalHeaderDelegate?
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var callView: UIView = {
        let view = UIView().specialView(imageName: "phone.fill", text: "전화걸기")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCall))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
        
     let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "star.fill"))
        image.tintColor = .white
        image.setWidth(25)
        image.setHeight(25)
        return image
    }()
    
    private lazy var naviView: UIView = {
        let view = UIView().specialView(imageName: "arrow.right.square.fill", text: "이름복사")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNavi))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var editView: UIView = {
        let view = UIView().specialView(imageName: "pencil", text: "수정요청")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapReport))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var specialStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [callView,editView,naviView])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 50
        return sv
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.setHeight(8)
        return view
    }()
    
    //MARK: - Lifecycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI(){
        let view = UIView()
        view.backgroundColor = .white
        
        self.addSubview(view)
        view.anchor(top:self.topAnchor,leading: self.leadingAnchor,bottom: self.bottomAnchor,trailing: self.trailingAnchor)
        
        view.addSubview(nameLabel)
        nameLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor,trailing: self.trailingAnchor,paddingLeading: 20, paddingTrailing: 20)
        
        view.addSubview(specialStack)
        specialStack.anchor(top: nameLabel.bottomAnchor, paddingTop: 30)
        specialStack.centerX(inView: self)
        
        view.addSubview(bottomView)
        bottomView.anchor(top: specialStack.bottomAnchor,leading: self.leadingAnchor , trailing: self.trailingAnchor, paddingTop: 60)
    }
    
    //MARK: - Actions
    @objc func tapCall() {
        delegate?.tapCall()
    }
    
    @objc func tapReport(){
        delegate?.tapReport()
    }
    
    @objc func tapNavi(){
        delegate?.tapNavi()
    }
}

