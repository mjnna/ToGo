//
//  ApiSettings.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Alamofire
import Foundation
import Moya

enum EnvironmentModel: String {
    case development = "DEV"
    case qa = "QA"
    case staging = "STG"
    case production = "PROD"
}

enum APISetting {
    
    static var baseURL:String {
        get {
            return "https://api.sehhaty.sa/"
        }
    }
    
    static var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": UserDefaultsAccess.getToken(),
                "lang": LanguageManager.language.rawValue]
    }
}

func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}
