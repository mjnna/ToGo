//
//  CatalogProductModel.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 12/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class CatalogProductModel: NSObject {
    var productName:String!
    var descriptionData:String!
    var price:String!
    var exTaxTxt:String!
    var taxAmount:String!
    var options:[Option]!
    var quantity:Int = 0
    var specialPrice:Float = 0
    var formatted_special:String = ""
    var isFeatured:Int

    
    init(data: JSON) {
        self.productName = data["product"]["name"].stringValue
        self.descriptionData = data["product"]["description"].stringValue
        
        self.price = data["product"]["price"].stringValue
        self.exTaxTxt = data["product"]["langArray"]["text_tax"].stringValue
        let tx = data["product"]["tax"].stringValue
        self.taxAmount = (tx == "0" || tx == "false" ) ? "" : tx
        
        if let option = data["product"]["product_options"].array{
            self.options =  option.map({(value) -> Option in
                return  Option(data:value)
            })
        }
        
        self.specialPrice = data["product"]["feature_price"].floatValue
        
        self.formatted_special = data["product"]["feature_price"].stringValue
        self.isFeatured = data["product"]["is_featured"].intValue
    }
    
}
class Option:NSObject{
    var id:Int!
    var maxSelected:Int!
    var name: String!
    var choices: [Choice]!
    
    init(data: JSON) {
        self.id = data["id"].intValue
        self.name = data["name"].stringValue
        self.maxSelected = data["max_select"].intValue
        if let choice = data["choices"].array{
            self.choices =  choice.map({(value) -> Choice in
                return  Choice(data:value)
            })
        }
    }
}

class Choice:NSObject {
    let id:Int
    let name:String
    let price:String
    let weight:String
    init(data:JSON){
        self.id = data["id"].intValue
        self.name = data["name"].stringValue
        self.price = data["price"].stringValue
        self.weight = data["weight"].stringValue
    }
}

class Productimages:NSObject{
    var imageURL:String = ""
    
    init(data:JSON) {
        self.imageURL = data.stringValue
    }
    
}




class CatalogProductViewModel:NSObject{
    var catalogProductModel:CatalogProductModel!
    var productImages = [Productimages]()
    
    
    init(productData:JSON) {
        for i in 0..<productData["product"]["images"].count{
            let dict = productData["product"]["images"][i];
            productImages.append(Productimages(data: dict))
        }
        catalogProductModel = CatalogProductModel(data:productData)
        
        
    }
    
    
    init(catalogPageData: CatalogProductModel) {
        self.catalogProductModel = catalogPageData
    }
    
    var getProductImages:Array<Productimages>{
        return productImages
    }
    
    var getOptions:[Option]{
        return catalogProductModel.options
    }
    
    var getProductName: String {
        return catalogProductModel.productName
    }
    var getPrice: String {
        return catalogProductModel.price
    }
    
    var getExTaxTxt: String {
        return catalogProductModel.exTaxTxt;
    }
    var isFeatured: Bool {
        print(catalogProductModel.isFeatured)
        if catalogProductModel.isFeatured == 0 {
            return false
        }else{
            return true
        }
    }
    var getTaxAmount: String {
        return catalogProductModel.taxAmount;
    }
    var getdescriptionData:String{
        return catalogProductModel.descriptionData
    }
    
    var getSpecialprice:Float{
        return catalogProductModel.specialPrice;
    }
}





