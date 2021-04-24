//
//  OrderDetailsViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 1/6/21.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit

class TrackOrderViewController: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var OrderNo: UILabel!
    
  
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondeView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourtheView: UIView!
    @IBOutlet weak var fifthView: UIView!
    
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondeLineView: UIView!
    @IBOutlet weak var thirdLineView: UIView!
    @IBOutlet weak var fourthLineView: UIView!
    
    @IBOutlet weak var infoView: DashedView!
    
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var deliveryTitle: UILabel!
    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var storeTitle: UILabel!

    @IBOutlet weak var storeValue: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var deliveryPriceValue: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var acceptedByStoreLabel: UILabel!
    @IBOutlet weak var acceptedByDriverLabel: UILabel!
    @IBOutlet weak var ouToDeliveryLabel: UILabel!
    @IBOutlet weak var deliverdLabel: UILabel!

    
    //MARK:- Properties
    enum StatusColor : Int{ case gray = 0,gold}
    enum OrderStatus:Int {case pending = 0 ,acceptedByStore,acceptedByDriver,outToDelivery,deliverd,rejected}
    
    
    //MARK:- Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    
    
    //MARK:- Handler
    private func setUpViews() {
        setupCirclStatusView(view: firstView)
        setupCirclStatusView(view: secondeView)
        setupCirclStatusView(view: thirdView)
        setupCirclStatusView(view: fourtheView)
        setupCirclStatusView(view: fifthView)
        
        setuplineView(view: firstLineView)
        setuplineView(view: secondeLineView)
        setuplineView(view: thirdLineView)
        setuplineView(view: fourthLineView)
        
        self.pendingLabel.text = "Pending".localized
        self.acceptedByStoreLabel.text = "Accepted by the store".localized
        self.acceptedByDriverLabel.text = "Accepted by the driver".localized
        self.ouToDeliveryLabel.text = "Out to delivery".localized
        self.deliverdLabel.text = "Deliverd".localized
        
        self.storeTitle.text = "Store".localized
        self.priceTitle.text = "Price".localized
        self.deliveryTitle.text = "Delivery price".localized
        self.totalTitle.text = "Total".localized

        


    }
    
    private func setupCirclStatusView(view: UIView)
    {
        view.layer.cornerRadius = view.frame.height/2
        view.layer.masksToBounds = true
        view.layer.borderWidth = 10
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setuplineView(view:UIView){
        view.backgroundColor = .lightGray
    }


    private func paintView(views: [UIView],lines:[UIView]? = nil,statusColor:StatusColor){
        let goldColor:UIColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        let grayColor:UIColor = .lightGray

        switch statusColor {
        case .gray:
            views.forEach { (view) in
                view.layer.borderColor = grayColor.cgColor
                
            }
            lines?.forEach({ (line) in
                line.backgroundColor = grayColor
            })
        case .gold:
            views.forEach { (view) in
                view.layer.borderColor = goldColor.cgColor
                
            }
            lines?.forEach({ (line) in
                line.backgroundColor = goldColor
            })
          
        }
   
    }
     func trackOrder(statusId:Int){
        
        switch OrderStatus(rawValue: statusId) {
        case .pending:
            paintView(views: [firstView], statusColor: .gold)
        case .acceptedByStore:
            paintView(views: [firstView,secondeView], lines: [firstLineView], statusColor: .gold)
        case .acceptedByDriver:
            paintView(views: [firstView,secondeView,thirdView], lines: [firstLineView,secondeLineView], statusColor: .gold)
        case .outToDelivery:
            paintView(views: [firstView,secondeView,thirdView,fourtheView], lines: [firstLineView,secondeLineView,thirdView], statusColor: .gold)
        case .deliverd:
            paintView(views: [firstView,secondeView,thirdView,fourtheView,fifthView], lines: [firstLineView,secondeLineView,thirdView,fourthLineView], statusColor: .gold)
        case .rejected:
            print("go to rejected view")
        default:
            break
        }
    }

    func setupData(store:String,status:Int,price:String,deliveryPrice:String,totalPrice:String){
        self.storeValue.text = store
        self.trackOrder(statusId: status)
        self.priceValue.text = price + "SAR".localized
        self.deliveryPriceValue.text = deliveryPrice + "SAR".localized
        self.totalValue.text = totalPrice + "SAR".localized
    }
    func callingHttppApi(orderId:String){
        let sessionId = sharedPrefrence.object(forKey:"token") as! String;
        var requstParams = [String:String]()
        requstParams["token"] = sessionId
        requstParams["order_id"] = orderId
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"order/details",cuurentView: self){ [self]val,responseObject in
               if val == 1 {
                   self.view.isUserInteractionEnabled = true
                   let dict = JSON(responseObject as! NSDictionary)
                   if dict["error"] != nil{
                      //display the error to the customer
                    if dict["error"] == "authentication required"{
                        print("User Need To Login")
                    }
                    
                   }
                   else{
                    NetworkManager.sharedInstance.dismissLoader()
                    // go to the details page
                    let order = Order(data: dict)
                    setupData(store: order.store, status: order.order_status_id, price: order.price, deliveryPrice: order.delivery_price, totalPrice: order.total_price)
                    OrderNo.text = "Order No".localized + " " + orderId

                   }
                   
               }
               else{
                   NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi(orderId: orderId)
               }
        }
    }


    
}
