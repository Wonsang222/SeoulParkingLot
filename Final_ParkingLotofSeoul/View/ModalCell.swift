//
//  ModalCell.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import UIKit

class ModalCell:UITableViewCell{
    static let identifier = "Modalcell"
    
    //MARK: - Properties
    let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cellLabel,detailLabel])
        stack.axis = .horizontal
        stack.spacing = 25
        return stack
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubview(stack)
        stack.anchor(leading: self.leadingAnchor, trailing: self.trailingAnchor,paddingLeading: 20,paddingTrailing: 20)
        stack.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

