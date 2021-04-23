//
//  SearchSuggestionModel.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 10/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit



class SearchsuggestionHints:NSObject{
    var label:String = ""
    var productID:String = ""
    init(data: JSON) {
      self.label = data["name"].stringValue
      self.productID = data["product_id"].stringValue
    }
    
    
    
}

class SearchSuggestionViewModel:NSObject{
    var searchSuggestionHintsModel = [SearchsuggestionHints]();
    
    
    init(data:JSON) {
        if var arrayData = data["search_data"].arrayObject {
            arrayData = (data["search_data"].arrayObject! as NSArray) as! [Any]
            searchSuggestionHintsModel =  arrayData.map({(value) -> SearchsuggestionHints in
                return  SearchsuggestionHints(data:JSON(value))
            })
        }
        
    }
    
    var getSuggestedHints:Array<SearchsuggestionHints>{
    return searchSuggestionHintsModel
   }
    
    
    
    
}




