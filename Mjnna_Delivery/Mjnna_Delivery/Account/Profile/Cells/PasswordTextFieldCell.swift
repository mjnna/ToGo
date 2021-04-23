//
/**
 MobikulOpencartMp
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: PasswordTextFieldCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit
import MaterialComponents

class PasswordTextFieldCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet var textFieldNormal: MDCTextField!
    var usernameTextFieldController: MDCTextInputControllerOutlined!
    var delegate:FormFieldTextValueHandler!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldNormal.clearButtonMode = .unlessEditing
        textFieldNormal.textColor = UIColor.black  // text color
        textFieldNormal.delegate = self
        usernameTextFieldController = MDCTextInputControllerOutlined(textInput: textFieldNormal)
        usernameTextFieldController.floatingPlaceholderActiveColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        usernameTextFieldController.activeColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        textFieldNormal.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        textFieldNormal.clearButtonMode = .never
        
        let button = UIButton(type: .custom)
        button.setImage( UIImage(named: "ic_eye_closed"), for: .normal)
        button.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50))
        textFieldNormal.rightView = button
        textFieldNormal.rightViewMode = .always
        button.addTarget(self, action: #selector(hideunHidePassword(sender:)), for: .touchUpInside)
        
    }
    
    
    @objc func hideunHidePassword(sender: UIButton){
        if textFieldNormal.isSecureTextEntry{
            textFieldNormal.isSecureTextEntry = false
            sender.setImage(UIImage(named: "ic_eye_open")!, for: .normal)
        }else{
            textFieldNormal.isSecureTextEntry = true
            sender.setImage(UIImage(named: "ic_eye_closed")!, for: .normal)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func valueChanged(_ sender: MDCTextField) {
        
        delegate.getFormFieldValue(val: sender.text!, type: sender.accessibilityLabel ?? "")
    }
    
}
