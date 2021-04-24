//
//  MyCart.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 29/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit


class MyCart: UIViewController,UpdateCartHandlerDelegate{
   
    //MARK:- Outlet
    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet var trashButton: UIBarButtonItem!
    
    @IBOutlet weak var pricesView: UIView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: ShadowButton!
    
    
    //MARK:- Properties
    let defaults = UserDefaults.standard;
    var extraHeight:CGFloat = 0
    var extraAmountHeight:CGFloat = 0
    var whichApiToProcess:String = ""
    var quantityDict = [String:String]();
    var productId:String!
    var voucharCode:String!
    var couponCode:String!
    var productName:String!
    var productPrice:String!
    var imageUrl:String!
    var emptyView:EmptyNewAddressView!
    var rewardPoint:String = ""
    var cartProductId:String!
    var quantity:String!
    var myCartViewModel:CartViewModel!
    var availableLocation:Bool = false
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hi khaled
        
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "Cart")
        self.navigationController?.isNavigationBarHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearCartData), name: NSNotification.Name(rawValue: "cartclearnotification"), object: nil)
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(userSetLocation(_:)), name: .availablelocation, object: nil)
        
        setupView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.view.isUserInteractionEnabled = true
        if GlobalVariables.proceedToCheckOut == true{
            self.tabBarController?.tabBar.items?[1].badgeValue = nil
            self.tabBarController?.selectedIndex = 0
            GlobalVariables.proceedToCheckOut = false
        }else{
            whichApiToProcess = ""
            extraHeight = 0
            callingHttppApi()
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupView(){
        pricesView.dropShadow(radius: 6, opacity: 0.4, color: .gray)
        
        cartTableView.rowHeight = UITableView.automaticDimension
        self.cartTableView.estimatedRowHeight = 50
        cartTableView.separatorColor = UIColor.clear
        checkoutButton.addCorner(with: 25)
        let checkOutWord = NetworkManager.sharedInstance.language(key: "checkout")
        checkoutButton.addTitle(title: checkOutWord.localized, fontSize: 20)
        checkoutButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        
        trashButton.isEnabled = false
       
        
        whichApiToProcess = "";
        
        cartTableView.separatorColor = UIColor.clear
        emptyView = EmptyNewAddressView(frame: self.view.frame);
        self.view.addSubview(emptyView)
        emptyView.isHidden = true;
        emptyView.emptyImages.image = UIImage(named: "02_Shopping_Bag-512(1)")!
        emptyView.addressButton.setTitle(NetworkManager.sharedInstance.language(key: "browsecategory"), for: .normal)
        emptyView.labelMessage.text = NetworkManager.sharedInstance.language(key: "cartempty")
        emptyView.addressButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        emptyView.addressButton.isHidden = true
        //emptyView.addressButton.addTarget(self, action: #selector(browseCategory(sender:)), for: .touchUpInside)
        
        cartTableView.register(UINib(nibName: "PriceCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCellTableViewCell")
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: "cell")
        cartTableView.register(UINib(nibName: "ExtraCartTableViewCell", bundle: nil), forCellReuseIdentifier: "extracell")
        
        

        
    }
    //MARK:- Actions
  
    @objc func userSetLocation(_ notification:Notification) {
        if let available = notification.object as? Bool {
            availableLocation = available
            if available == true{
                
            }else{
//                let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocationList")
//                self.modalPresentationStyle = .overCurrentContext
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    @objc func clearCartData(_ note: Notification) {
        whichApiToProcess = ""
        self.callingHttppApi()
    }
    
    @objc func browseCategory(sender: UIButton){
        self.tabBarController?.selectedIndex = 2
    }
    
    
    @IBAction func trashClick(_ sender: UIBarButtonItem) {
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "pleaseconfirm"), message: NetworkManager.sharedInstance.language(key: "carttotalempty"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "delete"
            self.callingHttppApi()
            
            
        })
        let noBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @objc func viewProduct(_ recognizer: UITapGestureRecognizer) {
        productId = myCartViewModel.getProductData[(recognizer.view?.tag)!].priductId
        productName = myCartViewModel.getProductData[(recognizer.view?.tag)!].productName
        productPrice = myCartViewModel.getProductData[(recognizer.view?.tag)!].price
        imageUrl = myCartViewModel.getProductData[(recognizer.view?.tag)!].productImgUrl
        self.performSegue(withIdentifier: "myproduct", sender: self);
    }
    
    
    @objc func updateCart(sender: UIButton){
        whichApiToProcess = "updateCart";
        quantityDict = [String:String]()
        
        for i in 0..<myCartViewModel.getProductData.count{
            quantityDict[myCartViewModel.getProductData[i].key] = myCartViewModel.getProductData[i].quantity
            
        }
        callingHttppApi()
    }
    
    @available(iOS 13.4, *)
    @IBAction func proceedToCheckoutClick(_ sender: UIButton) {
        
        if myCartViewModel.checkout == 1{
            
            let token = defaults.object(forKey: "token")
            if token != nil{
                let newVC = self.storyboard!.instantiateViewController(withIdentifier: "checkoutOrder") as! CheckOutViewController
                newVC.modalPresentationStyle = .overFullScreen
                newVC.fastDelivery = myCartViewModel.fastDelivery
                self.navigationController?.pushViewController(newVC, animated: true)
                
            }else{
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
               
                let Existing = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "checkoutasexistingcustomer"), style: .default, handler: existingUser)
                let cancel = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .cancel, handler: cancelDeletePlanet)
                alert.addAction(Existing)
                alert.addAction(cancel)
                
                // Support display in iPad
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: self.myCartViewModel.errorMessage)
        }
    }
    
    
    
    @objc func removeFromToCart(sender: UIButton){
        
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "pleaseconfirm"), message: NetworkManager.sharedInstance.language(key: "cartemtyinfo"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "removeitem"
            self.productId = self.myCartViewModel.getProductData[sender.tag].key
            self.callingHttppApi();
            
            
        })
        let noBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
        
    }
    
    //MARK:- Handler
   
    func loginRequest(){
        var loginRequest = [String:String]();
        let token = self.defaults.object(forKey:"token")
        if(token == nil){
            self.view.isUserInteractionEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            self.tabBarController?.selectedIndex = 2
        }
        else{
        loginRequest["token"] = token as! String
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"refresh", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = responseObject as! NSDictionary
                if(dict.object(forKey: "error") != nil){

                    self.view.isUserInteractionEnabled = true
                    NetworkManager.sharedInstance.dismissLoader()
                    self.tabBarController?.selectedIndex = 2
                }
                else{
                    self.defaults.set(dict.object(forKey: "newToken") as! String, forKey: "token")
                self.defaults.synchronize();
                self.callingHttppApi()
                }
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
                
            }
            }
            
        }
    }
    
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            let sessionId = self.defaults.object(forKey:"token")
            var requstParams =  [String:Any]()
            requstParams["token"] = sessionId
            
            if self.whichApiToProcess == "updateCart"{
                
                do {
                    requstParams["quantity"] = self.quantity
                    requstParams["cart_product_id"] = self.cartProductId
                }
                catch {
                    print(error.localizedDescription)
                }
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams as! Dictionary<String, String>, apiname:"cart/edit", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            NetworkManager.sharedInstance.dismissLoader()
                            let dict = (responseObject as! NSDictionary)
                            if dict.object(forKey: "error") != nil{
                                self.loginRequest()
                            }
                            else{
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: "cart updated successfully".localized)
                                self.doFurtherProcessingWithResult()
                                
                            }
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
                
            }else if self.whichApiToProcess == "delete"{
                NetworkManager.sharedInstance.showLoader()
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams as! Dictionary<String, String>, apiname:"cart/clear", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "error") != nil{
                                self.loginRequest()
                        }else{
                            NetworkManager.sharedInstance.dismissLoader()
                            self.view.isUserInteractionEnabled = true;
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: "cart updated successfully".localized)
                            self.doFurtherProcessingWithResult()
                            
                            self.whichApiToProcess = ""
                            self.callingHttppApi()
                            
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
                
            }
                
            else if self.whichApiToProcess == "removeitem"{
                NetworkManager.sharedInstance.showLoader()
                requstParams["cart_product_id"] = self.cartProductId;
                requstParams["quantity"] = "0"
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams as! Dictionary<String, String>, apiname:"cart/edit", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "error") != nil{
                            self.loginRequest()
                        }else{
                            NetworkManager.sharedInstance.dismissLoader()
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: "cart updated successfully".localized)
                            self.doFurtherProcessingWithResult()
                            
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
                
            }
            else{
             
                NetworkManager.sharedInstance.showLoader()
                requstParams["token"] = sessionId;
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/details", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "error") != nil{
                            self.loginRequest()
                        }else{
                            self.view.isUserInteractionEnabled = true
                            self.myCartViewModel = nil
                            self.myCartViewModel = CartViewModel(data: JSON(responseObject as! NSDictionary))
                            self.doFurtherProcessingWithResult()
                            NetworkManager.sharedInstance.dismissLoader()
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
            self.view.isUserInteractionEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            if self.whichApiToProcess == "updateCart"{
                self.whichApiToProcess = ""
                self.callingHttppApi()
            }
            else if self.whichApiToProcess == "removeitem" || self.whichApiToProcess == "clearitem"{
                self.whichApiToProcess = ""
                self.callingHttppApi()
            }
            else{
                
                if self.myCartViewModel.getProductData.count > 0{
                    let badge = self.myCartViewModel.getTotalProducts
                    NotificationCenter.default.post(name: .cartBadge, object: badge)
                    self.checkoutButton.isHidden = false;
                    self.myCartViewModel.checkout = 1
                    self.cartTableView.delegate = self
                    self.cartTableView.dataSource = self
                    self.cartTableView.reloadData()
                    self.cartTableView.isHidden = false
                    self.emptyView.isHidden = true
                    self.trashButton.isEnabled = true
                    NetworkManager.sharedInstance.updateCartShortCut(count:self.myCartViewModel.getTotalProducts,succ:true)
                }else{
                    NotificationCenter.default.post(name: .cartBadge, object: "")
                    self.checkoutButton.isHidden = true
                    self.cartTableView.isHidden = true
                    self.emptyView.isHidden = false
                    self.trashButton.isEnabled = false
                    NetworkManager.sharedInstance.updateCartShortCut(count:self.myCartViewModel.getTotalProducts,succ:false)
                    UIView.animate(withDuration: 1, animations: {() -> Void in
                        self.emptyView.emptyImages.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    }, completion: {(_ finished: Bool) -> Void in
                        UIView.animate(withDuration: 1, animations: {() -> Void in
                            self.emptyView.emptyImages.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                    })
                }
            }
        }
    }
    
    
    func updateAPICall(index: Int){
        whichApiToProcess = "updateCart";
        
        self.quantity = myCartViewModel.getProductData[index].quantity
        self.cartProductId = myCartViewModel.getProductData[index].cartProductId
            
        callingHttppApi()
        
    }
    


    func checkOutAsGuest(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "proceddToCheckout", sender: self)
    }
    
    func registerAndCheckOut(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "cartToCreateAccount", sender: self)
    }
    
    func existingUser(alertAction: UIAlertAction!) {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
           tabBarController.selectedIndex = 2
  
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
    }
    
    func openProduct(_sender : UITapGestureRecognizer){
        productName = myCartViewModel.getProductData[(_sender.view?.tag)!].productName
        productId = myCartViewModel.getProductData[(_sender.view?.tag)!].priductId
        imageUrl = myCartViewModel.getProductData[(_sender.view?.tag)!].productImgUrl
        productPrice = myCartViewModel.getProductData[(_sender.view?.tag)!].price
        self.performSegue(withIdentifier: "myproduct", sender: self)
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "myproduct") {
            let viewController:CatalogProduct = segue.destination as UIViewController as! CatalogProduct
            viewController.productImageUrl = self.imageUrl
            viewController.productId = self.productId
            viewController.productName = self.productName
            viewController.productPrice = self.productPrice
            viewController.isCart = true
        }
    }

    
}

extension MyCart:UITableViewDelegate, UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return myCartViewModel.getProductData.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartTableViewCell
            let product = myCartViewModel.getProductData[indexPath.row]
            cell.productName.text = product.productName
//            let priceTitle:String = NetworkManager.sharedInstance.language(key: "price")
            let subTotalTitle:String = NetworkManager.sharedInstance.language(key: "subtotal")

            cell.priceLabel.text = product.price
            cell.subTotalLabel.text = "\(subTotalTitle): \(product.subTotal)"
            cell.productImageView.loadImageFrom(url:product.productImgUrl , dominantColor: "")
            cell.descriptionLabel.text = product.desc
            let optionArray = product.optionData
            cell.quantityValueTextField.text = product.quantity
            cell.quantityStepper.tag = indexPath.row
            cell.myCartViewModel = myCartViewModel
            cell.quantityStepper.value = Double(product.quantity)!
            
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(removeFromToCart(sender:)), for: .touchUpInside)
//            cell.arTag.isHidden = true
            
            if let totalValue = myCartViewModel.getTotalAmount[0].text{

                let totalWord = "Total ".localized
                let fullString = totalWord + totalValue

                totalPriceLabel.attributedText = coloringSpacificWrod(fullString: fullString, colerdWord: totalValue,color:#colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1))
                
            }
            if let subTotal = myCartViewModel.getTotalAmount[1].text {
                let subTotalWord = "Sub total ".localized
                let fullString = subTotalWord + subTotal
                self.subTotalLabel.attributedText =  coloringSpacificWrod(fullString: fullString, colerdWord: subTotal, color: #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1))
            }
            if let deliveryPrice = myCartViewModel.getTotalAmount[2].text {
                let deliveryWord = "Delivery ".localized
                let fullString = deliveryWord + deliveryPrice
                self.subTotalLabel.attributedText =  coloringSpacificWrod(fullString: fullString, colerdWord: deliveryPrice, color: #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1))
            }
        
            let Gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.viewProduct))
            Gesture1.numberOfTapsRequired = 1
            cell.productImageView.isUserInteractionEnabled = true
            cell.productImageView.addGestureRecognizer(Gesture1)
            cell.productImageView.tag = indexPath.row

            
            var optionData:String = ""
            
            for i in 0..<optionArray.count{
                let dict = optionArray[i] ;
                if i != 0 {
                    optionData += "\n"
                }
                var choicesData:Array<JSON>
                choicesData = dict["choices"].arrayValue
                if(choicesData.count == 0){
                    optionData += dict["name"].stringValue+" : "+dict["choices"]["name"].stringValue + "(" + dict["choices"]["price"].stringValue + ")"
                    
                }else{
                    optionData += dict["name"].stringValue+" : "
                     for i in 0..<choicesData.count{
                        let choice =  choicesData[i]
                        optionData += choice["name"].stringValue + "(" + choice["price"].stringValue + ") "
                        print(choice)
                    }
                    
                }
            }
//            cell.extraLabel.text = optionData
            
            if !myCartViewModel.getProductData[indexPath.row].isAnimate{
                cell.productImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    cell.productImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: {(_ finished: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        cell.productImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.myCartViewModel.getProductData[indexPath.row].isAnimate = true
                    })
                })
            }
            
            cell.delegate = self
            cell.quantityIndcator.stopAnimating()
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

