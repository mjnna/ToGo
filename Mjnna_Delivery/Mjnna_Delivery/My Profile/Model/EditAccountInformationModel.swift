//
//  EditAccountInformationModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class EditAccountInformationModel: NSObject {
    
    var firstName:String!
    var lastName:String!
    var emailAddress:String!
    var telephone:String!
    
    
    init(data:JSON){
        firstName = data["users"]["ar_name"].stringValue
        lastName = data["users"]["en_name"].stringValue
        emailAddress = data["users"]["email"].stringValue
        telephone = data["users"]["phone"].stringValue
        
    }
    
}


class EditAccountInformationViewModel{
    var addrerssReceivedModel:EditAccountInformationModel!
    
    
    init(data:JSON) {
        addrerssReceivedModel = EditAccountInformationModel(data:data)
        
    }
    
    var getEditAddressReceived:EditAccountInformationModel{
        return addrerssReceivedModel
    }
    
    
}



