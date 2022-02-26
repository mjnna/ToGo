//
//  CustomerLogin.swift
//  OpenCartMpV3
//
//  Created by kunal on 13/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit
import Alamofire
import TransitionButton
import MaterialComponents

class CustomerLogin: UIViewController   {
    
    @IBOutlet var ParentView: UIView!
    @IBOutlet var emailTextField: MDCTextField!
    @IBOutlet var passwordTextField: MDCTextField!
    
    @IBOutlet var loginButton: TransitionButton!
    @IBOutlet weak var forgotpasswordButton: UIButton!
    
    
    var whichApiToProcess:String = ""
    public var moveToSignal:String = ""
    var userEmail:String = ""
    let defaults = UserDefaults.standard
//    var touchID:TouchID!
    var NotAgainCallTouchId :Bool = false
    
    var emailTextFieldController: MDCTextInputControllerOutlined!
    var passwordTextFieldController: MDCTextInputControllerOutlined!
    
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
        self.navigationController?.navigationBar.isHidden = false

        
        loginButton.setTitle(NetworkManager.sharedInstance.language(key: "login"), for: .normal)
        forgotpasswordButton.setTitle(NetworkManager.sharedInstance.language(key:"forgotpassword"), for: .normal)
       
        
//        touchID = TouchID(view:self)
        
        emailTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        passwordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        emailTextField.textColor = UIColor.black
        passwordTextField.textColor = UIColor.black
        
        emailTextFieldController = MDCTextInputControllerOutlined(textInput: emailTextField)
        passwordTextFieldController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        emailTextFieldController.floatingPlaceholderActiveColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        emailTextFieldController.activeColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        passwordTextFieldController.floatingPlaceholderActiveColor = UIColor.black
        passwordTextFieldController.activeColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        emailTextFieldController.placeholderText = "email".localized
        passwordTextFieldController.placeholderText = "password".localized
        forgotpasswordButton.setTitleColor(UIColor().HexToColor(hexString: GlobalData.DARKGREY), for: .normal)
        
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.text = "login".localized
        
        passwordTextField.clearButtonMode = .never
        
        //setTextField(textField: emailTextField)
        //setTextField(textField: passwordTextField)
        
        let button = UIButton(type: .custom)
        button.setImage( UIImage(named: "ic_eye_closed"), for: .normal)
        button.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(50), height: CGFloat(50))
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        button.addTarget(self, action: #selector(hideunHidePassword(sender:)), for: .touchUpInside)
        
        loginButton.layer.cornerRadius = 27
        loginButton.backgroundColor = UIColor(red: 1.00, green: 0.72, blue: 0.00, alpha: 1)
        
        
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
    
    
    func loginRequest(){
        self.callingHttppApi()
    }
    
    func completeResetPassword() {
        let vc = UIStoryboard.init(name: "Account", bundle: Bundle.main).instantiateViewController(withIdentifier: "resetPassword") as! CompleteResetPassword
        vc.userEmail = userEmail
        self.navigationController?.pushViewController(vc, animated: true)
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
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"forget-password", cuurentView: self){success,responseObject in
                    if success == 1 {
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = JSON(responseObject as! NSDictionary)
                        
                        
                        if dict["fault"].intValue == 1{
                            self.loginRequest()
                        }else{
                            if dict["error"].intValue == 0{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                                self.completeResetPassword()
                            }else{
                                NetworkManager.sharedInstance.showInfoSnackBar(msg: dict["message"].stringValue)
                            }
                        }
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
            else{
                requstParams["email"] = self.emailTextField.text
                requstParams["password"] = self.passwordTextField.text
                requstParams["type"] = "customer"
                let regToken = self.defaults.string(forKey: "deviceToken")
                if regToken != "" {
                    requstParams["device_id"] = regToken
                }
                
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams,
                                                                    apiname:"login", cuurentView: self)
                {success,responseObject in
                    if success == 1 {
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "error") != nil{
                            // return the error to the user
                            let resultJson = JSON(dict)
                            let errorMessage = resultJson["error"].stringValue
                            NetworkManager.sharedInstance.showErrorSnackBar(msg:errorMessage)
                            self.loginButton.stopAnimation(animationStyle: .normal,completion: {
                            })
                        }else{
                            self.doFurtherProcessingWithResult(data:responseObject!)
                        }
                        
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data:AnyObject){
        self.view.isUserInteractionEnabled = true
        let resultDict = data as! NSDictionary
        let resultJson : JSON = JSON(resultDict)
        if resultJson["error"].number == 1{
            let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "warning"), message: resultJson["message"].stringValue, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.loginButton.stopAnimation(animationStyle: .shake, completion:nil)
            })
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: nil)
        }else{
            NetworkManager.sharedInstance.dismissLoader()
            defaults.set(resultJson["token"].stringValue, forKey: "token")
            defaults.set(resultJson["user"]["customer_id"].stringValue, forKey: "customer_id")
            defaults.set(resultJson["user"]["current_language"].stringValue, forKey: "language")
            defaults.set(resultJson["user"]["email"].stringValue, forKey: "email")
            defaults.set(resultJson["user"]["ar_name"].stringValue, forKey: "first_name")
            defaults.set(resultJson["user"]["en_name"].stringValue, forKey: "last-name")
            defaults.set(resultJson["user"]["phone"].stringValue, forKey: "phone")
            defaults.synchronize()
            let welcomMsg = NetworkManager.sharedInstance.language(key: "welcome")+"  "+(resultJson["user"]["ar_name"].stringValue)+" "+(resultJson["user"]["en_name"].stringValue)
            NetworkManager.sharedInstance.showSuccessSnackBar(msg:welcomMsg)
            
            // return the cart quantity with the api response
            if resultJson["cart_total"].intValue > 0{
                self.tabBarController!.tabBar.items?[1].badgeValue = resultJson["cart_total"].stringValue
            }else{
                self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                    self.navigationController?.popToRootViewController(animated: false)
                })
            }
            self.tabBarController?.selectedIndex = 0

        }
    }
    
    @IBAction func dismissController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func loginClick(_ sender: TransitionButton) {
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
        
        if isValid == 1{
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
        }else{
            sender.startAnimation()
            whichApiToProcess = ""
            callingHttppApi()
        }
        
    }
    
    
    @IBAction func forgotPasswordClick(_ sender: Any) {
        let AC = UIAlertController(title:NetworkManager.sharedInstance.language(key:"enteremail"), message: "", preferredStyle: .alert)
        AC.addTextField { (textField) in
            textField.placeholder = NetworkManager.sharedInstance.language(key:"email");
            textField.applyTextFieldAlingment()
        }
        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key:"ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            if((textField.text?.count)! < 2){
                NetworkManager.sharedInstance.showErrorSnackBar(msg: NetworkManager.sharedInstance.language(key:"invalidemail"))
            }
            else{
                if !textField.text!.isValidEmail(){
                    NetworkManager.sharedInstance.showWarningSnackBar(msg: NetworkManager.sharedInstance.language(key:"invalidemail"));
                }else{
                    self.userEmail = textField.text!;
                    self.whichApiToProcess = "forgotpassword"
                    self.callingHttppApi();
                }
            }
        })
        let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
    }
    
    
    @IBAction func signupClick(_ sender: Any) {
        self.performSegue(withIdentifier: "createaccount", sender: self)
    }
    
}
