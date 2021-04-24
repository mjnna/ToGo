//
/**
 LanguageSwitcher
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: LanguageChooseController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit
import TransitionButton

class LanguageChooseController: UIViewController {
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var mainHeding: UILabel!
    @IBOutlet var descriptionData: UILabel!
    @IBOutlet var englishButton: UIButton!
    @IBOutlet var arabicButton: UIButton!
    @IBOutlet var selectButton: TransitionButton!
    var languageCode:String = "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        mainView.layer.cornerRadius = 20;
        mainView.layer.masksToBounds = true
        
        englishButton.layer.cornerRadius = 5;
        englishButton.layer.masksToBounds = true
        
        arabicButton.layer.cornerRadius = 5;
        arabicButton.layer.masksToBounds = true
        
        selectButton.layer.cornerRadius = 5;
        selectButton.layer.masksToBounds = true
        
        
        englishButton.setTitleColor(UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR), for: .normal)
        englishButton.layer.borderWidth = 1
        englishButton.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR).cgColor
        
        arabicButton.setTitleColor(UIColor.lightGray, for: .normal)
        arabicButton.layer.borderWidth = 1
        arabicButton.layer.borderColor = UIColor.lightGray.cgColor
        
        selectButton.setTitleColor(UIColor.white, for: .normal)
        selectButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        selectButton.spinnerColor = UIColor.white
        
    }
    
    
    @IBAction func englishClick(_ sender: UIButton) {
        englishButton.setTitleColor(UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR), for: .normal)
        englishButton.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR).cgColor
        
        arabicButton.setTitleColor(UIColor.lightGray, for: .normal)
        arabicButton.layer.borderColor = UIColor.lightGray.cgColor
        languageCode = "en"
    }
    
    
    @IBAction func arabicClick(_ sender: UIButton) {
        englishButton.setTitleColor(UIColor.lightGray, for: .normal)
        englishButton.layer.borderColor = UIColor.lightGray.cgColor
        
        arabicButton.setTitleColor(UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR), for: .normal)
        arabicButton.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR).cgColor
        languageCode = "ar"
        
    }
    
    
    @IBAction func selectClick(_ sender: TransitionButton) {
        sender.startAnimation()
        self.view.isUserInteractionEnabled = false
        let sessionId = sharedPrefrence.object(forKey:"wk_token")
        if(sessionId == nil){
            loginRequest()
        }else{
            self.callingHttppApi()
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func loginRequest(){
        var loginRequest = [String:String]()
        loginRequest["apiKey"] = API_USER_NAME
        loginRequest["apiPassword"] = API_KEY.md5
        if sharedPrefrence.object(forKey: "language") != nil{
            loginRequest["language"] = sharedPrefrence.object(forKey: "language") as? String;
        }
        if sharedPrefrence.object(forKey: "currency") != nil{
            loginRequest["currency"] = sharedPrefrence.object(forKey: "currency") as? String;
        }
        if sharedPrefrence.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = sharedPrefrence.object(forKey: "customer_id") as? String;
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"].intValue == 0{
                    sharedPrefrence.set(dict["wk_token"].stringValue, forKey: "wk_token")
                    sharedPrefrence.set(dict["language"].stringValue, forKey: "language")
                    sharedPrefrence.set(dict["currency"].stringValue, forKey: "currency")
                    sharedPrefrence.synchronize()
                    self.callingHttppApi()
                }else{
                    let AC = UIAlertController(title: "error".localized, message: "inavalidkeyandpassword".localized, preferredStyle: .alert)
                    self.present(AC, animated: true, completion: nil)
                    
                }
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
            }
        }
    }
    
    
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            let sessionId = sharedPrefrence.object(forKey:"wk_token");
            var requstParams = [String:Any]();
            requstParams["wk_token"] = sessionId;
            
            requstParams["code"] = self.languageCode;
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/language", cuurentView: self){success,responseObject in
                if success == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["fault"].intValue == 1{
                        self.loginRequest()
                    }else{
                        self.selectButton.stopAnimation(animationStyle: .expand, completion: {
                            self.doFurtherProcessingWithResult()
                        })
                        
                    }
                    
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi();
                }
            }
            
            
        }
    }
    
    
    func doFurtherProcessingWithResult(){
        defaults.set(languageCode, forKey: "language")
        defaults.synchronize()
        if languageCode == "ar" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        }else {
            L102Language.setAppleLAnguageTo(lang: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
        }
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "rootnav")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
            
        }) { (finished) -> Void in
        }
    }
    
    
    
    
    
    
}

