//
//  User.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation

class User: Codable {
    var id: Int?
    var arName, enName, email, phone: String?
    var type: String?
    var locationsID: String?
    var deviceToken: String?
    var customerID: Int?
    var currentLanguage: String?
    var location: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case arName = "arName"
        case enName = "enName"
        case email = "email"
        case phone = "phone"
        case type = "type"
        case locationsID = "locationsID"
        case deviceToken = "deviceToken"
        case customerID = "customerID"
        case currentLanguage = "currentLanguage"
        case location = "location"
    }
}
