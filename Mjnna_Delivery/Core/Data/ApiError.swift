//
//  ApiError.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
class ApiError: Codable, Swift.Error {
    var error: String?
    var apiCode: Int?
    
    init(apiCode: Int? = 0, msg: String) {
        self.error = msg
        self.apiCode = apiCode
    }

    
    enum CodingKeys: String, CodingKey {
        case error
    }
    
}
