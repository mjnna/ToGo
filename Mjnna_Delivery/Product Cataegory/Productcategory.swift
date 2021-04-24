//
//  Productcategory.swift
//  OpenCartApplication
//
//  Created by Kunal Parsad on 30/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit


class Productcategory: UIViewController {
    
    //MARK:- Outlet

    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var SellerLabel: UILabel!
    @IBOutlet weak var DeliveryLabel: UILabel!
    @IBOutlet weak var AvailabilityLabel: UILabel!
    @IBOutlet weak var HeaderImage: UIImageView!
    @IBOutlet weak var ProductsCollectionView: UICollectionView!
    @IBOutlet weak var HeaderImageHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryTopConstraint: NSLayoutConstraint!
    
    //MARK:- Component

    lazy var cartButton: CartButton = {
       let view = CartButton()
        view.backgroundColor = .clear
        view.cartButton.addTarget(self, action: #selector(cartPressed), for: .touchUpInside)
       return view
    }()
  
    //MARK:- Properies

    var storeId:String = ""
    var storeName:String = ""
    var storeImage:String = ""
    var categoryId:String = ""
    let defaults = UserDefaults.standard;
    var whichApiToProcess:String = ""
    //var pageNumber:Int = 1
    var productCollectionViewModel:ProductCollectionViewModel!
    var categoryCollectionViewModel:StoreCategoryCollectionViewModel!
    var productId:String = ""
    var productName:String = ""
    var ImageIurl:String = ""
    var count = 0
    var cartViewModel: CartViewModel?
    
    //MARK:- Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        SellerLabel.text = storeName
        DeliveryLabel.text = "KSADelivery".localized
        AvailabilityLabel.text = "KSAAvailable".localized
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = ""
        //self.navigationItem.backBarButtonItem?.tintColor = .white
        whichApiToProcess = ""
        
        categoryCollectionView.register(StoreCategoryCollectionViewCell.nib(), forCellWithReuseIdentifier: "StoreCategoryCollectionViewCell")
        
        productCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        productCollectionView.register(UINib(nibName: "SortCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sortCollectionViewCell")
        productCollectionView.register(UINib(nibName: "ListCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "listcollectionview")
        
        
        callingHttppStoreApi()
        //callingHttppProductsApi()
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: .cartBadge, object: nil)
        getCartProduct()
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        NetworkManager.sharedInstance.removePreviousNetworkCall()
        NetworkManager.sharedInstance.dismissLoader()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupView(){
        self.view.addSubview(cartButton)
        self.cartButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.trailingAnchor, paddingBottom: 20, paddingRight: 20, width: 70, height: 70)
        
        HeaderView.layer.shadowColor = UIColor.lightGray.cgColor
        HeaderView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        HeaderView.layer.shadowRadius = 2.0
        HeaderView.layer.shadowOpacity = 0.5
        HeaderView.layer.masksToBounds = false

        HeaderView.layer.borderColor = UIColor.lightGray.cgColor
        HeaderView.layer.borderWidth = 0.2
        HeaderView.layer.cornerRadius = 10
        
        HeaderImage.loadImageFrom(url: storeImage)
    }
    
    
    //MARK:- Actions
    
    @objc
    func updateCartBadge(_ notification: Notification){
        if let badge = notification.object as? String{
            checkCartBadge(badge: badge)
        }
    }
    
    @objc
    func cartPressed (){
        self.performSegue(withIdentifier: "cart", sender: nil)
    }
    
    @objc func browseCategory(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    @objc func viewProducts(_ recognizer: UITapGestureRecognizer){
        productId = productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].id
        productName = productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].productName
        ImageIurl = productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].productImage
        //productprice = productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].price;
        self.performSegue(withIdentifier: "productpage", sender: self)
    }
    
    

    //MARK:- Handler
    func getCartProduct(){
        var requstParams =  [String:Any]()
        NetworkManager.sharedInstance.showLoader()
        if let sessionId = self.defaults.object(forKey:"token"){
        requstParams = ["token":sessionId]
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"cart/details", cuurentView: self){ [self]success,responseObject in
                switch success {
                case 1:
                    let dict = responseObject as! NSDictionary;
                    if dict.object(forKey: "error") != nil{
                        print("Error !")
                    }else{
                        self.view.isUserInteractionEnabled = true
                        print("success !")
                        self.cartViewModel = CartViewModel(data: JSON(responseObject as! NSDictionary))
                        if let products = self.cartViewModel?.getTotalProducts{
                            checkCartBadge(badge: products)
                        }
                        NetworkManager.sharedInstance.dismissLoader()
                    }
                case 2:
                    NetworkManager.sharedInstance.dismissLoader()
                default:
                    break
                }
                
            }
        }
    
    }
    
    func checkCartBadge(badge:String){
        if badge == "0" || badge == ""{
            cartButton.badgeLabel.isHidden = true
        }else{
            cartButton.badgeLabel.isHidden = false
            cartButton.badgeLabel.text = badge
        }
    }
    
    func callingHttppStoreApi(){
        //let sessionId = sharedPrefrence.object(forKey:"token") as! String;
            var requstParams = [String:String]()
            //requstParams["token"] = sessionId
        let language = sharedPrefrence.object(forKey: "language")
        if(language != nil){
            requstParams["lang"] = language as? String
        }else{
            requstParams["lang"] = "en"
        }
            requstParams["store_id"] = self.storeId
            
            
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"category/list",cuurentView: self){val,responseObject in
                if val == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["error"] != nil{
                       //display the error to the customer
                    }
                    else{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.categoryCollectionViewModel = StoreCategoryCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                        self.categoryId = self.categoryCollectionViewModel.storeCategoryCollectionModel[0].id
                        self.categoryCollectionView.delegate = self
                        self.categoryCollectionView.dataSource = self
                        self.categoryCollectionView.reloadData()
                        self.callingHttppProductsApi()
                    }
                    
                }
                else{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppStoreApi()
                }
            }
    }
    
    func callingHttppProductsApi(){
        
        
            var requstParams = [String:String]()
            let language = sharedPrefrence.object(forKey: "language")
            if(language != nil){
                requstParams["lang"] = language as! String
            }else{
                requstParams["lang"] = "en"
        }
            requstParams["category_id"] = self.categoryId
            
            
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"product/list",cuurentView: self){val,responseObject in
                if val == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["error"] != nil{
                       //display the error to the customer
                    }
                    else{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                        self.productCollectionView.delegate = self
                        self.productCollectionView.dataSource = self
                        self.productCollectionView.reloadData()
                    }
                    
                }
                else{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppProductsApi()
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productpage") {
            let viewController:CatalogProduct = segue.destination as UIViewController as! CatalogProduct
            viewController.productImageUrl = ImageIurl
            viewController.productId = self.productId
            viewController.productName = self.productName
          //  viewController.productPrice = self.productprice
        }
    }
}

extension Productcategory: UIScrollViewDelegate{
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && count < 1{
            UIView.animate(withDuration: 0.5, animations: {
            //self.HeaderImageHeight.constant = 100
            self.HeaderView.transform = CGAffineTransform(translationX: 0, y: -35)
            self.categoryCollectionView.transform = CGAffineTransform(translationX: 0, y: -35)
            self.ProductsCollectionView.transform = CGAffineTransform(translationX: 0, y: -35)
            self.HeaderImage.image = UIImage()
            self.HeaderImage.backgroundColor = .white
            })
                
            count += 1
            
        }
        else if scrollView.contentOffset.y == 0 && count > 0
        {
                UIView.animate(withDuration: 0.5, animations: {
                //self.HeaderImageHeight.constant = 200
                self.HeaderView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.categoryCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.ProductsCollectionView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.HeaderImage.loadImageFrom(url: self.storeImage)
                })
            count -= 1
        }
    }
}

extension Productcategory:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if view == self.categoryCollectionView {
            return categoryCollectionViewModel.getStoreCategoryCollectionData.count
        }
        else{
            if productCollectionViewModel.getProductCollectionData.count == 0{
                return 0
            }
            else {
                view.backgroundView = nil
                return productCollectionViewModel.getProductCollectionData.count
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            if collectionView == self.categoryCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCategoryCollectionViewCell", for: indexPath) as! StoreCategoryCollectionViewCell
                cell.configure(with: categoryCollectionViewModel.storeCategoryCollectionModel[indexPath.row].name, url: categoryCollectionViewModel.storeCategoryCollectionModel[indexPath.row].image
                )
                return cell
            }
            else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listcollectionview", for: indexPath) as! ListCollectionViewCell
            cell.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY).cgColor
            cell.layer.borderWidth = 0.5
            cell.productId = productCollectionViewModel.getProductCollectionData[indexPath.row ].id
            cell.name.text = productCollectionViewModel.getProductCollectionData[indexPath.row ].productName
            cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row ].price
            cell.descriptionData.text = productCollectionViewModel.getProductCollectionData[indexPath.row ].descriptionData
            
            cell.imageView.loadImageFrom(url:productCollectionViewModel.getProductCollectionData[indexPath.row].productImage , dominantColor: "ffffff")
            
            cell.imageView.tag = indexPath.row
            let Gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.viewProducts))
            Gesture2.numberOfTapsRequired = 1
            cell.imageView.isUserInteractionEnabled = true;
            cell.imageView.addGestureRecognizer(Gesture2)
            cell.price.textColor = UIColor().HexToColor(hexString: GlobalData.GREEN_COLOR
            )
            
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isFeatured > 0  {
                cell.specialPriceLabel.isHidden = false;
                cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row ].specialPrice.description
                let attributeString = NSMutableAttributedString(string: productCollectionViewModel.getProductCollectionData[indexPath.row ].price)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                cell.specialPriceLabel.attributedText = attributeString
            }
            
            return cell
        }
        

    }
    
    
  
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView{
            self.categoryId = self.categoryCollectionViewModel.storeCategoryCollectionModel[indexPath.row].id
            self.callingHttppProductsApi()
        }
        else{
            
            productId =    productCollectionViewModel.getProductCollectionData[indexPath.row].id;
            productName = productCollectionViewModel.getProductCollectionData[indexPath.row].productName;
            ImageIurl = productCollectionViewModel.getProductCollectionData[indexPath.row].productImage;
            //productprice = productCollectionViewModel.getProductCollectionData[(recognizer.view?.tag)!].price;
            self.performSegue(withIdentifier: "productpage", sender: self)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.categoryCollectionView{
            return CGSize(width: 100, height:100)

        }else{
            return CGSize(width: self.view.frame.width, height:170)
        }
    }

}
extension Notification.Name {
    static let cartBadge = Notification.Name("cartBadge")

}
