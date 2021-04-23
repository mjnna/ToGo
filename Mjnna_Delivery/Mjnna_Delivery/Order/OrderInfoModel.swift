//
//  OrderInfoModel.swift
//  OpenCartApplication
//
//  Created by shobhit on 30/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class OrderInfoViewModel{

    var orderInfoDataModel:OrderInfoModel!
    var productsInfoDataModel = [ProductsInfoModel]()
    var orderHistoryInfoDataModel = [OrderHistoryInfoModel]()
    var totalsDataModel = [TotalsModel]()
    var boy_id:String = ""
    var boy_image:String = ""
    var boy_name:String = ""
    var boy_telephone:String = ""
    var boy_vehicle:String = ""
    var delivery_code:String = ""
    
    init(data:JSON) {
        
        for key in data["products"].arrayValue{
            productsInfoDataModel.append(ProductsInfoModel(data: key))
        }
        
        for i in 0..<data["histories"].count{
            let dict = data["histories"][i];
            orderHistoryInfoDataModel.append(OrderHistoryInfoModel(data: dict))
        }

        for i in 0..<data["totals"].count{
            let dict = data["totals"][i];
            totalsDataModel.append(TotalsModel(data: dict))
        }

        self.orderInfoDataModel = OrderInfoModel(data: data)
        
        boy_id = data["boy_id"].stringValue
        boy_image = data["boy_image"].stringValue
        boy_name = data["boy_name"].stringValue
        boy_telephone = data["boy_telephone"].stringValue
        boy_vehicle = data["boy_vehicle"].stringValue
        delivery_code = data["delivery_code"].stringValue
    }
    
    var getProductsInfoData:Array<ProductsInfoModel>{
        return productsInfoDataModel
    }

    var getOrderHistoryInfoData:Array<OrderHistoryInfoModel>{
        return orderHistoryInfoDataModel
    }

    var getTotalsData:Array<TotalsModel>{
        return totalsDataModel
    }
}


class OrderInfoModel: NSObject {
    var paymentAddress:String = ""
    var shippingAddress:String = ""
    var paymentMethod:String = ""
    var shippingMethod:String = ""

    init(data : JSON) {
        self.paymentAddress = data["payment_address"].stringValue.html2String
        self.shippingAddress = data["shipping_address"].stringValue.html2String
        self.paymentMethod = data["payment_method"].stringValue
        self.shippingMethod = data["shipping_method"].stringValue
    }
}


class TotalsModel{
    var text:String = ""
    var title:String = ""

    init(data : JSON) {
        self.text = data["text"].stringValue
        self.title = data["title"].stringValue
    }
}


class ProductsInfoModel{
    var name:String = ""
    var model:String = ""
    var price:String = ""
    var quantity:String = ""
    var subTotal:String = ""
    var option = [OptionModel]()
    var productId:String = ""
    var order_productID:String = ""

    init(data : JSON) {
        self.name = data["name"].stringValue
        self.model = data["model"].stringValue
        self.price = data["price"].stringValue
        self.quantity = data["quantity"].stringValue
        self.subTotal = data["total"].stringValue
        self.order_productID = data["order_product_id"].stringValue
        
        self.productId = data["product_id"].stringValue
        
        if let arrayData = data["option"].arrayObject{
            option =  arrayData.map({(value) -> OptionModel in
                return  OptionModel(data:JSON(value))
            })
        }
    }
}


struct OptionModel{

    var name:String = ""
    var value:String = ""
    init(data:JSON) {
        self.name = data["name"].stringValue
        self.value = data["value"].stringValue
    }
}


class OrderHistoryInfoModel{
    var comment: String
    var dateAdded: String
    var status: String
    
    init(data : JSON) {
        self.comment = data["comment"].stringValue
        self.dateAdded = data["date_added"].stringValue
        self.status = data["status"].stringValue
    }
}
