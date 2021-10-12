//
//  AuthApi.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
import Moya

enum AuthApi {
    case login(request: LoginRequest)
    
}

extension AuthApi : TargetType {
    var baseURL: URL {
        return URL(string: APISetting.baseURL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .login(let obj):
            return .requestJSONEncodable(obj)
        }
    }
    
    var headers: [String : String]? {
        return APISetting.headers
    }
    
    
}
