//
//  ApisServices.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 16/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation
import Alamofire

struct SocialAccount {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber:String
}

class ApisServices {

    static let shared = ApisServices()
    
    var whichApiToProcess:String = ""
    let defaults = UserDefaults.standard

    func signinWithSocialAccounts(isRegisteration: Bool,user: SocialAccount,viewController:UIViewController,compleation:@escaping((String,String) -> ())){
        DispatchQueue.main.async{
            viewController.view.isUserInteractionEnabled = false
            NetworkManager.sharedInstance.showLoader()
                var requstParams = [String:String]()
                if isRegisteration{
                    requstParams["first_name"] = user.firstName
                    requstParams["last_name"] = user.lastName
                    requstParams["email"] = user.email
                    requstParams["phone"] = user.phoneNumber
                }else{
                    requstParams["first_name"] = user.firstName
                    requstParams["last_name"] = user.lastName
                    requstParams["email"] = user.email
                }
                let regToken = self.defaults.string(forKey: "deviceToken")
                if regToken != "" {
                    requstParams["device_id"] = regToken
                }
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"customer/socialLogin", cuurentView: viewController){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "error") != nil{
                            // return the error to the user
                            if let error = dict.object(forKey: "error") as? String{
                                print("our respons: \(String(describing: responseObject))")
                                compleation("",error)
                            }
                            NetworkManager.sharedInstance.dismissLoader()
                            NetworkManager.sharedInstance.showErrorSnackBar(msg:"invalid credentials".localised)
                            viewController.view.isUserInteractionEnabled = true
                            //self.registerButton.stopAnimation(animationStyle: .expand, completion: {
                              //  self.navigationController?.popViewController(animated: true)
                            //})
                        }else{
                           
                            viewController.view.isUserInteractionEnabled = true
                            NetworkManager.sharedInstance.dismissLoader()
                            let resultJson = JSON(dict)
                            let token = resultJson["token"].stringValue
                            compleation(token,"")
                            self.doFurtherProcessing(resultJson: resultJson, user: user, viewController: viewController)
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.signinWithSocialAccounts(isRegisteration: isRegisteration, user: user, viewController: viewController, compleation: { token,error in
                            if error.isEmpty {
                                compleation(token,"")
                            }else{
                                compleation("",error)
                            }
                        })
                    }
                }
            }
    }
     private func doFurtherProcessing(resultJson: JSON,user: SocialAccount,viewController:UIViewController){
        let welcomMsg = "welcome".localised + " "+(resultJson["user"]["ar_name"].stringValue)+" "+(resultJson["user"]["en_name"].stringValue)
        NetworkManager.sharedInstance.showSuccessSnackBar(msg:welcomMsg)
        defaults.set(resultJson["token"].stringValue, forKey: "token")
        defaults.set(resultJson["user"]["customer_id"].stringValue, forKey: "customer_id")
        defaults.set(user.email, forKey: "email")
        defaults.set(user.firstName, forKey: "first_name")
        defaults.set("", forKey: "image")
        defaults.set(user.lastName, forKey: "last-name")
        defaults.set(user.phoneNumber, forKey: "phone")
        defaults.synchronize()

        NetworkManager.sharedInstance.showSuccessSnackBar(msg: welcomMsg)
        viewController.tabBarController?.selectedIndex = 0
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    func checkUserAuthenticationStatus(viewController:UIViewController,email:String,compleation:@escaping(NSDictionary,String) -> ()){
        let apiName = "customer/isLogin"
        var requstParams = [String:String]()
        requstParams["email"] = email
        NetworkManager.sharedInstance.callingNewHttpRequest(params: requstParams, apiname: apiName, cuurentView: viewController) { (success, responseObject) in
            DispatchQueue.main.async {
                let emptyObject = NSDictionary()
                switch success {
                case 1:
                    if let dicResponse = responseObject as? NSDictionary {
                    compleation(dicResponse, "")
                    }
                case 2:
                    compleation(emptyObject, "somthing went Wrong to checking user if he is new")
                default:
                    break
                }
            }

        }
        
    }
    
}
