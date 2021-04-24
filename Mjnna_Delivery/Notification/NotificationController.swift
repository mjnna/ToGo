////
////  NotificationController.swift
////  Magento2MobikulNew
////
////  Created by Kunal Parsad on 04/08/17.
////  Copyright © 2017 Kunal Parsad. All rights reserved.
////
//
//import UIKit
//import Alamofire
//
//class NotificationController: UIViewController,UITableViewDelegate, UITableViewDataSource {
//    
//    @IBOutlet weak var notificationTableView: UITableView!
//    
//    let defaults = UserDefaults.standard
//    var notificationViewModel:NotificationViewModel!
//    var productId:String = ""
//    var productName:String = ""
//    var refreshControl:UIRefreshControl!
//    var emptyView:EmptyNewAddressView!
//    var categoryId:String = ""
//    var categoryName:String = ""
//    var categoryType:String = ""
//    var message:String = ""
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "notification")
//        notificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
//        self.navigationController?.isNavigationBarHidden = false
//        
//        //pull to refresh
//        refreshControl = UIRefreshControl()
//        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//        let attributedTitle = NSAttributedString(string: NetworkManager.sharedInstance.language(key: "pulltorefresh"), attributes: attributes)
//        refreshControl.attributedTitle = attributedTitle
//        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
//        if #available(iOS 10.0, *) {
//            notificationTableView.refreshControl = refreshControl
//        } else {
//            notificationTableView.backgroundView = refreshControl
//        }
//        emptyView = EmptyNewAddressView(frame: self.view.frame);
//        self.view.addSubview(emptyView)
//        emptyView.isHidden = true;
//        emptyView.emptyImages.image = UIImage(named: "Yellow-notification-bell-icon-incoming-inbox-message-alarm-Clipart-PNG")!
//        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "gotohome"), for: .normal)
//        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "emptynotification")
//        emptyView.addressButton.isHidden = true
//        
//    }
//    
//    @objc func browseCategory(sender: UIButton){
//        self.tabBarController?.selectedIndex = 0
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
//        callingHttppApi()
//    }
//    
//    //MARK:- Pull to refresh
//    @objc func refresh(_ refreshControl: UIRefreshControl) {
//        self.refreshControl.endRefreshing()
//        callingHttppApi()
//    }
//    
//    func loginRequest(){
//        var loginRequest = [String:String]();
//        loginRequest["apiKey"] = API_USER_NAME;
//        loginRequest["apiPassword"] = API_KEY.md5;
//        if self.defaults.object(forKey: "language") != nil{
//            loginRequest["language"] = self.defaults.object(forKey: "language") as? String;
//        }
//        if self.defaults.object(forKey: "currency") != nil{
//            loginRequest["currency"] = self.defaults.object(forKey: "currency") as? String;
//        }
//        if self.defaults.object(forKey: "customer_id") != nil{
//            loginRequest["customer_id"] = self.defaults.object(forKey: "customer_id") as? String;
//        }
//        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
//            if val == 1{
//                let dict = responseObject as! NSDictionary
//                self.defaults.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
//                self.defaults.set(dict.object(forKey: "language") as! String, forKey: "language")
//                self.defaults.set(dict.object(forKey: "currency") as! String, forKey: "currency")
//                self.defaults.synchronize();
//                self.callingHttppApi()
//            }else if val == 2{
//                NetworkManager.sharedInstance.dismissLoader()
//                self.callingHttppApi()
//            }
//        }
//    }
//    
//    func callingHttppApi(){
//        DispatchQueue.main.async{
//            self.view.isUserInteractionEnabled = false
//            NetworkManager.sharedInstance.showLoader()
//            let sessionId = self.defaults.object(forKey:"wk_token");
//            var requstParams = [String:Any]();
//            requstParams["wk_token"] = sessionId;
//            requstParams["width"] = SCREEN_WIDTH
//            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"catalog/viewNotifications", cuurentView: self){success,responseObject in
//                
//                if success == 1 {
//                    self.view.isUserInteractionEnabled = true
//                    let dict = responseObject as! NSDictionary;
//                    if dict.object(forKey: "fault") != nil{
//                        let fault = dict.object(forKey: "fault") as! Bool;
//                        if fault == true{
//                            self.loginRequest()
//                        }
//                    }else{
//                        self.notificationViewModel = NotificationViewModel(data:JSON(responseObject as! NSDictionary))
//                        self.doFurtherProcessingWithResult()
//                        NetworkManager.sharedInstance.dismissLoader()
//                    }
//                }else if success == 2{
//                    NetworkManager.sharedInstance.dismissLoader()
//                    self.callingHttppApi()
//                }
//            }
//        }
//    }
//    
//    
//    func doFurtherProcessingWithResult(){
//        DispatchQueue.main.async {
//            if  self.notificationViewModel.getNotificationData.count > 0{
//                self.notificationTableView.delegate = self
//                self.notificationTableView.dataSource = self
//                self.notificationTableView.rowHeight = UITableView.automaticDimension
//                self.notificationTableView.estimatedRowHeight = 20
//                self.notificationTableView.reloadData()
//            }else{
//                self.notificationTableView.isHidden = true
//                self.emptyView.isHidden = false
//            }
//            
//            
//        }
//    }
//    
//    public func numberOfSections(in tableView: UITableView) -> Int{
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        return notificationViewModel.getNotificationData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let CellIdentifier: String = "notificationCell"
//        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! NotificationTableViewCell
//        cell.titleText.text = notificationViewModel.getNotificationData[indexPath.row].title;
//        cell.contentsText.text = notificationViewModel.getNotificationData[indexPath.row].subtitle;
//        cell.notificationImage.loadImageFrom(url:notificationViewModel.notificationModel[indexPath.row].imageData , dominantColor: notificationViewModel.notificationModel[indexPath.row].dominant_color)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let type:String = notificationViewModel.getNotificationData[indexPath.row].notificationType
//        if type == "product"{
//            productId = notificationViewModel.getNotificationData[indexPath.row].id
//            productName = notificationViewModel.getNotificationData[indexPath.row].title
//            self.performSegue(withIdentifier: "catalogproduct", sender: self);
//        }else if type == "Custom"{
//            categoryType = "custom"
//            categoryName = notificationViewModel.getNotificationData[indexPath.row].title
//            categoryId = notificationViewModel.getNotificationData[indexPath.row].id
//            self.performSegue(withIdentifier: "productcategory", sender: self)
//        }else if type == "category"{
//            categoryType = ""
//            categoryName = notificationViewModel.getNotificationData[indexPath.row].title
//            categoryId = notificationViewModel.getNotificationData[indexPath.row].id
//            self.performSegue(withIdentifier: "productcategory", sender: self)
//        }else if type == "other"{
//            self.message = notificationViewModel.getNotificationData[indexPath.row].contet
//            self.productName = notificationViewModel.getNotificationData[indexPath.row].title
//            self.performSegue(withIdentifier: "other", sender: self)
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier! == "catalogproduct") {
//            let viewController:CatalogProduct = segue.destination as UIViewController as! CatalogProduct
//            viewController.productImageUrl = ""
//            viewController.productId = self.productId
//            viewController.productName = self.productName
//            viewController.productPrice = ""
//        }else  if (segue.identifier! == "other") {
//            /*let viewController:OtherViewController = segue.destination as UIViewController as! OtherViewController
//            viewController.titleValue = self.productName
//            viewController.message = self.message*/
//            
//        }
//    }
//}
