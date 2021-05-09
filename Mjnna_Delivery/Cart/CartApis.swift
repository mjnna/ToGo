//
//  CartApis.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 13/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation

class CartApis{
    
    static let shared = CartApis()
    
    let defaults = UserDefaults.standard
    var requstParams =  [String:Any]()

    
    func userToken (viewController: UIViewController) -> String {
        var token = String()
        if let castedToken = defaults.object(forKey:"token") as? String {
            if castedToken.isEmpty{
                viewController.view.isUserInteractionEnabled = true
                NetworkManager.sharedInstance.dismissLoader()
                viewController.tabBarController?.selectedIndex = 2
               print("user not signed in")
            }else{
                token = castedToken
            }
        }else{
            print("user not signed in")
        }
        return token
    }
    
    func getCartProducts(viewController:MyCart,compleation: @escaping(CartViewModel,[Locations]) -> Void) {
        DispatchQueue.main.async{ [self] in

           NetworkManager.sharedInstance.showLoader()
           requstParams["token"] = userToken(viewController: viewController)
            if let lang = sharedPrefrence.object(forKey: "language") as? String{
                print(lang)
                requstParams["lang"] = lang
            }
           NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/details", cuurentView: viewController){success,responseObject in
               if success == 1 {
                   let dict = responseObject as! NSDictionary;
                   if dict.object(forKey: "error") != nil{
                    viewController.loginRequest()
                   }else{
                       viewController.view.isUserInteractionEnabled = true
                    getLocations(viewController: viewController) { (loc) in
                        compleation(CartViewModel(data: JSON(responseObject as! NSDictionary)), loc)
                           NetworkManager.sharedInstance.dismissLoader()
                    }
                  
                   }
               }else if success == 2{
                   NetworkManager.sharedInstance.dismissLoader()
               }
           }
        }
    }
    
    
    func updateCartProducts(viewController: MyCart,productId:String,quantity:String){
        DispatchQueue.main.async{
            self.requstParams["token"] = self.userToken(viewController: viewController)
            self.requstParams["quantity"] = quantity
            print(productId)
            self.requstParams["cart_product_id"] = productId
            
       
            NetworkManager.sharedInstance.callingNewHttpRequest(params:self.requstParams as! Dictionary<String, String>, apiname:"cart/edit", cuurentView: viewController){success,responseObject in
                if success == 1 {
                    let dict = responseObject as! NSDictionary;
                    if dict.object(forKey: "fault") != nil{
                        let fault = dict.object(forKey: "fault") as! Bool;
                        if fault == true{
                            viewController.loginRequest()
                        }
                    }else{
                        NetworkManager.sharedInstance.dismissLoader()
                        let dict = (responseObject as! NSDictionary)
                        if dict.object(forKey: "error") != nil{
                            viewController.loginRequest()
                        }
                        else{
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: "cart updated successfully".localized)
                            viewController.refreshCartProductsList()
                            
                        }
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.updateCartProducts(viewController: viewController, productId: productId, quantity: quantity)
                }
            }
        }
    }
    
    func clearCartProducts(viewController:MyCart){
        DispatchQueue.main.async{
            NetworkManager.sharedInstance.showLoader()
            NetworkManager.sharedInstance.callingNewHttpRequest(params:self.requstParams as! Dictionary<String, String>, apiname:"cart/clear", cuurentView: viewController){success,responseObject in
                if success == 1 {
                    let dict = responseObject as! NSDictionary
                    if dict.object(forKey: "error") != nil{
                            viewController.loginRequest()
                    }else{
                        NetworkManager.sharedInstance.dismissLoader()
                        viewController.view.isUserInteractionEnabled = true
                        NetworkManager.sharedInstance.showSuccessSnackBar(msg: "cart updated successfully".localized)
                        viewController.cartViewModel = nil
                        viewController.refreshCartProductsList()
                        
                    }
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.clearCartProducts(viewController: viewController)
                }
            }
        }
    }
    
 
    func getLocations(viewController:UIViewController,completion:@escaping([Locations]) -> Void){
            var requstParams = [String:String]()
            requstParams["token"] = self.userToken(viewController: viewController)
            
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"location/list",cuurentView: viewController){val,responseObject in
                    if val == 1 {
                        let dict = JSON(responseObject as! NSDictionary)
                        if dict["error"] != nil{
                            NotificationCenter.default.post(name: .availablelocation, object: false)
                        }else{
                            
                            let locations = LocationsData(data: dict["locations"]).locations
                            completion(locations)
                        }
                    }else{
                        self.getLocations(viewController: viewController) { (loc) in
                            completion(loc)
                        }
                    }
                }
     
        
    }
    
 
}
