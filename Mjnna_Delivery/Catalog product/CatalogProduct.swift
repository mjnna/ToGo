//
//  CatalogProduct.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 10/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import QuickLook


class CatalogProduct: UIViewController ,UIScrollViewDelegate{

    
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var describtionLabel: UILabel!

    @IBOutlet weak var featuredView: UIView!
    @IBOutlet weak var featuredLabel: UILabel!
    
    @IBOutlet weak var stepperView: UIView!
    
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var productpriceLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var optionView: UIView!
    
    @IBOutlet weak var yesCheckBoxView: UIView!
    @IBOutlet weak var yesCheckBoxButton: UIButton!
    @IBOutlet weak var noCheckBoxButton: UIButton!
    @IBOutlet weak var noCheckBoxView: UIView!

    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var optionNameLabel: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    
    
    //MARK:- Comonent
    
    lazy var stepper:StepperView = {
        let st = StepperView()
        st.minuseButton.addTarget(self, action: #selector(minusePressed), for: .touchUpInside)
        st.plusButton.addTarget(self, action: #selector(plusPressed), for: .touchUpInside)
        st.QuantityLabel.text = "\(1)"
        return st
    }()

    //MARK:- Properties
    var catalogProductViewModel:CatalogProductViewModel!
    var productId:String = ""
    var productName:String = ""
    var productPrice:String = ""
    var productImageUrl:String = ""
    let defaults = UserDefaults.standard
    var imageArrayUrl:[String] = []
    var whichApiToProcess:String = ""

    var childZoomingScrollView, parentZoomingScrollView :UIScrollView!
    var imageview,imageZoom : UIImageView!
    var currentTag:NSInteger = 0
    var pager:UIPageControl!
    var weatherData:Data?
    var isCart:Bool = false
    var previewItem:URL!
    
    var optionSelected:Bool = false
    

    let goldColor:UIColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
    let grayColor:UIColor = .gray
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = productName
        
        let nib = UINib(nibName: "CatalogProductImage", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "catalogimage")
        
        collectionView.delegate = self;
        collectionView.dataSource = self
        collectionView.reloadData()
        if productImageUrl != ""{
            imageArrayUrl.append(productImageUrl)
        }
        productNameLabel.text = productName
        productpriceLabel.text = productPrice
        self.tabBarController?.tabBar.isHidden = true
        callingHttppApi()
        
        addToCartButton.setTitle(NetworkManager.sharedInstance.language(key: "addtocart"), for: .normal)

        addToCartButton.setTitleColor(UIColor.white, for: .normal)
        
        addToCartButton.layer.cornerRadius = 5;
        addToCartButton.layer.masksToBounds = true
        
        setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupView(){
        self.viewLoaded(isLoaded: false)
        
        let goldColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height/2
        addToCartButton.backgroundColor = goldColor
        
        featuredView.layer.cornerRadius = 5
        featuredView.backgroundColor = goldColor
        featuredLabel.text = "Featured product".localized
        productpriceLabel.textColor = #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1)
        pageControl.isUserInteractionEnabled = false
        
        stepperView.addSubview(stepper)
        stepper.anchor(top: stepperView.topAnchor, bottom: stepperView.bottomAnchor, left: stepperView.leadingAnchor, right: stepperView.trailingAnchor)
       
        yesCheckBoxButton.backgroundColor = .clear
        yesCheckBoxView.layer.borderColor = grayColor.cgColor
        
        noCheckBoxView.layer.borderColor = goldColor.cgColor
        noCheckBoxButton.backgroundColor = goldColor
        
        designCheckBox(view: yesCheckBoxView, button: yesCheckBoxButton, tag: 0)
        designCheckBox(view: noCheckBoxView, button: noCheckBoxButton, tag: 1)
        
    }

    func viewLoaded(isLoaded:Bool){
        self.pageControl.isHidden = !isLoaded
        self.collectionView.isHidden = !isLoaded
        self.mainStackView.isHidden = !isLoaded
    }
    
    func designCheckBox(view:UIView,button:UIButton,tag:Int){
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = view.frame.height/2
        button.tag = tag
        button.layer.cornerRadius = button.frame.height/2
        button.addTarget(self, action: #selector(choicePressed), for: .touchUpInside)
    }
    
    //MARK:- Actions
  
    @objc func choicePressed(_ sender: UIButton) {
        let tag = sender.tag
        selectedChoice(tag:tag )
     
    }
 
    @objc func minusePressed(_ sender:UIButton){
        stepperButtons(isEnabled: false)
        if let stringQuantity = stepper.QuantityLabel.text{
            guard  var quantity = Int(stringQuantity)  else {
                return
            }
                if quantity == 1 {
                    stepper.QuantityLabel.text = "\(1)"
                    stepperButtons(isEnabled: true)
                }else{
                    quantity -= 1
                    stepper.QuantityLabel.text = "\(quantity)"
                    stepperButtons(isEnabled: true)
                }

        }
    }
    @objc func plusPressed(_ sender:UIButton){
        stepperButtons(isEnabled: false)
        let maxQuantity:Int = 19
        if let stringQuantity = stepper.QuantityLabel.text{
            guard  var quantity = Int(stringQuantity)  else {
                return
            }
                if quantity < maxQuantity || quantity == maxQuantity {
                    quantity += 1
                    stepper.QuantityLabel.text = "\(quantity)"
                    stepperButtons(isEnabled: true)

                }else{
                    //TODO: show user message that he crossed the limit of allawed quatity for item
                    stepperButtons(isEnabled: true)
                }
        
        }
    }
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc func openImage(_sender : UITapGestureRecognizer){
        self.zoomAction()
    }
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        whichApiToProcess = "addtocart"
        self.callingHttppApi()
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        let newScale: CGFloat = scroll.zoomScale * 1.5
        let zoomRect = self.zoomRect(forScale: newScale, withCenter: gestureRecognizer.location(in: gestureRecognizer.view))
        childScroll.zoom(to: zoomRect, animated: true)
    }
    
    
    @objc func closeZoomTap(_ gestureRecognizer: UIGestureRecognizer) {
        let currentWindow = UIApplication.shared.keyWindow!
        currentWindow.viewWithTag(888)!.removeFromSuperview()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let myCollectionView = collectionView
        if scrollView == myCollectionView{
            let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
            let index = scrollView.contentOffset.x / witdh
            let roundedIndex = round(index)
            pageControl.currentPage = Int(roundedIndex)
        }
    }
    func stepperButtons(isEnabled:Bool){
        stepper.minuseButton.isEnabled = isEnabled
        stepper.plusButton.isEnabled = isEnabled
    }
    
    func selectedChoice(tag:Int){
    
        if tag == 0 {
            yesCheckBoxButton.backgroundColor = goldColor
            yesCheckBoxView.layer.borderColor = goldColor.cgColor
            noCheckBoxView.layer.borderColor = grayColor.cgColor
            noCheckBoxButton.backgroundColor = .clear
            optionSelected = true
        }else{
            yesCheckBoxButton.backgroundColor = .clear
            yesCheckBoxView.layer.borderColor = grayColor.cgColor
            noCheckBoxView.layer.borderColor = goldColor.cgColor
            noCheckBoxButton.backgroundColor = goldColor
            optionSelected = false

        }
        
    }

    //MARK:- Handler
    
    func loginRequest(){
        var loginRequest = [String:String]();
        let token = sharedPrefrence.object(forKey:"token")
        if(token == nil){
            loginRequest["token"] = ""
        }
        else{
            loginRequest["token"] = token as? String
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"refresh", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"] != nil{
                    NetworkManager.sharedInstance.showWarningSnackBar(msg:"Please Login First".localized)
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
        DispatchQueue.main.async{
            NetworkManager.sharedInstance.showLoader()
            let sessionId = self.defaults.object(forKey:"token");
         
            self.view.isUserInteractionEnabled = false

            if self.whichApiToProcess == "addtocart"{
                var requstParams = [String:String]();
                requstParams["product_id"] = self.productId
                requstParams["token"] = sessionId as? String
                requstParams["quantity"] = self.stepper.QuantityLabel.text
                if (self.optionSelected){
                    requstParams["options"] = String(self.catalogProductViewModel.getOptions[0].id)
                }else{
                    let dictOption = [String:AnyObject]()
                    do {
                        let jsonSortData =  try JSONSerialization.data(withJSONObject: dictOption, options: .prettyPrinted)
                        let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                        requstParams["options"] = jsonSortString
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
              
                
                
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"cart/add", cuurentView: self){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        NetworkManager.sharedInstance.dismissLoader()
                        if dict.object(forKey: "error") != nil{
                            if (dict.object(forKey: "error") as? String == "authentication required"){
                                self.loginRequest()
                            }
                            else{
                                let  AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "alert"), message: "You Can't order from more than one store at once, clear cart?".localized, preferredStyle: .alert)
                                let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "yes"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                                        self.whichApiToProcess = "clearCart"
                                        self.callingHttppApi()
                                })
                                let cancelBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "no"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
                                })
                                AC.addAction(okBtn)
                                AC.addAction(cancelBtn)
                                self.parent!.present(AC, animated: true, completion: {  })
                            }
                            
                        }else{
                            
                            self.view.isUserInteractionEnabled = true
                            let dict1 = responseObject as! NSDictionary
                                //NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict.object(forKey: "message") as! String)
                            let dict = JSON(dict1)
                            let data = dict["cart"]["quantity"].stringValue
                            NotificationCenter.default.post(name: .cartBadge, object: data)
                            
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: "product added to cart successfully".localized)
                                                       }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
            else{
           
                var requstParams = [String:Any]();
                requstParams["product_id"] = self.productId
                requstParams["token"] = sessionId
                if let lang = sharedPrefrence.object(forKey: "language") as? String{
                    requstParams["lang"] = lang
                }
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"product/details", cuurentView: self){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                //self.loginRequest()
                            }
                        }else{
                            
                            
                            self.view.isUserInteractionEnabled = true
         
                            let data = JSON(responseObject as! NSDictionary)
                            var ProductDict = [String: Any]()
                            ProductDict["name"] = data["product"]["name"].stringValue
                            ProductDict["ProductID"] = data["product"]["id"].stringValue
                            ProductDict["image"] = data["product"]["images"].arrayValue.count>0 ? data["product"]["images"].arrayValue[0].stringValue:"a.jpeg"
                            let price = data["product"]["price"].stringValue
                            ProductDict["price"] = (price == "" || price == "false") ? "" : price
                            ProductDict["DateTime"] = String(describing: Date())
                            ProductDict["StartDate"] = data["product"]["feature_start_date"]
                            ProductDict["EndDate"] = data["product"]["feature_end_date"]
                            ProductDict["isFeatured"] = data["product"]["is_featured"]
                            ProductDict["weight"] = data["product"]["weight"]
                            ProductDict["specialPrice"] = data["product"]["featured_price"].floatValue
                            ProductDict["formatted_special"] = data["product"]["featured_price"].stringValue
                            ProductDict["hasOption"] = (data["product"]["product_options"].arrayObject?.count)! > 0 ? "1" : "0"
                            
                            
                            
                            self.catalogProductViewModel = CatalogProductViewModel(productData:JSON(responseObject as! NSDictionary))
                            self.doFurtherProcessingWithResult()
    
                            NetworkManager.sharedInstance.dismissLoader()
                            
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
        }
    }
    
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async{
            self.activityIndicator.stopAnimating()
            self.productNameLabel.text = self.catalogProductViewModel.getProductName
            self.productpriceLabel.text = self.catalogProductViewModel.getPrice
            
            
            self.describtionLabel.text =  self.catalogProductViewModel.catalogProductModel.descriptionData.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
           
            self.imageArrayUrl = []
            for i in 0..<self.catalogProductViewModel.getProductImages.count{
                let imageUrl = self.catalogProductViewModel.getProductImages[i].imageURL
                self.imageArrayUrl.append(imageUrl)
                
            }
            self.collectionView.reloadData()
            print(self.imageArrayUrl)
            self.pageControl.numberOfPages = self.imageArrayUrl.count
            if self.imageArrayUrl.count == 1{
                self.pageControl.isHidden = true
            }
            
            //MARK: - Options
            self.specialPrice.isHidden = true
            if self.catalogProductViewModel.getSpecialprice != 0 && self.catalogProductViewModel.getSpecialprice  > 0{
                self.productpriceLabel.text = self.catalogProductViewModel.catalogProductModel.formatted_special;
                
                let attributeString = NSMutableAttributedString(string: self.catalogProductViewModel.getPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                self.specialPrice.attributedText = attributeString
                self.specialPrice.isHidden = false
                self.specialPrice.textColor = UIColor().HexToColor(hexString: GlobalData.DARKGREY)
            }
            let options = self.catalogProductViewModel.getOptions
            if options.count != 0{
                self.optionView.isHidden = false
                let option = self.catalogProductViewModel.getOptions[0]
                self.yesLabel.text = option.choices[0].name
                self.noLabel.text = option.choices[1].name
                self.optionNameLabel.text = option.name
            }else{
                self.optionView.isHidden = true
            }
            self.featuredView.isHidden = !self.catalogProductViewModel.isFeatured
            self.viewLoaded(isLoaded: true)
            
        }
        
    }
    
    //MARK: - Zoom functions
    func zoomAction(){
        let homeDimView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT)))
        homeDimView.backgroundColor = UIColor.white
        let currentWindow = UIApplication.shared.keyWindow
        homeDimView.tag = 888
        homeDimView.frame = (currentWindow?.bounds)!
        let cancel = UIImageView(frame: CGRect(x: CGFloat(SCREEN_WIDTH - 50), y: CGFloat(30), width: CGFloat(30), height: CGFloat(30)))
        cancel.image = UIImage(named: "ic_close")
        cancel.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        cancel.isUserInteractionEnabled = true
        homeDimView.addSubview(cancel)
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(self.closeZoomTap))
        cancelTap.numberOfTapsRequired = 1
        cancel.addGestureRecognizer(cancelTap)
        
        var X:CGFloat = 0
        
        parentZoomingScrollView = UIScrollView(frame: CGRect(x: CGFloat(0), y: CGFloat(70), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
        parentZoomingScrollView.isUserInteractionEnabled = true
        parentZoomingScrollView.tag = 888888
        parentZoomingScrollView.delegate = self
        homeDimView.addSubview(parentZoomingScrollView)
        
        
        for i in 0..<imageArrayUrl.count {
            childZoomingScrollView = UIScrollView(frame: CGRect(x: CGFloat(X), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
            childZoomingScrollView.isUserInteractionEnabled = true
            childZoomingScrollView.tag = 90000 + i
            childZoomingScrollView.delegate = self
            parentZoomingScrollView.addSubview(childZoomingScrollView)
            imageZoom = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
            imageZoom.image = UIImage(named: "ic_placeholder.png")
            imageZoom.contentMode = .scaleAspectFit
            
            imageZoom.isUserInteractionEnabled = true
            imageZoom.tag = 10
            childZoomingScrollView.addSubview(imageZoom)
            childZoomingScrollView.maximumZoomScale = 5.0
            childZoomingScrollView.clipsToBounds = true
            childZoomingScrollView.contentSize = CGSize(width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120))
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            imageZoom.addGestureRecognizer(doubleTap)
            X += SCREEN_WIDTH
        }
        
        parentZoomingScrollView.contentSize = CGSize(width: CGFloat(X), height: CGFloat(SCREEN_WIDTH))
        parentZoomingScrollView.isPagingEnabled = true
        let Y: CGFloat = 70 + SCREEN_HEIGHT - 120 + 5
        pager = UIPageControl(frame: CGRect(x: CGFloat(0), y: CGFloat(Y), width: CGFloat(SCREEN_WIDTH), height: CGFloat(50)))
        //SET a property of UIPageControl
        pager.backgroundColor = UIColor.clear
        pager.numberOfPages = imageArrayUrl.count
        //as we added 3 diff views
        pager.currentPage = 0
        pager.isHighlighted = true
        pager.pageIndicatorTintColor = UIColor.black
        pager.currentPageIndicatorTintColor = UIColor.red
        homeDimView.addSubview(pager)
        currentWindow?.addSubview(homeDimView)
        
        let newPosition = SCREEN_WIDTH * CGFloat(self.pageControl.currentPage)
        let toVisible = CGRect(x: CGFloat(newPosition), y: CGFloat(70), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120))
        self.parentZoomingScrollView.scrollRectToVisible(toVisible, animated: true)
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.viewWithTag(90000 + currentTag) as? UIScrollView != nil{
            let scroll = scrollView.viewWithTag(90000 + currentTag) as! UIScrollView
            let image = scroll.viewWithTag(10) as! UIImageView
            return image
        }else{
            return nil
        }
    }
    

    
    func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        zoomRect.size.height = childScroll.frame.size.height / scale
        zoomRect.size.width = childScroll.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    
   
}


extension CatalogProduct : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrayUrl.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogimage", for: indexPath) as! CatalogProductImage
        
        cell.imageView.loadImageFrom(url:imageArrayUrl[indexPath.row], dominantColor: "ffffff")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openImage))
        cell.imageView.addGestureRecognizer(tapGesture)
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = collectionView.frame.height
        let cellWidth = collectionView.frame.width
        return CGSize(width:cellWidth , height:cellHeight)
        
    }
    
}

extension CatalogProduct: QLPreviewControllerDelegate,QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
}
