//
//  ViewReturnRequestModel.swift
//  MobikulOpencartMp
//
//  Created by kunal on 02/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import Foundation

struct ViewReturnRequestModel{
    
    var action: String
    var date_added: String
    var date_ordered: String
    var email: String
    var firstname: String
    var model: String
    var opened: String
    var order_id: String
    var product: String
    var quantity: String
    var reason: String
    var return_id: String
    var comment: String
    var returnHistoryDataModel = [OrderHistoryInfoModel]()
    
    init(data:JSON) {
        self.action = data["action"].stringValue
        self.date_added = data["date_added"].stringValue
        self.date_ordered = data["date_ordered"].stringValue
        self.email = data["email"].stringValue
        self.firstname = data["firstname"].stringValue
        self.model = data["model"].stringValue
        self.opened = data["opened"].stringValue
        self.order_id = data["order_id"].stringValue
        self.product = data["product"].stringValue
        self.quantity = data["quantity"].stringValue
        self.reason = data["reason"].stringValue
        self.return_id = data["return_id"].stringValue
        self.comment = data["comment"].stringValue
        
        for i in 0..<data["histories"].count{
            let dict = data["histories"][i];
            returnHistoryDataModel.append(OrderHistoryInfoModel(data: dict))
        }
    }
}
