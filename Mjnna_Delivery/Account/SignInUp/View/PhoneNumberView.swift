//
//  PHoneNumberView.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 18/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit
import MaterialComponents


class PhoneNumberView:UIView  {

    //MARK: - Component
    lazy var label: UILabel = {
       let lb = UILabel()
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = #colorLiteral(red: 0.1728341281, green: 0.2500136793, blue: 0.4368206263, alpha: 1)
        lb.text = "Enter your phone Number to continue Registring"
        return lb
    }()
    lazy var phonTextField:MDCTextField = {
        let tf = MDCTextField()
        setTextField(textField: tf)
        phoneTextFieldController =  MDCTextInputControllerOutlined(textInput: tf)
        phoneTextFieldController.floatingPlaceholderActiveColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        phoneTextFieldController.activeColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        phoneTextFieldController.placeholderText = "Phone number".localized
        tf.delegate = self
        return tf
    }()
    lazy var continueButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        btn.setTitle("Continuer registering".localized, for: .normal)
        btn.layer.cornerRadius = 15
        return btn
    }()
    lazy var cancelButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .clear
        let attributedString = NSAttributedString(string: "Cancel".localized, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.1728341281, green: 0.2500136793, blue: 0.4368206263, alpha: 1)])
        btn.setAttributedTitle(attributedString, for: .normal)
        return btn
    }()
    lazy var navigationView: UIView = {
       let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.925491035, green: 0.9199894667, blue: 0.9297201037, alpha: 1)
        v.addSubview(cancelButton)
        cancelButton.anchor(left: v.leadingAnchor, paddingLeft: 20 , width: 70, height: 25)
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: v.centerYAnchor)
        ])
        v.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        v.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        v.layer.shadowOpacity = 0.6
        v.layer.shadowRadius = 3
        return v
    }()
    
    var phoneTextFieldController: MDCTextInputControllerOutlined!

    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.roundCorners(corners: [.topRight,.topLeft], radius: 30)
        self.dropShadow(radius: 50, opacity: 0.4, color: .black)


    }
    private func setup (){
        self.backgroundColor = .white
       
        addSubview(navigationView)
        self.navigationView.anchor(top: self.topAnchor, left: self.leadingAnchor, right: self.trailingAnchor,height: 35)
        
        addSubview(label)
        label.anchor(top: navigationView.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30, height: 40)
        
        addSubview(phonTextField)
        self.phonTextField.anchor(top: label.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 5, paddingLeft: 30, paddingRight: 30, height: 50)
        
        addSubview(continueButton)
        self.continueButton.anchor(top: phonTextField.bottomAnchor, paddingTop: 40,width: 250, height: 40)
        NSLayoutConstraint.activate([
            continueButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setTextField(textField:MDCTextField )
    {
        let Border = CAShapeLayer()
        Border.strokeColor = UIColor.gray.cgColor
        Border.lineDashPattern = [6, 6]
        Border.frame = textField.bounds
        Border.fillColor = nil
        Border.path = UIBezierPath(roundedRect: textField.bounds, byRoundingCorners: [ .topLeft, .topRight, .bottomRight, .bottomLeft ], cornerRadii: CGSize(width: 28, height: 28)).cgPath
        textField.layer.addSublayer(Border)
    }

    
}
extension PhoneNumberView:UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        if textField == phonTextField {
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted

            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
          
            return string == filtered
        }else{
            return true
        }
    }
}
