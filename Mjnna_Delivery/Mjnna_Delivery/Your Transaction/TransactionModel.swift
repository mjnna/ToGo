//
//  TransactionModel.swift
//  BroPhone
//
//  Created by kunal on 15/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation

struct TransactionModel{
    var date_added:String!
    var descriptionValue:String!
    var amount:String!
    
    init(data:JSON) {
        self.date_added = data["date_added"].stringValue
        self.descriptionValue = data["description"].stringValue
        self.amount = data["amount"].stringValue
    }
    
}



class TransactionViewModel{
    var headerMessage:String!
    var totalCount:Int!
    var transactionCollectionModel = [TransactionModel]()
    
    init(data:JSON) {
        if var arrayData = data["transactionData"].arrayObject {
            arrayData = (data["transactionData"].arrayObject! as NSArray) as! [Any]
            transactionCollectionModel =  arrayData.map({(value) -> TransactionModel in
                return  TransactionModel(data:JSON(value))
            })
        }
        headerMessage = data["transactionText"].stringValue
        totalCount = data["transactionsTotal"].intValue
        
    }
    
    func setTransactionCollectionData(data:JSON){
        let arrayData = data["transactionData"].arrayObject! as NSArray
        transactionCollectionModel = transactionCollectionModel + arrayData.map({(value) -> TransactionModel in
            return  TransactionModel(data:JSON(value))
        })
    }
}

