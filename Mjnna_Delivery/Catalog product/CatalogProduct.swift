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


class CatalogProduct: UIViewController ,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource,QLPreviewControllerDelegate, QLPreviewControllerDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 8000 + currentOptionTag){
            let dict = selectArr[currentOptionTag]
            return (dict?.count)!
        }else{
            return 0
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var specialrice: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productpriceLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var optionView: UIView!
   
    @IBOutlet weak var optionViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityValue: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var taxAmount: UILabel!
    
    //MARK:- Properties
    var catalogProductViewModel:CatalogProductViewModel!
    var cellHeight:CGFloat = SCREEN_HEIGHT/2
    var cellWidth:CGFloat = SCREEN_WIDTH
    var productId:String = ""
    var productName:String = ""
    var productPrice:String = ""
    var productImageUrl:String = ""
    let defaults = UserDefaults.standard;
    var imageArrayUrl:NSMutableArray = []
    var dominantColor:NSMutableArray = []
    var selectArr  = [Int:JSON]()
    var selectID  = [Int:String]()
    var keyBoardFlag:Int = 1;
    var whichApiToProcess:String = ""
    var radioId = [Int: String]()
    var fileCodeValue = ""
    var optionDictionary = [String:AnyObject]()
    var goToBagFlag:Bool = false
    var currentOptionTag:Int = 0;
    var childZoomingScrollView, parentZoomingScrollView :UIScrollView!
    var imageview,imageZoom : UIImageView!
    var currentTag:NSInteger = 0
    var pager:UIPageControl!
    var weatherData:Data?
    var fileName:String!
    var isCart:Bool = false
    var previewItem:URL!
    var productOptionArray : JSON!
    var availableLocation:Bool = false
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = productName
        
        let nib = UINib(nibName: "CatalogProductImage", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "catalogimage")
        scrollView.delegate = self
        //collectionViewHeightConstarints.constant = SCREEN_HEIGHT/2 + 16
        
        collectionView.delegate = self;
        collectionView.dataSource = self
        collectionView.reloadData()
        if productImageUrl != ""{
            imageArrayUrl.add(productImageUrl);
        }
        productNameLabel.text = productName
        productpriceLabel.text = productPrice
        self.tabBarController?.tabBar.isHidden = true
        callingHttppApi()
        addToCartView.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        addToCartView.isHidden = true
        
        addToCartButton.setTitle(NetworkManager.sharedInstance.language(key: "addtocart"), for: .normal)
        
        stepper.tintColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
       
        addToCartButton.setTitleColor(UIColor.white, for: .normal)
        
        addToCartButton.layer.cornerRadius = 5;
        addToCartButton.layer.masksToBounds = true
        
        quantityLabel.text = "qty".localized
        specialrice.text = ""
        addToCartView.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
//        NotificationCenter.default.addObserver(self, selector: #selector(customerHasLocation(_:)), name: .availablelocation, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- Actions
//    @objc
//    func customerHasLocation(_ notification:Notification){
//        if let available = notification.object as? Bool{
//            availableLocation = available
//        }
//    }
//
    @IBAction func stepperClick(_ sender: UIStepper) {
        quantityValue.text = String(format:"%d",Int(sender.value))
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
    
    //MARK:- CollectionView Methods
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArrayUrl.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogimage", for: indexPath) as! CatalogProductImage
        
        cell.imageView.loadImageFrom(url:imageArrayUrl.object(at: indexPath.row) as! String , dominantColor: "ffffff")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openImage))
        cell.imageView.addGestureRecognizer(tapGesture)
        return cell;
        
    }
    
    @objc func openImage(_sender : UITapGestureRecognizer){
        self.zoomAction()
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:cellWidth , height:cellHeight)
        
    }
    
    
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
            
            if self.whichApiToProcess == "clearCart"{
                NetworkManager.sharedInstance.showLoader()
                var requstParams = [String:String]()
                requstParams["token"] = sessionId as? String
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams , apiname:"cart/clear", cuurentView: self){success,responseObject in
                    if success == 1 {
                        let dict = responseObject as! NSDictionary;
                        if dict.object(forKey: "fault") != nil{
                            let fault = dict.object(forKey: "fault") as! Bool;
                            if fault == true{
                                self.loginRequest()
                            }
                        }else{
                            NetworkManager.sharedInstance.dismissLoader()
                            self.view.isUserInteractionEnabled = true;
                            let dict = (responseObject as! NSDictionary)
                            
                            self.doFurtherProcessingWithResult()
                            if dict.object(forKey: "error") != nil{
                               
                            }
                            self.whichApiToProcess = "addtocart"
                            self.callingHttppApi()
                            
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi();
                    }
                }
            }
            if self.whichApiToProcess == "addtocart"{
                var requstParams = [String:String]();
                requstParams["product_id"] = self.productId
                requstParams["token"] = sessionId as? String
                requstParams["quantity"] = self.quantityValue.text
                do {
                    let jsonSortData =  try JSONSerialization.data(withJSONObject: self.optionDictionary, options: .prettyPrinted)
                    let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["options"] = jsonSortString
                }
                catch {
                    print(error.localizedDescription)
                }
                
                
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"cart/add", cuurentView: self){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        NetworkManager.sharedInstance.dismissLoader()
                        if dict.object(forKey: "error") != nil{
                            if (dict.object(forKey: "error") as! String == "authentication required"){
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
                self.parentView.isUserInteractionEnabled = false
                var requstParams = [String:Any]();
                requstParams["product_id"] = self.productId
                requstParams["token"] = sessionId
                requstParams["lang"] = "en"
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
                            self.parentView.isUserInteractionEnabled = true
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
                            self.doFurtherProcessingWithResult();
                                
                                
                            
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell: UICollectionViewCell in self.collectionView.visibleCells {
            if let indexPathValue = self.collectionView.indexPath(for: cell){
                self.pageControl.currentPage = indexPathValue.row
            }
        }
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 888888{
            let pageWidth: CGFloat = self.parentZoomingScrollView.frame.size.width
            let page = floor((self.parentZoomingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            self.currentTag = NSInteger(page)
            self.pager.currentPage = Int(page)
        }
        let actualHeight = scrollView.contentOffset.y+scrollView.frame.size.height;
        
        addToCartView.isHidden = false;
    }
    
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async{
            self.activityIndicator.stopAnimating()
            self.productNameLabel.text = self.catalogProductViewModel.getProductName
            self.productpriceLabel.text = self.catalogProductViewModel.getPrice
            
            
            self.taxAmount.text =  self.catalogProductViewModel.catalogProductModel.descriptionData.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
           
            self.imageArrayUrl = []
            for i in 0..<self.catalogProductViewModel.getProductImages.count{
                self.imageArrayUrl.add(self.catalogProductViewModel.getProductImages[i].imageURL)
                
            }
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.imageArrayUrl.count
            if self.imageArrayUrl.count == 1{
                self.pageControl.isHidden = true
            }
            
            //MARK: - Options
            self.specialrice.isHidden = true;
            if self.catalogProductViewModel.getSpecialprice != 0 && self.catalogProductViewModel.getSpecialprice  > 0{
                self.productpriceLabel.text = self.catalogProductViewModel.catalogProductModel.formatted_special;
                
                let attributeString = NSMutableAttributedString(string: self.catalogProductViewModel.getPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                self.specialrice.attributedText = attributeString
                self.specialrice.isHidden = false
                self.specialrice.textColor = UIColor().HexToColor(hexString: GlobalData.DARKGREY)
            }
            
            
            var Y:CGFloat = 0
            
            if self.catalogProductViewModel.getOption.count > 0 {
                
                for i in 0..<self.catalogProductViewModel.getOption.count {
                    let dict = JSON(self.catalogProductViewModel.getOption[i]);
                    let optionLbl = UILabel(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 30))
                    optionLbl.textColor = UIColor.black
                    optionLbl.backgroundColor = UIColor.clear
                    optionLbl.font = UIFont(name: BOLDFONT, size: 15)
                    if dict["required"].intValue == 1{
                        optionLbl.text = dict["name"].stringValue+" "+GlobalData.ASTERISK
                    }else{
                        optionLbl.text = dict["name"].stringValue
                    }
                    self.optionView.addSubview(optionLbl)
                    Y += 30;
                   
                    if dict["max_select"].intValue == 1 {
                        let subOptionView = UIView(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 30))
                        subOptionView.isUserInteractionEnabled = true
                        self.optionView.addSubview(subOptionView)
                        subOptionView.tag = i
                        self.radioId[i] = ""
                        Y += 30;
                        let productOptionArray : JSON = JSON(dict["choices"].arrayObject!)
                        let buttonArray:NSMutableArray = []
                        var internalY:CGFloat = 0
                        for j in 0..<productOptionArray.count {
                            let btn = RadioButton(frame: CGRect(x: 5, y: internalY, width: subOptionView.frame.size.width, height: 30))
                            btn.setTitle(productOptionArray[j]["name"].stringValue, for: .normal)
                            btn.setTitleColor(UIColor.darkGray, for: .normal)
                            btn.titleLabel?.font = UIFont.init(name: REGULARFONT, size: 13.0)
                            btn.setImage(UIImage(named: "unchecked.png"), for: .normal)
                            btn.setImage(UIImage(named: "checked.png"), for: .selected)
                            if let languageCode =  sharedPrefrence.object(forKey: "language") as? String{
                                if languageCode == "ar"{
                                    btn.contentHorizontalAlignment = .right
                                }else{
                                    btn.contentHorizontalAlignment = .left
                                }
                            }
                            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
                            btn.addTarget(self, action: #selector(self.onRadioButtonValueChangedAccount), for:.touchUpInside)
                            btn.tag = j;
                            subOptionView.addSubview(btn)
                            internalY += 40;
                            buttonArray.add(btn)
                        }
                        var paymentInformationContainerFrame = subOptionView.frame
                        paymentInformationContainerFrame.size.height = internalY
                        subOptionView.frame = paymentInformationContainerFrame
                        let radioButton:RadioButton = RadioButton()
                        radioButton.groupButtons = buttonArray as! [RadioButton]
                        
                        Y += internalY;
                        
                    } else {
                        let subOptionView = UIView(frame: CGRect(x: 5, y: Y, width: self.optionView.frame.size.width - 10, height: 30))
                        subOptionView.isUserInteractionEnabled = true
                        subOptionView.tag = 8000 + i;
                        self.optionView.addSubview(subOptionView)
                        Y += 30;
                        let productOptionArray : JSON = JSON(dict["choices"].arrayObject!)
                        var internalY:CGFloat = 0
                        for j in 0..<productOptionArray.count {
                            let checkBox = UISwitch(frame: CGRect(x:10, y:internalY+10, width:40, height:40))
                            checkBox.isOn = false
                            checkBox.tag = j
                            subOptionView.addSubview(checkBox)
                            let name = UILabel(frame: CGRect(x: checkBox.frame.size.width+25, y: internalY+10, width: self.optionView.frame.size.width - 60, height: 30))
                            name.textColor = UIColor.black
                            name.backgroundColor = UIColor.clear
                            name.textAlignment = .left
                            name.font = UIFont.init(name: REGULARFONT, size: 13.0)
                            
                            if productOptionArray[j]["price"].stringValue != "" && productOptionArray[j]["price"].stringValue != "false"{
                                name.text = productOptionArray[j]["name"].stringValue+" ("+productOptionArray[j]["price"].stringValue+")"
                            }else{
                                name.text = productOptionArray[j]["name"].stringValue
                            }
                            subOptionView.addSubview(name)
                            internalY += 40;
                        }
                        var paymentInformationContainerFrame = subOptionView.frame
                        paymentInformationContainerFrame.size.height = internalY
                        subOptionView.frame = paymentInformationContainerFrame
                        Y += internalY;
                    }
                    self.optionViewHeightConstarints.constant = Y
                }
            }
            
        }
        
    }
    
    
    @objc func onRadioButtonValueChangedAccount(_ sender: RadioButton) {
        if ((sender.selected) != nil){
            let dict = JSON(self.catalogProductViewModel.getOption[(sender.superview?.tag)!]);
            if dict["type"].stringValue == "radio"{
                let productOptionArray : JSON = JSON(dict["choices"].arrayObject!)
                radioId[(sender.superview?.tag)!] = productOptionArray[sender.tag]["choices"].stringValue
            }
        }
    }
    
    @objc func selectOptionPicker(textField: UITextField){
        currentOptionTag = textField.tag - 7000
        let selectPicker = UIPickerView()
        selectPicker.tag = 8000 + currentOptionTag;
        textField.inputView = selectPicker
        
        selectPicker.delegate = self
        let dict = selectArr[currentOptionTag]
        if (dict?.count)! > 0{
            if dict![0]["price"].stringValue != "" && dict![0]["price"].stringValue != "false"{
                let str : String = dict![0]["name"].stringValue + "(" + dict![0]["price_prefix"].stringValue + dict![0]["price"].stringValue + ")"
                textField.text = str
            }else{
                let str : String = dict![0]["name"].stringValue
                textField.text = str
            }
            selectID[currentOptionTag] = dict![0]["product_option_value_id"].stringValue
        }
        
    }
    
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        let isValid = 0;
        var errorMessage:String = "pleaseselect".localized+" "
        optionDictionary = [String:AnyObject]()
        
        
        for i in 0..<self.catalogProductViewModel.getOption.count {
            let dict = JSON(self.catalogProductViewModel.getOption[i]);
            
          if dict["max_select"].intValue == 1{
                    optionDictionary[dict["id"].stringValue] = radioId[i] as AnyObject
                
            } else {
                let checkBoxArry:NSMutableArray = []
                let productOptionArray : JSON = JSON(dict["choices"].arrayObject!)
                print(productOptionArray)
                let  checkBoxView = self.optionView.viewWithTag(8000 + i);
                for j in 0..<productOptionArray.count {
                    let switchValue = checkBoxView?.viewWithTag(j) as! UISwitch
                    if switchValue.isOn{
                        checkBoxArry.add(productOptionArray[j]["id"].stringValue)
                    }
                }
                if checkBoxArry.count == 0{
                    //isValid = 1;
                    errorMessage = errorMessage+dict["name"].stringValue
                    break
                }else{
                    optionDictionary[dict["id"].stringValue] = checkBoxArry
                }
            }
        }
        
        if isValid == 1{
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            goToBagFlag = false
        }else{
            whichApiToProcess = "addtocart"
            self.callingHttppApi()
        }
    }
    
    func openProduct(productId:String,productName:String){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let initViewController: CatalogProduct? = (sb.instantiateViewController(withIdentifier: "catalogproduct") as? CatalogProduct)
        initViewController?.productId = productId;
        initViewController?.productName = productName
        initViewController?.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(initViewController!, animated: true)
        
        
    }
    
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "gotodescription") {
            /*let viewController:Description = segue.destination as UIViewController as! Description
            viewController.descriptionData = catalogProductViewModel.getdescriptionData*/
        } else if (segue.identifier! == "specifiaction") {
//            let viewController:CatalogSpecification = segue.destination as UIViewController as! CatalogSpecification
//            viewController.catalogProductViewModel = self.catalogProductViewModel
        }
    }
    
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
            imageZoom.loadImageFrom(url:imageArrayUrl[i] as! String , dominantColor: "ffffff")
            
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
    
    @objc func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        let newScale: CGFloat = scroll.zoomScale * 1.5
        let zoomRect = self.zoomRect(forScale: newScale, withCenter: gestureRecognizer.location(in: gestureRecognizer.view))
        childScroll.zoom(to: zoomRect, animated: true)
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
    
    
    
    @objc func closeZoomTap(_ gestureRecognizer: UIGestureRecognizer) {
        let currentWindow = UIApplication.shared.keyWindow!
        currentWindow.viewWithTag(888)!.removeFromSuperview()
    }
    
}

