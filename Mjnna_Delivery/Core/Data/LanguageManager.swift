//
//  LanguageManager.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//
import Foundation
import UIKit

class LanguageManager {
    static func changeLanguage(lang: Language? = nil) {
        var newLang = ""
        if let lang = lang {
            newLang = lang == .ar ? "ar" : "en"
        } else {
            newLang = LanguageManager.language == .ar ? "en" : "ar"
        }
        print("newLang \(newLang)")
        
        let def = UserDefaults.standard
        def.set([newLang, currentLanguage()], forKey: "AppleLanguages")
        def.synchronize()

        if newLang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance().textAlignment = .right
            UITextView.appearance().textAlignment = .right
            UITableView.appearance().semanticContentAttribute = .forceRightToLeft
            UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
            UICollectionView.appearance().semanticContentAttribute = .forceRightToLeft
            UILabel.appearance().semanticContentAttribute = .forceRightToLeft
            
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().textAlignment = .left
            UITextView.appearance().textAlignment = .left
            UITableView.appearance().semanticContentAttribute = .forceLeftToRight
            UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
            UILabel.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    static var language: Language {
        let lang = currentLanguage()
        
        return lang == "ar" ? .ar : .en
    }
    
    class func currentLanguage() -> String {
        let def = UserDefaults.standard
        let lang = def.object(forKey: "AppleLanguages") as! NSArray
        let currentLanguage = lang.firstObject as! String
        return currentLanguage
    }
    class func isArabic() -> Bool {
        let lang = currentLanguage()
        return lang == "ar"
    }
    
    
}

enum Language: String {
    case ar
    case en
}
