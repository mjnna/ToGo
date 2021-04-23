//
//  Language.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 01/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation


let APPLE_LANGUAGE_KEY = "AppleLanguages"

/// L102Language

public class L102Language {
    
    /// get current Apple language
    
    class func currentAppleLanguage() -> String{
        
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    
    class func setAppleLAnguageTo(lang: String) {
        
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}
