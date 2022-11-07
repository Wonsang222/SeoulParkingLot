//
//  ModalFooter.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import UIKit

class ModalFooter:UITableViewHeaderFooterView{
    static let identifier = "ModalFooter"
    
    //MARK: - Properties
    private let detailText: UILabel = {
        let label = UILabel()
        label.text = "주차장 정보는 '서울열린데이터광장'에 의거하여 제공됩니다. \n 오기된 정보는 상단의 '수정요청'을 통해 모두에게 공유 부탁 드립니다."
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.setHeight(8)
        return view
    }()
    
    //MARK: - Lifecycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configure() {
        addSubview(detailText)
        
        addSubview(topView)
        topView.anchor(top: self.topAnchor,leading: self.leadingAnchor , trailing: self.trailingAnchor, paddingTop: 10)
        
        addSubview(detailText)
        detailText.anchor(top: topView.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 20,paddingLeading: 20,paddingTrailing: 20)
        
    }
}

