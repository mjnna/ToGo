//
//  OrderDeatilsViewModel.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 08/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation


struct Order{
    var id: Int
    var price: String
    var delivery_price: String
    var total_price: String
    var store: String
    var order_status_id: Int
    var order_status: String
    var order_type: String
    var orderProducts = [OrderProduct]()
    init(data:JSON){
        price  = data["price"].stringValue
        delivery_price  = data["delivery_price"].stringValue
        id = data["id"].intValue
        total_price = data["total_price"].stringValue
        store = data["store"].stringValue
        order_status_id = data["order_status"]["id"].intValue
        order_status = data["order_status"]["name"].stringValue
        order_type = data["order_type"]["name"].stringValue
        if let products = data["order_products"].array{
            orderProducts =  products.map({(value) -> OrderProduct in
                return  OrderProduct(data:value)
            })
        }
 
    }
}

struct OrderProduct {
    let images: [String]
    let quantity: Int
    let totalWeight: String
    let id: Int
    let totalPrice: String
    let option:Array<Any>
    let name: String
    init(data:JSON){
        let fetchedImages = data["images"].arrayObject as? [String]
        images = fetchedImages ?? []
        quantity  = data["quantity"].intValue
        totalWeight = data["total_weight"].stringValue
        id = data["id"].intValue
        totalPrice = data["total_price"].stringValue
        option = data["option"].arrayValue
        name = data["name"].stringValue
        
    }
   
}
