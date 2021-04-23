//
/**
 Odyody
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SubcategoryModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import Foundation


class SubcategoryViewModel{
    var cataegoriesCollectionModel = [Categories]()
    
    init(data:JSON) {
        if let arrayData = data["categories"].array{
            cataegoriesCollectionModel =  arrayData.map({(value) -> Categories in
                return  Categories(data:value)
            })
        }
    }
    
    
    
}
