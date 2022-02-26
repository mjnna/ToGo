//
//  CreateAccount.swift
//  OpenCartApplication
//
//  Created by shobhit on 16/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit
import Foundation

class CreateAccount: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource{
    
    var createAccountViewModel:CreateAccountViewModel!
    var stateArray:NSArray = []
    
    //@IBOutlet weak var becomeSellerSwitch: UISwitch!
    
    @IBOutlet weak var firstNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var lastNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var emailTextField: UIFloatLabelTextField!
    @IBOutlet weak var mobilrNumberTextField: UIFloatLabelTextField!
   
    @IBOutlet weak var agreeSwitch: UISwitch!
    
    @IBOutlet var passwordTextField: HideShowPasswordTextField!
    
    @IBOutlet var confirmPasswordTextField: HideShowPasswordTextField!
    
    
    @IBOutlet weak var yourpersonnelDetailsLabel: UILabel!
    @IBOutlet weak var yourpasswordlabel: UILabel!
    @IBOutlet weak var privacypolicyLabel: UILabel!
    
    
    
    var firstName:String = ""
    var lastName:String = ""
    var emailId:String=""
    var mobileNo:String = ""
    var password:String = ""
    var conPassword:String = ""
    var taxFieldValue:String = ""
    var mobileno:String = ""
    var groupIdStr:String = ""
    var newsLetterSubscribeStr:String = ""
    var agreeStr:String = ""
    var countryId:String = ""
    var zoneId:String = ""
    var isSeller:Bool = false
    
    
    public var movetoSignal:String = "customerLogin"
    @IBOutlet weak var registerButton: UIButton!
    let defaults = UserDefaults.standard
    var url:String!
    var titleName:String!
    @IBOutlet weak var mainView: UIView!
    var whichApiToProcess:String = ""
    
    @IBAction func agreeSwitchAction(_ sender: UISwitch) {
        let mySwitch = (sender )
        if mySwitch.isOn {
            agreeStr = "1"
        }
    }
    
    func setPasswordField(passwordField:HideShowPasswordTextField )
    {
        let Border = CAShapeLayer()
        Border.strokeColor = UIColor.gray.cgColor
        Border.lineDashPattern = [6, 6]
        Border.frame = CGRect(-5 , passwordField.bounds.origin.y, SCREEN_WIDTH - 35, passwordField.bounds.height )
        Border.fillColor = nil
        Border.path = UIBezierPath(roundedRect: Border.frame, byRoundingCorners: [ .topLeft, .topRight, .bottomRight, .bottomLeft ], cornerRadii: CGSize(width: 28, height: 28)).cgPath
        //passwordField.layer.addSublayer(Border)
        //passwordField.borderStyle = .none
    }
    
    func setTextField(textField:UIFloatLabelTextField )
    {
        let Border = CAShapeLayer()
        Border.strokeColor = UIColor.gray.cgColor
        Border.lineDashPattern = [6, 6]
        Border.frame = CGRect(-5 , textField.bounds.origin.y, SCREEN_WIDTH - 35, textField.bounds.height)
        Border.fillColor = nil
        Border.path = UIBezierPath(roundedRect: Border.frame, byRoundingCorners: [ .topLeft, .topRight, .bottomRight, .bottomLeft ], cornerRadii: CGSize(width: 28, height: 28)).cgPath
        //textField.layer.addSublayer(Border)
        //textField.borderStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NetworkManager.sharedInstance.languageBundle.localizedString(forKey: "createaccount", value: "", table: nil);
        setTextField(textField: firstNameTextField)
        setTextField(textField: lastNameTextField)
        setTextField(textField: emailTextField)
        setTextField(textField: mobilrNumberTextField)
        
        setPasswordField(passwordField: passwordTextField)
        setPasswordField(passwordField: confirmPasswordTextField)

        registerButton.layer.cornerRadius = 20
        registerButton.backgroundColor = UIColor(red: 1.00, green: 0.72, blue: 0.00, alpha: 1)
        agreeSwitch.thumbTintColor = #colorLiteral(red: 0.2048713093, green: 0.2099455618, blue: 0.4340101523, alpha: 1)
        firstNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        lastNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        emailTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        passwordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobilrNumberTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        
        passwordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        confirmPasswordTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobilrNumberTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        mobilrNumberTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccount.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        firstNameTextField.placeholder = NetworkManager.sharedInstance.language(key: "firstname")+" "+GlobalData.ASTERISK
        lastNameTextField.placeholder = NetworkManager.sharedInstance.language(key: "lastname")+" "+GlobalData.ASTERISK
        emailTextField.placeholder = NetworkManager.sharedInstance.language(key: "email")+" "+GlobalData.ASTERISK
        mobilrNumberTextField.placeholder = NetworkManager.sharedInstance.language(key: "mobileno")+" "+GlobalData.ASTERISK
        passwordTextField.placeholder = NetworkManager.sharedInstance.language(key: "password")+" "+GlobalData.ASTERISK
        confirmPasswordTextField.placeholder = NetworkManager.sharedInstance.language(key:"conpassword")+" "+GlobalData.ASTERISK
        registerButton.setTitle(NetworkManager.sharedInstance.language(key:"register"), for: .normal)
        yourpersonnelDetailsLabel.text = NetworkManager.sharedInstance.language(key:"yourpersoneldetails")
        
        yourpasswordlabel.text = NetworkManager.sharedInstance.language(key:"yourpassword")
    
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: NetworkManager.sharedInstance.language(key:"privacypolicy"), attributes: underlineAttribute)
        privacypolicyLabel.attributedText = underlineAttributedString
        
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateAccount.privacyPolicy))
        privacypolicyLabel.addGestureRecognizer(tap1)
    
        firstNameTextField.textColor = UIColor.black
        lastNameTextField.textColor = UIColor.black
        emailTextField.textColor = UIColor.black
        passwordTextField.textColor = UIColor.black
        confirmPasswordTextField.textColor = UIColor.black
        
        registerButton.layer.masksToBounds = true
        whichApiToProcess = ""
        //callingHttppApi();
        self.navigationController?.navigationBar.isHidden = false
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    

    
    @objc func privacyPolicy(){
        NetworkManager.sharedInstance.dismissLoader()
        //self.performSegue(withIdentifier: "privacypolicy", sender: self)
        
    }
    
    
    
    func loginRequest(){
    }
    
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
            if self.whichApiToProcess == "addCustomer"{
                var requstParams = [String:String]();
                requstParams["first_name"] = self.firstNameTextField.text
                requstParams["last_name"] = self.lastNameTextField.text
                requstParams["email"] = self.emailTextField.text
                requstParams["phone"] = self.mobilrNumberTextField.text
                requstParams["password"] = self.passwordTextField.text
                let regToken = self.defaults.string(forKey: "deviceToken")
                if regToken != "" {
                    requstParams["device_id"] = regToken
                }
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"customer/register", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary
                        if dict.object(forKey: "error") != nil{
                            // return the error to the user
                            
                            let resultJson = JSON(dict)
                            let error = resultJson["error"]
                        
                            if (!error.isEmpty){
                                let phoneErrorMessage = error["phone"].array?[0].stringValue
                                let emailErrorMessage = error["email"].array?[0].stringValue
                                if (!(phoneErrorMessage?.isEmpty ?? false) ){
                                    NetworkManager.sharedInstance.showErrorSnackBar(msg:phoneErrorMessage ?? "invalid credentials")
                                }else{
                                    NetworkManager.sharedInstance.showErrorSnackBar(msg:emailErrorMessage ?? "invalid credentials")
                                }
                                
                            }
                            
                            self.view.isUserInteractionEnabled = true
                            NetworkManager.sharedInstance.dismissLoader()
                            //self.registerButton.stopAnimation(animationStyle: .expand, completion: {
                              //  self.navigationController?.popViewController(animated: true)
                            //})
                        }else{
                            self.view.isUserInteractionEnabled = true
                            NetworkManager.sharedInstance.dismissLoader()
                            let resultJson = JSON(dict)
                            if self.whichApiToProcess == "addCustomer"{
                                self.doFurtherProcessing(resultJson: resultJson)
                                }
                            }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
            }
        }
    }
    func doFurtherProcessing(resultJson: JSON){
        var token = resultJson["token"].stringValue
        let welcomMsg = "welcome".localised + " "+(resultJson["user"]["ar_name"].stringValue)+" "+(resultJson["user"]["en_name"].stringValue)
        NetworkManager.sharedInstance.showSuccessSnackBar(msg:welcomMsg)
            defaults.set(resultJson["token"].stringValue, forKey: "token")
            defaults.set(resultJson["user"]["customer_id"].stringValue, forKey: "customer_id")
            defaults.set(self.emailTextField.text, forKey: "email")
            defaults.set(self.firstNameTextField.text, forKey: "first_name")
            defaults.set("", forKey: "image")
            defaults.set(self.lastNameTextField.text, forKey: "last-name")
            defaults.set(self.mobilrNumberTextField.text, forKey: "phone")
            defaults.synchronize()
        NetworkManager.sharedInstance.showSuccessSnackBar(msg: welcomMsg)
//        self.tabBarController?.selectedIndex = 0
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func registerAccount(_ sender: Any) {
        
        firstName = firstNameTextField.text!
        lastName = lastNameTextField.text!
        emailId = emailTextField.text!
        password = passwordTextField.text!
        conPassword = confirmPasswordTextField.text!
        mobileNo = mobilrNumberTextField.text!
        var errorMessage:String = "pleasefill".localized+" "
        
        if !firstNameTextField.isValid(name:"firstname".localized){
            firstNameTextField.becomeFirstResponder()
            return
        }
        else if !lastNameTextField.isValid(name:"lastname".localized){
            lastNameTextField.becomeFirstResponder()
            return
        }
        else if !emailTextField.isValid(name:"email".localized){
            emailTextField.becomeFirstResponder()
            return
        }
        else if !emailTextField.text!.isValidEmail(){
            NetworkManager.sharedInstance.showErrorSnackBar(msg: "invalidemail".localized)
            emailTextField.becomeFirstResponder()
            return
        }
        else if !mobilrNumberTextField.isValid(name:"mobileno".localized){
            mobilrNumberTextField.becomeFirstResponder()
            return
        }
        
        else if passwordTextField.text == ""{
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"password")
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            passwordTextField.becomeFirstResponder()
            return
        }else if (passwordTextField.text?.count)! < 4{
            NetworkManager.sharedInstance.showErrorSnackBar(msg:"passwordmusthave4characters".localized)
            passwordTextField.becomeFirstResponder()
            return
        }else if confirmPasswordTextField.text == ""{
            errorMessage = errorMessage+NetworkManager.sharedInstance.language(key:"conpassword")
            NetworkManager.sharedInstance.showErrorSnackBar(msg:errorMessage)
            confirmPasswordTextField.becomeFirstResponder()
            return
            
        }else if (passwordTextField.text != confirmPasswordTextField.text){
            errorMessage = NetworkManager.sharedInstance.language(key:"passwordnotmatch")
            NetworkManager.sharedInstance.showErrorSnackBar(msg:errorMessage)
            passwordTextField.becomeFirstResponder()
            return
            
        }/*else if !(agreeSwitch.isOn){
            errorMessage = NetworkManager.sharedInstance.language(key:"pleasecheckprivacypolicy")
            NetworkManager.sharedInstance.showErrorSnackBar(msg:errorMessage)
            return
        }*/else {
            
        }
        
        whichApiToProcess = "addCustomer"
        callingHttppApi()
    }
    
    func doFurtherProcessingWithResult(){
        /*for i in 0..<createAccountViewModel.getCountryData.count{
            if createAccountViewModel.getCountryData[i].countryId == createAccountViewModel.createAccountModel.defaultCountryCode{
                countryTextField.text = createAccountViewModel.getCountryData[i].countryName
                countryId = createAccountViewModel.getCountryData[i].countryId
                stateArray = createAccountViewModel.getCountryData[i].zoneArr! as NSArray
                if stateArray.count>0{
                    let dict = stateArray.object(at: 0) as! NSDictionary;
                    stateTextField.text = dict.object(forKey: "name") as? String
                    zoneId = (dict.object(forKey: "zone_id") as? String)!
                }
                break
            }
        }*/
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.createAccountViewModel.getCountryData.count;
        }
        if(pickerView.tag == 2000){
            return stateArray.count;
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1000{
            return createAccountViewModel.getCountryData[row].countryName
        }else if pickerView.tag == 2000{
            let dict = stateArray.object(at: row) as! NSDictionary;
            return dict.object(forKey: "name") as? String
        }
        else{
            return ""
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "privacypolicy") {
            /*let viewController:PrivacyPolicy = segue.destination as UIViewController as! PrivacyPolicy
            viewController.titleString = "termandcondition".localised
            viewController.privacyMessage = self.createAccountViewModel.getAgreeDescription*/
        }
    }
}

extension CreateAccount:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
}
