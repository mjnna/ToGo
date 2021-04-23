//
//  CartModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 25/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class CartModel: NSObject {
    var cartProductId:String = ""
    var productName:String = ""
    var desc:String = ""
    var price:String = ""
    var subTotal:String = ""
    var weight:String = ""
    var totalWeight:String = ""
    var productImgUrl:String = ""
    var priductId:String = ""
    var optionData:Array<JSON>
    var quantity:String!
    var key:String!
    var isAnimate:Bool = false
    
    init(data: JSON) {
        self.cartProductId = data["id"].stringValue
        self.productName = data["name"].stringValue
        self.desc = data["description"].stringValue
        self.price = data["price"].stringValue
        self.subTotal = data["total_price"].stringValue
        self.productImgUrl = data["thumb"].stringValue
        self.priductId = data["products_id"].stringValue
        self.optionData = data["options"].arrayValue
        self.quantity = data["quantity"].stringValue
        self.weight = data["weight"].stringValue
        self.totalWeight = data["total_weight"].stringValue
        self.isAnimate = false
        
    }
    
}


class TotalAmount:NSObject{
    var text:String!
    var title:String!
    override init(){}
    init(data:JSON) {
        self.text = data["price"].stringValue + " SAR".localized
        self.title = data["text"].stringValue
    }
    
}


class CartViewModel{
    var cartproductDataModel = [CartModel]()
    var totalProducts:String!
    var totalProductsWeight:String!
    var amountTotal = [TotalAmount]()
    var checkout:Int = 0
    var errorMessage:String = ""
    var fastDelivery:Int = 0
    
    
    init(data:JSON) {
        for i in 0..<data["cart_products"].count{
            let dict = data["cart_products"][i];
            cartproductDataModel.append(CartModel(data: dict))
            print("How many item we got in here??>>>>>>>>>>>>>>>>>>>>> \(cartproductDataModel.count)")
        }
        
        fastDelivery = data["fast_delivery"].intValue
        totalProducts = data["quantity"].stringValue
        totalProductsWeight = data["weight"].stringValue
        
        for i in 0..<data["totals"].count{
            let dict = data["totals"][i];
            amountTotal.append(TotalAmount(data: dict))
        }
        let total = TotalAmount()
        total.title = "the Delivery price depands on your set location"
        amountTotal.append(total)
        
        
        
        self.checkout = data["cart"]["checkout_eligible"].intValue
        self.errorMessage = data["cart"]["error_warning"].stringValue
        
        
    }
    
    var getProductData:Array<CartModel>{
        return cartproductDataModel
    }
    
    var getTotalProducts:String{
        return totalProducts;
    }
    
    var getTotalAmount:Array<TotalAmount>{
        return amountTotal;
    }
    
    func setDataToCartModel(data:String,pos:Int){
        cartproductDataModel[pos].quantity = data;
    }
    
    
}
