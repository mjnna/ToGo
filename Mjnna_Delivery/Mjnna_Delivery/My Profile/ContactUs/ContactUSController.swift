/*
 @Category Webkul
 @author Webkul
 Created by: kunal on 16/07/18
 FileName: ContactUSController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */


import UIKit

class ContactUSController: UIViewController {
    
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var enqueryLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    
    @IBOutlet weak var goToStore: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var enqueryField: UITextView!
    
    @IBOutlet weak var goToStoreHeight: NSLayoutConstraint!
    
    let defaults = UserDefaults.standard
    var model: ContactUsModel?
    var whichCall: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "contactus".localized
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        headingLbl.text = "Contact Form".localized
        nameLbl.text = "Your Name *".localized
        emailLbl.text = "Email Address *".localized
        enqueryLbl.text = "Enquiry *".localized
        
        goToStore.setTitle("View Google Map", for: .normal)
        
        submitBtn.setTitle("submit".localized, for: .normal)
        submitBtn.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.layer.cornerRadius = 5;
        submitBtn.layer.masksToBounds = true
        
        goToStore.setTitle("Our Location".localized , for: .normal)
        goToStore.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        goToStore.setTitleColor(UIColor.white, for: .normal)
        goToStore.layer.cornerRadius = 5;
        goToStore.layer.masksToBounds = true
        
        nameField.text = UserDefaults.standard.object(forKey: "firstname") as? String
        emailField.text = UserDefaults.standard.object(forKey: "email") as? String

    }
   
    //MARK:- IBActions
    
    @IBAction func submitForm(_ sender: Any) {
        var errorMessage = NetworkManager.sharedInstance.language(key: "pleasefill")+" "
        var isValid:Int = 1
        
        if nameField.text == ""{
            errorMessage+=NetworkManager.sharedInstance.language(key: "name")
            nameField.becomeFirstResponder()
            isValid = 0
        }else if emailField.text == ""{
            errorMessage+=NetworkManager.sharedInstance.language(key: "email")
            emailField.becomeFirstResponder()
            isValid = 0
        }
        
        if isValid == 0{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: errorMessage)
            return
        }

        whichCall = "contactUS"
        callingHttppApi()    
    }
    
    @IBAction func jumpToOurLocation(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OurLocationController") as? OurLocationController
        vc?.data = self.model
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //MARK:- Network Calls
    func callingHttppApi() {
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        
        if whichCall == "" {
            NetworkManager.sharedInstance.callingHttpRequest(
                params: requstParams,
                apiname: "customer/getStoreLocation",
                cuurentView: self)
            {success,responseObject in
                if success == 1 {
                    let dict = responseObject as! NSDictionary;
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.loginRequest()
                        }
                    }else{
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let resultDict : JSON = JSON(responseObject!)
                        
                        if resultDict["error"].number == 1{
                            let AC = UIAlertController(title: "warning".localized, message: resultDict["message"].stringValue, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                
                            })
                            AC.addAction(okBtn)
                            self.present(AC, animated: true, completion:nil)
                        } else {
                            self.model = ContactUsModel(data: resultDict)
                            if self.model?.geolocation == "" &&
                                self.model?.address == "" &&
                                self.model?.image == "" &&
                                self.model?.open == "" &&
                                self.model?.fax == "" &&
                                self.model?.telephone == "" &&
                                self.model?.comment == "" {
                                self.goToStoreHeight.constant = 0
                            }
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        } else {
            requstParams["name"] = nameField.text!
            requstParams["email"] = emailField.text!
            requstParams["enquiry"] = enqueryField.text!
            NetworkManager.sharedInstance.callingHttpRequest(
                params: requstParams,
                apiname: "customer/contactUs",
                cuurentView: self)
            {success,responseObject in
                if success == 1 {
                    let dict = responseObject as! NSDictionary;
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            self.loginRequest()
                        }
                    }else{
                        self.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.dismissLoader()
                        let resultDict : JSON = JSON(responseObject!)
                        
                        if resultDict["error"].number == 1{
                            let AC = UIAlertController(title: "warning".localized, message: resultDict["message"].stringValue, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                
                            })
                            AC.addAction(okBtn)
                            self.present(AC, animated: true, completion:nil)
                        } else {
                            self.model = ContactUsModel(data: resultDict)
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    func loginRequest() {
        var loginRequest = [String:String]();
        loginRequest["apiKey"] = API_USER_NAME;
        loginRequest["apiPassword"] = API_KEY.md5;
        if self.defaults.object(forKey: "language") != nil{
            loginRequest["language"] = self.defaults.object(forKey: "language") as? String;
        }
        if self.defaults.object(forKey: "currency") != nil{
            loginRequest["currency"] = self.defaults.object(forKey: "currency") as? String;
        }
        if self.defaults.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = self.defaults.object(forKey: "customer_id") as? String;
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = responseObject as! NSDictionary
                
                self.defaults.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
                self.defaults.set(dict.object(forKey: "language") as! String, forKey: "language")
                self.defaults.set(dict.object(forKey: "currency") as! String, forKey: "currency")
                self.defaults.synchronize();
                self.callingHttppApi()
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest();
                
            }
        }
    }
}
