//
//  LoginResponse.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation

class LoginResponse: Codable {
    var token: String
    var user: User
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case user = "user"
    }

}
