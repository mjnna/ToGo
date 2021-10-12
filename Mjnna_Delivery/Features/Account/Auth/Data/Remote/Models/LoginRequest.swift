//
//  LoginRequest.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
class LoginRequest: Codable {
    var email, password, deviceID, type: String
    
    enum CodingKeys: String, CodingKey {
        case email, password
        case deviceID
        case type
    }
}
