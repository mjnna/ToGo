//
/**
* Webkul Software.
* @package  MobikulOpencartMp
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: ContactUsModel.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/
import Foundation

struct ContactUsModel {
    
    var image_height: String
    var geolocation: String
    var address: String
    var image: String
    var open: String
    var fax: String
    var telephone: String
    var store: String
    var error: String
    var comment: String
    var image_width: String
    
    init(data: JSON) {
        image_height = data["image_height"].stringValue
        geolocation = data["geolocation"].stringValue
        address = data["address"].stringValue
        image = data["image"].stringValue
        open = data["open"].stringValue
        fax = data["fax"].stringValue
        telephone = data["telephone"].stringValue
        store = data["store"].stringValue
        error = data["error"].stringValue
        comment = data["comment"].stringValue
        image_width = data["image_width"].stringValue
    }
    
}
