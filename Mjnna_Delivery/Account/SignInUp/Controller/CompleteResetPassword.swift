//
//  CompleteResetPassword.swift
//  Mjnna_Delivery
//
//  Created by Amr Saleh on 2/1/22.
//  Copyright © 2022 Webkul. All rights reserved.
//

import UIKit
import TransitionButton
import MaterialComponents

class CompleteResetPassword: UIViewController {
    
    
    @IBOutlet var emailTextField: MDCTextField!
    @IBOutlet var passwordTextField: MDCTextField!
    @IBOutlet var codeTextField: MDCTextField!
    @IBOutlet var forgotpasswordButton: TransitionButton!
    
    
    var whichApiToProcess:String = "forgotpassword"
    var userEmail:String = ""
    
    
    var emailTextFieldController: MDCTextInputControllerOutlined!
    var passwordTextFieldController: MDCTextInputControllerOutlined!
    var codeTextFieldController: MDCTextInputControllerOutlined!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        forgotpasswordButton.setTitle(NetworkManager.sharedInstance.language(key:"forgotpassword"), for: .normal)
        
        emailTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        passwordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        emailTextField.textColor = UIColor.black
        passwordTextField.textColor = UIColor.black
        
        emailTextFieldController = MDCTextInputControllerOutlined(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        codeTextFieldController = MDCTextInputControllerOutlined(textInput: codeTextField)
        emailTextFieldController.floatingPlaceholderActiveColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        emailTextFieldController.activeColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        codeTextFieldController.floatingPlaceholderActiveColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        codeTextFieldController.activeColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        passwordTextFieldController.floatingPlaceholderActiveColor = UIColor.black
        passwordTextFieldController.activeColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        emailTextFieldController.placeholderText = "email".localized
        passwordTextFieldController.placeholderText = "password".localized
        codeTextFieldController.placeholderText = "code".localized
        forgotpasswordButton.setTitleColor(UIColor().HexToColor(hexString: GlobalData.DARKGREY), for: .normal)
        
        forgotpasswordButton.layer.masksToBounds = true
        forgotpasswordButton.titleLabel?.text = "reset".localized
        
        passwordTextField.clearButtonMode = .never
        
        let button = UIButton(type: .custom)
        button.setImage( UIImage(named: "ic_eye_closed"), for: .normal)
        button.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50))
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        button.addTarget(self, action: #selector(hideunHidePassword(sender:)), for: .touchUpInside)
        
        forgotpasswordButton.layer.cornerRadius = 27
        forgotpasswordButton.backgroundColor = UIColor(red: 1.00, green: 0.72, blue: 0.00, alpha: 1)
        
        emailTextField.text = userEmail
        emailTextField.isEnabled = false
    }
    
    @objc func hideunHidePassword(sender: UIButton){
        if passwordTextField.isSecureTextEntry{
            passwordTextField.isSecureTextEntry = false
            sender.setImage(UIImage(named: "ic_eye_open")!, for: .normal)
        }else{
            passwordTextField.isSecureTextEntry = true
            sender.setImage(UIImage(named: "ic_eye_closed")!, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func ResetButtonClick(_ sender: TransitionButton) {
        var errorMessage :String = NetworkManager.sharedInstance.language(key: "pleasefill")+" ";
        var isValid:Int = 0;
        if emailTextField.text == ""{
            isValid = 1;
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"email");
            emailTextField.becomeFirstResponder()
        }
        else if !emailTextField.text!.isValidEmail(){
            isValid = 1;
            errorMessage = NetworkManager.sharedInstance.language(key:"invalidemail");
            emailTextField.becomeFirstResponder()
        }
        else if passwordTextField.text == ""{
            isValid = 1;
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"password")
            passwordTextField.becomeFirstResponder()
        }
        else if (passwordTextField.text?.count)! < 4{
            isValid = 1;
            errorMessage = NetworkManager.sharedInstance.language(key:"passwordmusthave4characters")
            passwordTextField.becomeFirstResponder()
        }
        else if codeTextField.text == ""{
            isValid = 1;
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"code")
            codeTextField.becomeFirstResponder()
        }
        
        if isValid == 1{
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
        }else{
            sender.startAnimation()
            callingHttppApi()
        }
        
    }
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            let sessionId = sharedPrefrence.object(forKey:"token")
            var requstParams = [String:String]()
            requstParams["token"] = sessionId as? String
            if self.whichApiToProcess == "forgotpassword"{
                NetworkManager.sharedInstance.showLoader()
                requstParams["email"] = self.userEmail
                requstParams["code"] = self.codeTextField.text
                requstParams["newPassword"] = self.passwordTextField.text
                
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"reset-password", cuurentView: self){success,responseObject in
                    
                    if success == 1 {
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = JSON(responseObject as! NSDictionary)
                            
                            if dict["error"].intValue == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                                self.navigationController?.popToRootViewController(animated: false)
                            }else{
                                NetworkManager.sharedInstance.showInfoSnackBar(msg: dict["message"].stringValue)
                            }
                        
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
                self.view.isUserInteractionEnabled = true
                NetworkManager.sharedInstance.dismissLoader()
                self.forgotpasswordButton.stopAnimation(animationStyle: .normal,completion: {})
            }
        }
    }
}
