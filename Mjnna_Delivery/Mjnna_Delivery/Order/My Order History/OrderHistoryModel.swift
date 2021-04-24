//
//  OrderHistoryModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class OrderHistoryModel: NSObject {

    var status:String = ""
    var date:String = ""
    var weight:String = ""
    var orderType:String = ""
    var total:String = ""
    var orderId:String = ""
    var statusId:Int = 0
    var storeResponse:String = ""
    
    
    init(data: JSON) {
        self.status = data["order_status"]["name"].stringValue
        self.date = data["delivery_date"].stringValue
        self.weight = data["weight"].stringValue
        self.storeResponse = data["store_response"].stringValue
        self.orderType = data["order_type"]["name"].stringValue
        self.total = data["total_price"].stringValue
        self.orderId = data["id"].stringValue
        self.statusId = data["order_status"]["id"].intValue

    }

}


class OrderHistoryViewModel{
    var orderHistorydataModel = [OrderHistoryModel]()
    //var totalCount:Int = 0
    
    init(data:JSON) {
        for i in 0..<data["orders"].count{
            let dict = data["orders"][i];
            orderHistorydataModel.append(OrderHistoryModel(data: dict))
        }
        
        //self.totalCount = data["orderTotals"].intValue
    }
    
    var getOrdersData:Array<OrderHistoryModel>{
        return orderHistorydataModel
    }
    
    
    func setOrderCollectionData(data:JSON){
        
        if let arrayData = data["orders"].arrayObject{
            orderHistorydataModel = orderHistorydataModel + arrayData.map({(value) -> OrderHistoryModel in
                return  OrderHistoryModel(data:JSON(value))
            })
        }
    }
    
    
}
