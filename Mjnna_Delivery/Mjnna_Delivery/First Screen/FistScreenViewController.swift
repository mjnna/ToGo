//
//  FistScreenViewController.swift
//  DAR Chassis App
//
//  Created by Kunal Parsad on 16/10/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit
//import FBSDKLoginKit

class FistScreenViewController: UIViewController/*,GIDSignInDelegate, GIDSignInUIDelegate*/  {


var emailId:String = ""
var passwordValue:String = ""
var whichApiToProcess :String = ""
let defaults = UserDefaults.standard;
@IBOutlet weak var loginButton: UIButton!
@IBOutlet weak var registerButton: UIButton!
@IBOutlet weak var closeButton: UIButton!
@IBOutlet weak var continueMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      self.navigationController?.navigationBar.shadowImage = UIImage()
      loginButton.setTitle(NetworkManager.sharedInstance.language(key: "loginwithemail"), for: .normal)
      loginButton.setTitleColor(UIColor.white, for: .normal)
      loginButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
      registerButton.setTitle(NetworkManager.sharedInstance.language(key: "register"), for: .normal)
      registerButton.setTitleColor(UIColor.white, for: .normal)
      registerButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
      closeButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
      continueMessageLabel.text = NetworkManager.sharedInstance.language(key: "continuewithother")
      continueMessageLabel.textColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
      closeButton.layer.cornerRadius = 15
      closeButton.layer.masksToBounds = true
        
      
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
      
        
    }

    
    @IBAction func closeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func disMissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func loginClick(_ sender: Any) {
        self.performSegue(withIdentifier: "customerlogin", sender: self)
    }
    
    
    @IBAction func registerClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createaccount", sender: self)
    }
    
    func showSpinningWheel(_ notification: NSNotification) {
        print(notification.userInfo!)
//        if let image = notification.userInfo?["image"] as? UIImage {
//            // do something with your image
//        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "createaccount") {
            let viewController:CreateAccount = segue.destination as UIViewController as! CreateAccount
            viewController.movetoSignal = "firstlaunch"
            
        }else if (segue.identifier! == "customerlogin") {
            let viewController:CustomerLogin = segue.destination as UIViewController as! CustomerLogin
            viewController.moveToSignal = "firstlaunch"
            
        }
        
        
        
    }
    
//    @IBAction func fbLoginAction(_ sender: Any) {
//        let loginView : FBSDKLoginManager = FBSDKLoginManager()
//        loginView.loginBehavior = FBSDKLoginBehavior.web
//
//        loginView.logIn(withReadPermissions:["public_profile","user_friends","email"], from: self) {
//            loginResult,error in
//            if(error != nil){
//                print("success")
//            }
//            else{
//                self.loginManagerDidComplete()
//            }
//        }
//    }
//    
//  func loginManagerDidComplete()   {
//    
//    if((FBSDKAccessToken.current()) != nil){
//        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
//        if (error == nil){
//            NetworkManager.sharedInstance.showLoader()
//        let dict = result as! [String : AnyObject]
////        print(dict)
//        var dict2 =  [String : Any]()
//        let sessionId = sharedPrefrence.object(forKey:"wk_token");
//        dict2["wk_token"] = sessionId;
//        dict2["firstname"] = dict["first_name"]
//        dict2["lastname"] = dict["last_name"]
//        dict2["email"] = dict["email"]
//        dict2["personId"] = dict["id"]
//        
//        print("Facebook Details: ", dict2)
//        //                   call api
//            self.SocialLoginAPICall(dict: dict2)
//    
//                }
//            })
//        }
//    
//    }
    
    @IBAction func googleLoginAction(_ sender: Any) {
       
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().signOut()
//        GIDSignIn.sharedInstance().signIn()
    }
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error == nil {
//            var dict2 =  [String : Any]()
//            let sessionId = sharedPrefrence.object(forKey:"wk_token");
//            dict2["wk_token"] = sessionId;
//            dict2["firstname"] = user.profile.givenName
//            dict2["lastname"] = user.profile.familyName
//            dict2["email"] = user.profile.email
//            dict2["personId"] = user.userID!
//
//            self.SocialLoginAPICall(dict: dict2)
//
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }
    
    
    func SocialLoginAPICall(dict: [String : Any]){
        NetworkManager.sharedInstance.callingHttpRequest(params:dict, apiname:"customer/addSocialCustomer", cuurentView: self){success,responseObject in
            NetworkManager.sharedInstance.dismissLoader()
            if let resultDict = responseObject{
                NetworkManager.sharedInstance.dismissLoader()
                self.defaults.set(resultDict.object(forKey: "customer_id") ?? "", forKey: "customer_id")
                self.defaults.set(resultDict.object(forKey: "email") ?? "", forKey: "email")
                self.defaults.set(resultDict.object(forKey: "firstname") ?? "", forKey: "firstname")
                self.defaults.set(resultDict.object(forKey: "image") ?? "", forKey: "image")
                self.defaults.set(resultDict.object(forKey: "lastname") ?? "", forKey: "lastname")
                self.defaults.set(resultDict.object(forKey: "phone") ?? "", forKey: "phone")
                self.defaults.set(resultDict.object(forKey: "wallet_balance") ?? "", forKey: "wallet_balance")
                self.defaults.set(resultDict.object(forKey: "image") ?? "", forKey: "profileImage")
                self.defaults.synchronize()
                let welcomMsg = NetworkManager.sharedInstance.language(key: "welcome")+"  " + (resultDict.object(forKey: "firstname") as! String) + (resultDict.object(forKey: "lastname") as! String)
                NetworkManager.sharedInstance.showSuccessSnackBar(msg:welcomMsg)
                
                let cartTotalDict = JSON(resultDict);
                if resultDict.object(forKey: "partner") != nil{
                    let partnerValue = cartTotalDict["partner"].intValue
                    if partnerValue == 1{
                        self.defaults.set("true", forKey: "partner")
                    }else{
                        self.defaults.set("false", forKey: "partner")
                    }
                    
                }
                
                self.dismiss(animated: true, completion: nil)
     
            }
            

           
           
        }
    }
    
   

    
    
    
}
