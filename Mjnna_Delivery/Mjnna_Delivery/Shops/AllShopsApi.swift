//
//  AllShopsApi.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 22/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation
import UIKit

struct StoresFilter {
    let minOrder:Int
    let fastDelivery: Bool
    let page:Int
    let pageLength:Int
    let rate:Int
    let name:String
}
class AllStoresApi{
    
    static let shared = AllStoresApi()
    

    func getAllStores(filter:StoresFilter,viewController: UIViewController,compleation:@escaping([Store],String) -> Void){
        var requstParams = [String:String]()
        
        requstParams["min_order"] = String(filter.minOrder)
        if filter.fastDelivery {
            requstParams["fast_delivery"] = String(1)
        }else{
            requstParams["fast_delivery"] = String(0)
        }
        requstParams["Page"] = String(filter.page)
        requstParams["PageLength"] = String(filter.pageLength)
        requstParams["rate"] = String(filter.rate)
        print("name: \(filter.name)")
        requstParams["name"] = filter.name
        
        if let language = sharedPrefrence.object(forKey: "language") as? String {
            requstParams["lang"] = language
        }

        NetworkManager.sharedInstance.callingNewHttpRequest(params: requstParams , apiname: "store/filterStores", cuurentView: viewController) { (val, responseObject) in
                if val == 1 {
                    viewController.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["error"] != nil{
                       //display the error to the customer
                        if let response = responseObject as? NSDictionary {
                            if let error = response["error"] as? String {
                                compleation([], error)
                            }
                        }
                    }else{
                        print(dict["result"])
                        NetworkManager.sharedInstance.dismissLoader()
                        let storeCollectionModel = StoreData(data: dict["result"]).stores
                        compleation(storeCollectionModel,"")

                    }
                    
                }
                else{
                    NetworkManager.sharedInstance.dismissLoader()
//                    self.callingHttppApi()
                }
            }
    }
    
}
