//
//  SocialAuthenticationsModles.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 17/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit

struct SocialAuthenticationsModles {

    struct AppleUser {
        let id:String
        let firstName:String
        let lastName:String
        let email:String
        @available(iOS 13.0, *)
        init(credentials:ASAuthorizationAppleIDCredential) {
            self.id = credentials.user
            self.firstName = credentials.fullName?.givenName ?? ""
            self.lastName = credentials.fullName?.familyName ?? ""
            self.email = credentials.email ?? ""
        }
    }
    
    struct FacebookUser {
        let id:String
        let firstName:String
        let lastName:String
        let name: String
        let email:String
        init(user:NSDictionary) {
            self.id = user.object(forKey: "id") as? String ?? ""
            self.name = user.object(forKey: "name") as? String ?? ""
            self.firstName = user.object(forKey: "first_name") as? String ?? ""
            self.lastName = user.object(forKey: "last_name") as? String ?? ""
            self.email = user.object(forKey: "email") as? String ?? ""
        }
    }


    struct GoogleUser {
        let id:String
        let name: String
        let firstName:String
        let lastName:String
        let email:String
        init(user:GIDGoogleUser) {
            self.id = user.userID
            self.name = user.profile.name
            self.firstName =  user.profile.givenName
            self.lastName =  user.profile.familyName
            self.email = user.profile.email
        }
    }
}
enum phoneNumberError{
    case toLong
    case toShort
    case notEnterd

    var errorMessage: String {
        switch self {
        case .toLong:
            return "The entered phone number is longer than requaired"
        case .toShort:
            return "The entered phone number is shorter than requaired"
        case .notEnterd:
            return "There is no phone number enterd yat"
        }
    }
    
   

}

