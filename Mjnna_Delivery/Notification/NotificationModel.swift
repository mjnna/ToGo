//
//  NotificationModel.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 04/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class NotificationModel: NSObject {
    var contet:String = ""
    var id:String = ""
    var notificationType:String = ""
    var title:String = ""
    var notification_ID:String = ""
    var subtitle:String = ""
    var dominant_color:String = ""
    var imageData:String = ""
    
    init(data: JSON) {
        self.contet = data["content"].stringValue
        self.id = data["id"].stringValue
        self.notificationType = data["type"].stringValue
        self.title = data["title"].stringValue
        self.notification_ID = data["notification_id"].stringValue
        self.subtitle = data["subTitle"].stringValue
        self.dominant_color = data["dominant_color"].stringValue
        self.imageData = data["image"].stringValue
    }
    
}

class NotificationViewModel {
    
    var notificationModel = [NotificationModel]()
    init(data:JSON) {
        for i in 0..<data["notifications"].count{
            let dict = data["notifications"][i];
            notificationModel.append(NotificationModel(data: dict))
        }
    }
    
    var getNotificationData:Array<NotificationModel>{
        return notificationModel
    }
    
    
    
    
}
