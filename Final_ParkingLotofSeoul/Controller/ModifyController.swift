//
//  ModifyController.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import UIKit
import JGProgressHUD

class ModifyController:UIViewController{
    
    //MARK: - Properties
    
    var location: String?
    
    var curretText = true
    
    private var segmentedValue: String {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return "공휴일 수정"
        case 1: return "운영시간 수정"
        case 2: return "요금 수정"
        case 3: return "기타 수정"
        default:
            return ""
        }
    }
    
    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["공휴일","운영시간","요금","기타"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        sc.selectedSegmentTintColor = .systemBlue
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        return sc
    }()
    
    private let segLabel: UILabel = {
        let label = UILabel()
        label.text = "수정항목"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let textView: UITextView = {
        let tf = UITextView()
        tf.textColor = .lightGray
        tf.backgroundColor = .white
        tf.font = .systemFont(ofSize: 18)
        return tf
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "수정내용"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "수정요청", style: .plain, target: self, action: #selector(rightButtonTapped))
        return button
    }()
    
    let hud:JGProgressHUD = {
        let hud = JGProgressHUD()
        return hud
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "뒤로가기"
        
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "정보 수정"
        
        textView.delegate = self
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,paddingTop: 80,paddingLeading: 20,paddingTrailing: 20)
        
        view.addSubview(segLabel)
        segLabel.anchor(leading: segmentedControl.leadingAnchor,bottom: segmentedControl.topAnchor, paddingBottom: 15)
        
        view.addSubview(textView)
        textView.anchor(top: segmentedControl.bottomAnchor,leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,paddingTop: 80, paddingLeading: 20, paddingTrailing: 20)
        
        view.addSubview(textLabel)
        textLabel.anchor(leading: textView.leadingAnchor,bottom: textView.topAnchor, paddingBottom: 15)
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Helpers
    
    private func popAlert(title: String,compltion: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: compltion)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    private func sendModification(text: String) {
        let alert = UIAlertController(title: "수정을 요청하시겠습니까?", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "네", style: .default) { [self] _ in
            hud.show(in: view)
            FirebaseService.reportModification(type: segmentedValue, name: self.location!, text: text) { [weak self] error in
                if error != nil {
                    self?.hud.dismiss(animated: true)
                    self?.popAlert(title: "서버연결에 실패했습니다. 다시 시도해주세요.",compltion: { _ in
                    })
                    return
                } else {
                    self?.hud.dismiss(animated: true)
                    self?.popAlert(title: "정보를 제공해주셔서 감사합니다.",compltion: { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        let noButton = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        alert.addAction(okButton)
        alert.addAction(noButton)
        present(alert, animated: true, completion: nil)
    }
    
        
    //MARK: - Actions
    @objc private func rightButtonTapped() {
        if let text = textView.text, textView.textColor == .black {

            if text != "" {
                sendModification(text: text)
            } else {
                popAlert(title: "수정내용을 입력해주세요") { _ in
                }
            }
        } else {
            popAlert(title: "수정내용을 입력해주세요") { _ in
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHieght = keyboardFrame.cgRectValue.height
            textView.anchor(bottom: view.bottomAnchor, paddingBottom: keyboardHieght)
        }
    }
}

//MARK: - TextViewDelegate
extension ModifyController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if curretText{
            textView.text = nil
            textView.textColor = .black
            curretText = false
        }
    }
}

