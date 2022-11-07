//
//  Extension.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import UIKit
import JGProgressHUD

extension UIButton {
    func imageButton(image: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: image), for: .normal)
        button.tintColor = color
        button.layer.cornerRadius = 50 / 2
        return button
    }
}

extension UILabel{
    func noResult()->UILabel{
        let label = UILabel()
        label.text = "검색결과가 없습니다"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 20)
        return label
    }
    func toastLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18)
        label.backgroundColor = .darkGray
        label.alpha = 0.9
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 35 / 2
        label.textAlignment = .center
        return label
    }
}

extension JGProgressHUD{
    func addtext(_ value:String)->JGProgressHUD{
        let hud = JGProgressHUD()
        self.textLabel.text = value
        return hud
    }
}

extension UIView {
    func specialView(imageName: String,text: String) -> UIView {
        let view = UIView()
        view.setWidth(40)
        view.setHeight(40)
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemBlue
        let image = UIImageView(image: UIImage(systemName: imageName))
        image.tintColor = .white
        image.setWidth(25)
        image.setHeight(25)
        view.addSubview(image)
        image.centerX(inView: view)
        image.centerY(inView: view)
        let label = UILabel()
        label.text = text
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 18)
        view.addSubview(label)
        label.anchor(top: view.bottomAnchor, paddingTop: 10)
        label.centerX(inView: view)
       return view
    }
}


extension UIView {
func anchor(top: NSLayoutYAxisAnchor? = nil,leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeading: CGFloat = 0, paddingBottom: CGFloat = 0, paddingTrailing: CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
        topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let left = leading {
        leadingAnchor.constraint(equalTo: left, constant: paddingLeading).isActive = true
    }
    
    if let bottom = bottom {
        bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    
    if let right = trailing {
        trailingAnchor.constraint(equalTo: right, constant: -paddingTrailing).isActive = true
    }
    
    if let width = width {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if let height = height {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leadingAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let leading = leadingAnchor {
            anchor(leading: leading, paddingLeading: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}

extension NSAttributedString {
    func detailString(text: String) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(string: text)
        str.addAttribute(.foregroundColor, value: UIColor.lightGray, range: (text as NSString).range(of: "복사"))
        str.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: (text as NSString).range(of: "복사"))
        return str
    }
}

