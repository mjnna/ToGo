//
//  TrackOrderViewController.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 08/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    //MARK:- View component

    lazy var orderProductTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tv.register(OrderProductCell.self, forCellReuseIdentifier: "productCell")
        tv.register(InvoiceInfoCell.self, forCellReuseIdentifier: "invoiceCell")
        return tv
    }()
    
    //MARK: - Properties
    var sessionId:Int = 0
    var orderId:String?
    var orderProducts = [OrderProduct]()
    var recivedOrder: Order?
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0

    
    //MARK:- Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginRequest()
        stupView()
    }
    
    private func stupView(){
       
        self.view.addSubview(orderProductTableView)
        orderProductTableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor)
        
        setupTableView()
        shwoLoder(show: true)

    }
    
    //MARK: - Net Working
    func loginRequest(){
        var loginRequest = [String:String]();
        
        guard let token = sharedPrefrence.object(forKey:"token") as? String else {return}
        loginRequest["token"] = token
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"refresh", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"] != nil{
                    print("go to login page")
                }
                else{
                    sharedPrefrence.set(dict["newToken"].stringValue , forKey: "token")
                    sharedPrefrence.synchronize();
                    self.callingHttppApi()
                }
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
            }
        }
    }
    
    func callingHttppApi(){
        let sessionId = sharedPrefrence.object(forKey:"token") as! String;
        var requstParams = [String:String]()
        requstParams["token"] = sessionId
        requstParams["order_id"] = orderId
        if let lang = sharedPrefrence.object(forKey: "language") as? String{
            requstParams["lang"] = lang
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"order/details",cuurentView: self){val,responseObject in
               if val == 1 {
                   self.view.isUserInteractionEnabled = true
                   let dict = JSON(responseObject as! NSDictionary)
                   if dict["error"] != nil{
                      //display the error to the customer
                    if dict["error"] == "authentication required"{
                        self.loginRequest()
                    }
                    
                   }
                   else{
                    self.shwoLoder(show: false)
                    // go to the details page
                    print(dict)
                    let order = Order(data: dict)
                    self.recivedOrder = order
                    self.orderProducts = order.orderProducts
                    self.orderProductTableView.reloadData()
                   }
                   
               }
               else{
                   NetworkManager.sharedInstance.dismissLoader()
                   self.callingHttppApi()
               }
        }
    }
    
    func shwoLoder(show:Bool){
        self.orderProductTableView.isHidden = show
        if show{
            NetworkManager.sharedInstance.showLoader()
        }else{
            NetworkManager.sharedInstance.dismissLoader()
        }
    }


}

extension OrderDetailsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func setupTableView(){
        orderProductTableView.delegate = self
        orderProductTableView.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return orderProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell", for: indexPath) as! InvoiceInfoCell
            cell.contentView.isUserInteractionEnabled = true
            if let order = recivedOrder {
                cell.configure(storeName: order.store, InoviceNo: order.id, statusId: order.order_status_id, total: order.total_price)
                cell.getStatus(viewController: self)
            }
            return  cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! OrderProductCell
            let product = orderProducts[indexPath.row]
            cell.configure(images: product.images, name: product.name, whight: product.totalWeight, quantity: product.quantity, price: product.totalPrice)
            return  cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 270
        }else{
            return 140
        }
        
    }
    
}
