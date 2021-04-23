//
//  ProductCollectionModel.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 09/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ProductCollectionModel: NSObject {
    var productName: String
    var images = [JSON]()
    var productImage: String
    var descriptionData: String
    var id: String
    var price: String
    var isFeatured: Int
    var specialPrice: Float
    var weight: Float
    var featureStart: String
    var featureEnd: String
    var tax: String
    
    init(data: JSON) {
        images = data["images"].arrayValue
        self.productImage = images[0].rawString()!
        self.descriptionData = data["description"].stringValue
        self.id = data["id"].stringValue
        self.price = data["price"].stringValue
        self.productName = data["name"].stringValue
        self.isFeatured = data["is_featured"].intValue
        self.specialPrice = data["feature_price"].floatValue
        self.weight = data["weight"].floatValue
        self.featureStart = data["feature_end_date"].stringValue
        self.featureEnd = data["feature_start_date"].stringValue
        tax = data["tax"].stringValue
    }
    
}

class StoreCategoryCollectionModel: NSObject{
    
    var id:String = ""
    var name:String = ""
    var image:String = ""
    
    init(data: JSON) {
        self.id = data["id"].stringValue
        self.name = data["name"].stringValue.html2String
        self.image = data["image"].stringValue
        
    }
    
}




class ProductCollectionViewModel {
    
    var productCollectionModel = [ProductCollectionModel]()
    
    init(data:JSON){
            let arrayData = data["products"].arrayObject! as NSArray
            productCollectionModel =  arrayData.map({(value) -> ProductCollectionModel in
                return  ProductCollectionModel(data:JSON(value))
            })
    }
    
    var getProductCollectionData:Array<ProductCollectionModel>{
        return productCollectionModel
    }
    
    
    func setProductCollectionData(data:JSON){
            let arrayData = data["products"].arrayObject! as NSArray
            productCollectionModel = productCollectionModel + arrayData.map({(value) -> ProductCollectionModel in
                return  ProductCollectionModel(data:JSON(value))
            })
    }
}

class StoreCategoryCollectionViewModel {
    
    var storeCategoryCollectionModel = [StoreCategoryCollectionModel]()
    
    init(data:JSON){
            let arrayData = data["categories"].arrayObject! as NSArray
            storeCategoryCollectionModel =  arrayData.map({(value) -> StoreCategoryCollectionModel in
                return  StoreCategoryCollectionModel(data:JSON(value))
            })
    }
    
    var getStoreCategoryCollectionData:Array<StoreCategoryCollectionModel>{
        return storeCategoryCollectionModel
    }
    
    
    func setStoreCategoryCollectionData(data:JSON){
            let arrayData = data["products"].arrayObject! as NSArray
            storeCategoryCollectionModel = storeCategoryCollectionModel + arrayData.map({(value) -> StoreCategoryCollectionModel in
                return  StoreCategoryCollectionModel(data:JSON(value))
            })
        
    }
    
}
