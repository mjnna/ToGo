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
    var option:Array<Any>!
    var quantity:Int = 0
    var specialPrice:Float = 0
    var formatted_special:String = ""
    
    
    init(data: JSON) {
        self.productName = data["product"]["name"].stringValue
        self.descriptionData = data["product"]["description"].stringValue
        
        self.price = data["product"]["price"].stringValue
        self.exTaxTxt = data["product"]["langArray"]["text_tax"].stringValue
        let tx = data["product"]["tax"].stringValue
        self.taxAmount = (tx == "0" || tx == "false" ) ? "" : tx
        self.option = data["product"]["product_options"].arrayObject
        
        self.specialPrice = data["product"]["feature_price"].floatValue
        
        self.formatted_special = data["product"]["feature_price"].stringValue
       
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
    
    var getOption:Array<Any>{
        return catalogProductModel.option;
    }
    
    var getProductName: String {
        return catalogProductModel.productName;
    }
    var getPrice: String {
        return catalogProductModel.price;
    }
    
    var getExTaxTxt: String {
        return catalogProductModel.exTaxTxt;
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





