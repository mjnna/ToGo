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
    
    
    
    
    let emptyCartView: EmptyCartView = {
        let v = EmptyCartView()
        v.browsButton.addTarget(self, action: #selector(browseCategory), for: .touchUpInside)
        return v
    }()
    
    lazy var popupView: AddLocationPopup = {
        let v = AddLocationPopup()
        v.button.addTarget(self, action: #selector(addLocationPreesed), for: .touchUpInside)
        return v
    }()
    
    lazy var bullerEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    //MARK:- Properties
    let defaults = UserDefaults.standard
    var productId:String!
    var quantityDict = [String:String]();
    var productName:String!
    var productPrice:String!
    var imageUrl:String!
    var cartProductId:String!
    var quantity:String!
    var cartViewModel: CartViewModel?

    var topAnchorr: NSLayoutConstraint?
    var bottomAnchorr: NSLayoutConstraint?
    
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "Cart")
        self.navigationController?.isNavigationBarHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearCartData), name: NSNotification.Name(rawValue: "cartclearnotification"), object: nil)
        self.tabBarController?.tabBar.isHidden = true
      
        setupView()
        refreshCartProductsList()
        checkCartIsEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCartIsEmpty()
        self.tabBarController?.tabBar.isHidden = true
        self.view.isUserInteractionEnabled = true
        if GlobalVariables.proceedToCheckOut == true{
            self.tabBarController?.tabBar.items?[1].badgeValue = nil
            self.tabBarController?.selectedIndex = 0
            GlobalVariables.proceedToCheckOut = false
        }else{
            refreshCartProductsList()
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func checkCartIsEmpty(){
        if cartViewModel?.getProductData.count != 0{
            pricesView.isHidden = false
            emptyCartView.isHidden = true
        }else{
            pricesView.isHidden = true
            emptyCartView.isHidden = false
        }
    }
    
    func setupView(){
        pricesView.dropShadow(radius: 6, opacity: 0.4, color: .gray)
        
        cartTableView.rowHeight = UITableView.automaticDimension
        self.cartTableView.estimatedRowHeight = 50
        cartTableView.separatorStyle = .none
        cartTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        checkoutButton.addCorner(with: 25)
        let checkOutWord = NetworkManager.sharedInstance.language(key: "checkout")
        checkoutButton.addTitle(title: checkOutWord.localized, fontSize: 20)
        checkoutButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        
        self.view.addSubview(emptyCartView)
        emptyCartView.anchor( left: self.view.leadingAnchor, right: self.view.trailingAnchor,height: (self.view.frame.width/2) + 110)
        NSLayoutConstraint.activate([
            emptyCartView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            emptyCartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)

        ])

        
        self.view.addSubview(popupView)
        popupView.anchor(width:self.view.frame.width/1.5,height: 140)
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        topAnchorr = popupView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        topAnchorr?.isActive = true
        
        let paddingBottom:CGFloat = self.view.frame.height/2 - 70
        bottomAnchorr = popupView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -paddingBottom)
        bottomAnchorr?.isActive = false
              
        cartTableView.register(UINib(nibName: "PriceCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PriceCellTableViewCell")
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: "cell")
        cartTableView.register(UINib(nibName: "ExtraCartTableViewCell", bundle: nil), forCellReuseIdentifier: "extracell")
        self.setupTableView()
        
            
        let totalWord = "Total ".localized
        self.totalPriceLabel.text = totalWord
        
   
        let subTotalWord = "Sub total ".localized
        self.subTotalLabel.text =  subTotalWord
   
        let deliveryWord = "Delivery ".localized
        self.deliveryPriceLabel.text = deliveryWord
    
    }
    
    func animteAdddLocationPopup(animate:Bool){
        cartTableView.isUserInteractionEnabled = !animate
        trashButton.isEnabled = !animate
        cartTableView.isScrollEnabled = !animate
        checkoutButton.isEnabled = !animate
        bottomAnchorr?.isActive = animate
        topAnchorr?.isActive = !animate
        if animate {
            self.view.addSubview(self.bullerEffectView)
            self.view.bringSubviewToFront(popupView)
        }else{
            self.bullerEffectView.removeFromSuperview()
        }
        self.autoLayoutIfneeded()
    }
    
    
    func autoLayoutIfneeded(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    

    //MARK:- Actions
    @objc
    func addLocationPreesed(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewLocation") as! NewLocationViewController
        vc.fromCart = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func clearCartData(_ note: Notification) {
        CartApis.shared.clearCartProducts(viewController: self)
        refreshCartProductsList()
    }
    
    @objc
    func browseCategory(sender: UIButton){
  
        self.dismiss(animated:true) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let TabViewController = storyBoard.instantiateViewController(withIdentifier: "rootnav") as! tabBarController
             TabViewController.selectedIndex = 0
             UIApplication.shared.keyWindow?.rootViewController = TabViewController
        }
    }
    
    
    @IBAction func trashClick(_ sender: UIBarButtonItem) {
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "pleaseconfirm"), message: NetworkManager.sharedInstance.language(key: "carttotalempty"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            CartApis.shared.clearCartProducts(viewController: self)
        
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
        if let product = cartViewModel?.getProductData[(recognizer.view?.tag)!] {
        productId = product.productId
        productName = product.productName
        productPrice = product.price
        imageUrl = product.productImgUrl
        self.performSegue(withIdentifier: "myproduct", sender: self)
        }
    }
    
    
    
    @available(iOS 13.4, *)
    @IBAction func proceedToCheckoutClick(_ sender: UIButton) {
        if let cartViewModel = cartViewModel {
            let token = defaults.object(forKey: "token")
            if token != nil{
                let newVC = self.storyboard!.instantiateViewController(withIdentifier: "checkoutOrder") as! CheckOutViewController
                newVC.modalPresentationStyle = .overFullScreen
                newVC.fastDelivery = cartViewModel.fastDelivery
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
        }
    }
    
    
    
    @objc func removeFromToCart(sender: UIButton){
        
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "pleaseconfirm"), message: NetworkManager.sharedInstance.language(key: "cartemtyinfo"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title:NetworkManager.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if let product = self.cartViewModel?.getProductData[sender.tag]{
                CartApis.shared.updateCartProducts(viewController: self, productId: "\(product.cartProductId)", quantity: "0")
            }
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
        }else{
            guard let token  = token as? String else {return}
            
            loginRequest["token"] = token
            
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
                        self.refreshCartProductsList()
                    }
                }else if val == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.loginRequest()
                    
                }
            }
        }
    }

    func refreshCartProductsList(){
        NetworkManager.sharedInstance.showLoader()
        CartApis.shared.getCartProducts(viewController: self) { data,locations  in
            self.cartViewModel = data
            guard let products = self.cartViewModel?.getProductData else {return}
            if products.isEmpty {
                self.cartHasAvailableProducts(available: false)
                NetworkManager.sharedInstance.dismissLoader()

            }else{
                print("locations??????? \(locations)")
                if locations.isEmpty{
                    self.animteAdddLocationPopup(animate: true)
                }else{
                    self.animteAdddLocationPopup(animate: false)
                    if let totalValue = self.cartViewModel?.getTotalAmount[2].text{
                        
                        let totalWord = "Total ".localized
                        let fullString = totalWord + totalValue
                        self.totalPriceLabel.attributedText = self.coloringSpacificWrod(fullString: fullString, colerdWord: totalValue,color:#colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1))
                        
                    }
                    if let subTotal = self.cartViewModel?.getTotalAmount[1].text {
                        let subTotalWord = "Sub total ".localized
                        let fullString = subTotalWord + subTotal
                        self.subTotalLabel.attributedText =  self.coloringSpacificWrod(fullString: fullString, colerdWord: subTotal, color: #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1))
                    }
                    if let deliveryPrice = self.cartViewModel?.getTotalAmount[0].text {
                        let deliveryWord = "Delivery ".localized
                        let fullString = deliveryWord + deliveryPrice
                        self.deliveryPriceLabel.attributedText =  self.coloringSpacificWrod(fullString: fullString, colerdWord: deliveryPrice, color: #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1))
                    }
                }
                self.cartHasAvailableProducts(available: true)
                self.cartTableView.reloadData()
                NetworkManager.sharedInstance.dismissLoader()
            }

        }
    }

    func cartHasAvailableProducts(available:Bool){
        self.cartTableView.isHidden = !available
        self.pricesView.isHidden = !available
        self.trashButton.isEnabled = available
        emptyCartView.animate(isAmimted: !available)
    }
    
    
    func updateAPICall(index: Int){
        if let product = cartViewModel?.getProductData[index] {
            if let quantity = product.quantity {
                let productId = product.cartProductId
                CartApis.shared.updateCartProducts(viewController: self, productId: productId, quantity: quantity)
            }
        }
    }
    


//    func checkOutAsGuest(alertAction: UIAlertAction!) {
//        self.performSegue(withIdentifier: "proceddToCheckout", sender: self)
//    }
//    
//    func registerAndCheckOut(alertAction: UIAlertAction!) {
//        self.performSegue(withIdentifier: "cartToCreateAccount", sender: self)
//    }
    
    func existingUser(alertAction: UIAlertAction!) {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
           tabBarController.selectedIndex = 2
  
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
    }
    
//    func openProduct(_sender : UITapGestureRecognizer){
//        productName = cartViewModel.getProductData[(_sender.view?.tag)!].productName
//        productId = cartViewModel.getProductData[(_sender.view?.tag)!].priductId
//        imageUrl = cartViewModel.getProductData[(_sender.view?.tag)!].productImgUrl
//        productPrice = cartViewModel.getProductData[(_sender.view?.tag)!].price
//        self.performSegue(withIdentifier: "myproduct", sender: self)
//    }
//
   
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
    
    func setupTableView(){
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let count = cartViewModel?.getProductData.count {
            return count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartTableViewCell
        
            if let cartViewModel = cartViewModel{
               let product =  cartViewModel.getProductData[indexPath.row]
                
                cell.cartProducts = cartViewModel.getProductData
                cell.cartView = self
                cell.productName.text = product.productName
            
                let currency:String = "SAR".localized

                cell.priceLabel.text = product.subTotal + currency
                cell.productImageView.loadImageFrom(url:product.productImgUrl)
            
                cell.descriptionLabel.text = product.desc
            
            
                cell.stepperView.QuantityLabel.text = product.quantity

                cell.myCartViewModel = cartViewModel
                
                cell.deleteButton.tag = indexPath.row
                cell.deleteButton.addTarget(self, action: #selector(removeFromToCart(sender:)), for: .touchUpInside)
            
                cell.stepperView.minuseButton.tag = indexPath.row
                cell.stepperView.plusButton.tag = indexPath.row

            }
        
            let Gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.viewProduct))
            Gesture1.numberOfTapsRequired = 1
            cell.productImageView.isUserInteractionEnabled = true
            cell.productImageView.addGestureRecognizer(Gesture1)
            cell.productImageView.tag = indexPath.row
            
            cell.delegate = self
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

