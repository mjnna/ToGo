//
//  UserDefaultsAccess.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
enum DefaultsConstantKeys {
    static var user = "user"
    static var token = "token"
}


class UserDefaultsAccess {
    static let shared = UserDefaultsAccess()
    
    private init() {}
    
    
    private static var token: String = ""
    
    var user: User? {
        let userStr = TOGOUserDefualts.shared.getValueBy(key: DefaultsConstantKeys.user)
        guard !userStr.isEmpty else {
            return nil
        }
        if let usr: User = userStr.toObject() {
            return usr
        }
        return nil
    }
    

    
    static func getToken() -> String {
        if token.isEmpty {
            let storedToken = TOGOUserDefualts.shared.getValueBy(key: DefaultsConstantKeys.token)
            guard !storedToken.isEmpty else {
                token = ""
                return token
            }
            if storedToken.contains("Bearer") {
                token = storedToken
            } else {
                token = "Bearer \(storedToken)"
            }
        }
        return token
    }
    

    func saveData(key: String, value: String) {
        TOGOUserDefualts.shared.save(value: value, forKey: key)
    }
    



}
