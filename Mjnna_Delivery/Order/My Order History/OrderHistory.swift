//
//  OrderHistory.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//




import UIKit
import Alamofire

class OrderHistory: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    var orderHistoryViewModel:OrderHistoryViewModel!
    let defaults = UserDefaults.standard
    var orderDateAdded : String = ""
    var refreshControl:UIRefreshControl!
    var totalCount:Int = 0
    var indexPathValue:IndexPath!
    var emptyView:EmptyNewAddressView!
    var whichApiToProcess:String = ""
    var order_productId:String = ""
    
    var orderId : String = ""
    var sessionId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.title = NetworkManager.sharedInstance.language(key: "myorder")
        
        ordersTableView.register(MyOrderTableViewCell.self, forCellReuseIdentifier: "cell")
        ordersTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        
        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "empty_order")!
        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "browsecategory"), for: .normal)
        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "orderempty")
        emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        
        ordersTableView.rowHeight = UITableView.automaticDimension
        self.ordersTableView.estimatedRowHeight = 200
        ordersTableView.separatorColor = UIColor.clear
        
        callingHttppApi()
        
        //pull to refresh
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: NetworkManager.sharedInstance.language(key: "pulltorefresh"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            ordersTableView.refreshControl = refreshControl
        } else {
            ordersTableView.backgroundView = refreshControl
        }
    }
    
    
    @objc func browseCategory(sender: UIButton){
        self.tabBarController!.selectedIndex = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Pull to refresh
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.refreshControl.endRefreshing()
        callingHttppApi()
    }
    
    //MARK:- API Call
    
    func loginRequest(){
        var loginRequest = [String:String]();
        guard let userSession = sharedPrefrence.object(forKey:"token") as? String else {return}
        loginRequest["token"] = userSession
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

        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        if let sessionId = self.defaults.object(forKey:"token") as? String {
            if sessionId.isEmpty{
                NetworkManager.sharedInstance.dismissLoader()
                self.tabBarController?.selectedIndex = 2
            }else{
                var requstParams = [String:Any]();
                requstParams["token"] = sessionId
                //requstParams["page"] = "\(self.pageNumber)"
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"order/list", cuurentView: self){success,responseObject in
                    if success == 1 {
                        
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "error") == nil{
                            
                            self.view.isUserInteractionEnabled = true
                            NetworkManager.sharedInstance.dismissLoader()

                            self.orderHistoryViewModel = OrderHistoryViewModel(data: JSON(responseObject as! NSDictionary))
                            self.ordersTableView.delegate = self
                            self.ordersTableView.dataSource = self
                            self.ordersTableView.reloadData()
                                self.doFurtherProcessingWithResult()
                            
                        }else{
                            self.loginRequest()
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            if self.orderHistoryViewModel.getOrdersData.count > 0{
                self.ordersTableView.delegate = self
                self.ordersTableView.dataSource = self
                self.ordersTableView.reloadData()
                self.emptyView.isHidden = true
                self.ordersTableView.isHidden = false
            }else{
                self.ordersTableView.isHidden = true
                self.emptyView.isHidden = false
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    

}

extension OrderHistory: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.orderHistoryViewModel.getOrdersData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyOrderTableViewCell
        let orderData = self.orderHistoryViewModel.getOrdersData[indexPath.row]
        let deliveryDateWord = "Delevery date: ".localized
        cell.configure(invoiceId:orderData.orderId,
                       status: orderData.status,
                       statusId: orderData.statusId,
                       price: orderData.total,
                       date: deliveryDateWord+orderData.date)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
        
        if(orderHistoryViewModel.getOrdersData[indexPath.row].statusId == 6){
            let orderViewController = storyboard!.instantiateViewController(withIdentifier: "orderReject") as! OrderRejectedViewController
            
            orderViewController.response = orderHistoryViewModel.getOrdersData[indexPath.row].storeResponse
            
            orderViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(orderViewController, animated: true)
        }
        else{
            sessionId = orderHistoryViewModel.getOrdersData[indexPath.row].statusId
            orderId = orderHistoryViewModel.getOrdersData[indexPath.row].orderId
            self.performSegue(withIdentifier: "OrderDeatails", sender: self)

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "OrderDeatails") {
            if let viewController:OrderDetailsViewController = segue.destination as? OrderDetailsViewController{
                viewController.sessionId = sessionId
                viewController.orderId = orderId
            }
            
        }
        
    }

}
