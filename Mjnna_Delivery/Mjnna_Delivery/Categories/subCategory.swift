//
//  subCategory.swift
//  DummySwift
//
//  Created by kunal prasad on 11/11/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

import UIKit


class subCategory: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    public var categoryName = " "
    var categoryId:String = " ";
    var subId:String = ""
    var subName:String = ""
    var subImage:String = ""
    var subcategoryViewModel:SubcategoryViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = subName
        collectionView.register(UINib(nibName: "SubMenuCell", bundle: nil), forCellWithReuseIdentifier: "SubMenuCell")
        self.callingHttppApi()
    }
    
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subcategoryViewModel.cataegoriesCollectionModel.count + 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubMenuCell", for: indexPath) as! SubMenuCell
        if indexPath.row == 0{
            cell.titleValue.text = "viewall".localized+" "+subName
            cell.imageData.loadImageFrom(url:subImage, dominantColor: "")
            
        }else{
            let data = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1]
            cell.titleValue.text = data.name
            cell.imageData.loadImageFrom(url:data.thumbnail, dominantColor: data.dominant_color)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2, height:collectionView.frame.size.width/3)
        
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            categoryName = subName
            categoryId = subId
            //self.performSegue(withIdentifier: "productCategorySegue", sender: self)
            self.performSegue(withIdentifier: "sellerCategory", sender: self)
        }else{
            if  self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].isChild{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let initViewController: subCategory? = (sb.instantiateViewController(withIdentifier: "subCategory") as? subCategory)
                initViewController?.subName = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].name
                initViewController?.subId = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].id
                initViewController?.subImage = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].thumbnail
                initViewController?.modalTransitionStyle = .flipHorizontal
                self.navigationController?.pushViewController(initViewController!, animated: true)
            }else{
                categoryName = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].name
                categoryId = self.subcategoryViewModel.cataegoriesCollectionModel[indexPath.row - 1].id
                //self.performSegue(withIdentifier: "productCategorySegue", sender: self)
                self.performSegue(withIdentifier: "sellerCategory", sender: self)
            }
        }
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "sellerCategory") {
            let viewController:SellerCategoryViewController = segue.destination as UIViewController as! SellerCategoryViewController
            //viewController.categoryType = ""
            viewController.typeName = self.categoryName
            viewController.typeId = self.categoryId
        }
    }
    
    
    
    func loginRequest(){
        var loginRequest = [String:String]()
        loginRequest["apiKey"] = API_USER_NAME
        loginRequest["apiPassword"] = API_KEY.md5
        if sharedPrefrence.object(forKey: "language") != nil{
            loginRequest["language"] = sharedPrefrence.object(forKey: "language") as? String;
        }
        if sharedPrefrence.object(forKey: "currency") != nil{
            loginRequest["currency"] = sharedPrefrence.object(forKey: "currency") as? String;
        }
        if sharedPrefrence.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = sharedPrefrence.object(forKey: "customer_id") as? String;
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"].intValue == 0{
                    sharedPrefrence.set(dict["wk_token"].stringValue, forKey: "wk_token")
                    sharedPrefrence.set(dict["language"].stringValue, forKey: "language")
                    sharedPrefrence.set(dict["currency"].stringValue, forKey: "currency")
                    sharedPrefrence.synchronize()
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
            self.view.isUserInteractionEnabled = false
            let sessionId = sharedPrefrence.object(forKey:"wk_token");
            var requstParams = [String:Any]()
            requstParams["wk_token"] = sessionId
            requstParams["category_id"] = self.subId
            requstParams["width"] = GlobalData.WIDTH
            NetworkManager.sharedInstance.showLoader()
            
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/getSubCategory", cuurentView: self){val,responseObject in
                if val == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["fault"].intValue == 1{
                        self.loginRequest()
                    }else{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.subcategoryViewModel = SubcategoryViewModel(data: dict)
                        self.collectionView.delegate = self
                        self.collectionView.dataSource = self
                        self.collectionView.reloadData()
                        
                    }
                    
                }else if val == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                    
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}


