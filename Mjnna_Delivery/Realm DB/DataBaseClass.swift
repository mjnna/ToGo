//

/*
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul
 Created by: kunal on 16/07/18
 FileName: DataBaseClass.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */




import RealmSwift


class AllDataCollection:Object{
    @objc dynamic var ApiName:String = ""
    @objc dynamic var data:String = ""
    
    override static func primaryKey() -> String? {
        return "ApiName"
        
    }
    
}
