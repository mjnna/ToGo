//
//  ListCollectionViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 09/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionData: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var specialPriceLabel: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    
    var productId:String = ""    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        specialPriceLabel.isHidden = true
    }
    
    @IBAction func AddToCart(_ sender: Any) {
        self.addToCart(productId: productId)
    }
    
    func addToCart(productId: String) {
            NetworkManager.sharedInstance.showLoader()
            let sessionId = UserDefaults.standard.object(forKey:"token");
            
                var requstParams = [String:String]();
                requstParams["product_id"] = productId
                requstParams["token"] = sessionId as? String
                requstParams["quantity"] = "1"
                requstParams["options"] = "{}"
                
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"cart/add", cuurentView: self.parentContainerViewController()!){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        NetworkManager.sharedInstance.dismissLoader()
                        if dict.object(forKey: "error") != nil{
                            if (dict.object(forKey: "error") as! String == "authentication required"){
                                //self.loginRequest()
                            }
                            else{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: "You Can't order from more than one store at once".localized)
                            }
                            
                        }else{
                            let dict1 = responseObject as! NSDictionary
                            let dict = JSON(dict1)
                            let data = dict["cart"]["quantity"].stringValue
//                            self.parentContainerViewController()!.tabBarController!.tabBar.items?[1].badgeValue = data
                            NotificationCenter.default.post(name: .cartBadge, object: data)
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: "product added to cart successfully".localized)
                        }
                    }else if success == 2{
                        NotificationCenter.default.post(name: .cartBadge, object: "")
                        NetworkManager.sharedInstance.dismissLoader()
                    }
                }
    }
    
}
