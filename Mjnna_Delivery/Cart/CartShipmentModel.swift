//
//  CartShipmentModel.swift
//  DrCrazy
//
//  Created by kunal on 05/07/19.
//  Copyright © 2019 webkul. All rights reserved.
//

import Foundation


struct ShipmentCountry{
    var country_id:String = ""
    var name:String = ""
    var zoneData = [Zone]()
    
    init(data:JSON) {
        self.country_id = data["country_id"].stringValue
        self.name = data["name"].stringValue
        if let result = data["zone"].array{
            self.zoneData = result.map({ (value) -> Zone in
                Zone(data: value)
            })
            
        }
    }
}

struct  Zone {
    var name:String = ""
    var zone_id:String = ""
    
    init(data:JSON) {
        self.name = data["name"].stringValue
        self.zone_id = data["zone_id"].stringValue
    }
}



class ShipmentCountryViewModel{
    var shipmentCountry = [ShipmentCountry]()
    
    init(data:JSON) {
        if let result = data["country_data"].array{
            self.shipmentCountry = result.map({ (value) -> ShipmentCountry in
                ShipmentCountry(data: value)
            })
        }
    }
    
}




struct Shipping_method{
    var code:String = ""
    var text:String = ""
    var title:String = ""
    
    init(data:JSON) {
        self.code = data["code"].stringValue
        self.text = data["text"].stringValue
        self.title = data["title"].stringValue
    }
}


class ShipingMethodViewModel{
    
    var shipping_method = [Shipping_method]()
    
    init(data:JSON) {
        for i in 0..<data["shipping_method"].count{
            var dict = data["shipping_method"][i]
            for j in 0..<dict["quote"].count{
                shipping_method.append(Shipping_method(data:dict["quote"][j]))
            }
        }
    }
    
    
}
