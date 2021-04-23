//
/**
 FormBuilder
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: NormalTextField.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit
import MaterialComponents

class NormalTextField: UITableViewCell,UITextFieldDelegate {
    
    
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
        textFieldNormal.clearButton.addTarget(self, action: #selector(clearClick(sender:)), for: .touchUpInside)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @objc func clearClick(sender: UIButton){
        delegate.getFormFieldValue(val: textFieldNormal.text!, type: textFieldNormal.accessibilityLabel ?? "")
    }
    
    
    
    
    
    @IBAction func valueChanged(_ sender: MDCTextField) {
        delegate.getFormFieldValue(val: sender.text!, type: sender.accessibilityLabel ?? "")
    }
    
    
    
}





