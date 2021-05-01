//
//  SellerCategoryViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 7/21/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit
import MaterialComponents

class SellerCategoryViewController: UIViewController {
    
    //MARK:- Outlet
    lazy var searchBarView: SearchBarView = {
       let v = SearchBarView()
        v.searchTextFeild.addTarget(self, action: #selector(userTypingNow), for: .editingChanged)
        v.fastDeleviryButton.addTarget(self, action: #selector(fastDeliveryPressed), for: .touchUpInside)
       return v
    }()
    
    lazy var tableView: UITableView = {
       let tv = UITableView()
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.register(SellerCategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [searchBarView,tableView])
        sv.distribution = .fill
        sv.axis = .vertical
        sv.alignment = .fill
        return sv
    }()
    
    lazy var labelMessgae: UILabel = {
       let lb = UILabel()
        lb.backgroundColor = .clear
        lb.text = "No store has been found!".localized
        lb.textColor = .gray
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.isHidden = true
        return lb
    }()

    //MARK:- Properties
    
    var typeId:String = ""
    var typeName:String = ""
    
    var typeImage:String = ""
    var storeImage:String = ""
    
    var storeName:String = ""
    var storeId:String = ""
    var storeCollectionModel = [Store]()
    var allStores = [Store]()
    var subStoreIsAvailable:Bool?
    var isFastDelivery :Bool = true
    
    //MARK:- Init
    override func viewDidLoad() {
        self.setupVeiw()
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
      
        self.tabBarController?.tabBar.isHidden = false
        //self.navigationController?.navigationBar.isHidden = true
        self.setupTableView()
        detectSelectedBarItem()
        presentSubStores()
        designNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func setupVeiw(){
        self.view.addSubview(mainStackView)
        self.mainStackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor)
        
        self.view.addSubview(labelMessgae)
        labelMessgae.anchor( height: 20)
        NSLayoutConstraint.activate([
            labelMessgae.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelMessgae.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    func designNavigationBar(){
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(1.0, 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 1.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }
    //MARK:- Actions
    @objc
    func userTypingNow(){
        if let storeName = searchBarView.searchTextFeild.text {
            self.handleFilterAction(isFast: isFastDelivery, textSearched: storeName)
        }
    }
    @objc
    func fastDeliveryPressed(){
        isFastDelivery = !isFastDelivery
        
        if let storeName = searchBarView.searchTextFeild.text {
        self.handleFilterAction(isFast: isFastDelivery, textSearched: storeName)
        }
    }
    

    //MARK:- Hanlder
   
    func handleFilterAction(isFast:Bool,textSearched:String){
        if isFast{
            searchBarView.fastDeleviryButton.backgroundColor = #colorLiteral(red: 0.9142650962, green: 0.7360221744, blue: 0, alpha: 1)
            searchBarView.fastDeleviryButton.imageView?.image = searchBarView.fastDeleviryButton.imageView!.image!.withRenderingMode(.alwaysTemplate)
            searchBarView.fastDeleviryButton.imageView?.tintColor = #colorLiteral(red: 0.1725490196, green: 0.2509803922, blue: 0.4352941176, alpha: 1)

        }else{
            searchBarView.fastDeleviryButton.backgroundColor =  #colorLiteral(red: 0.9590495229, green: 0.9533481002, blue: 0.9634318948, alpha: 1)

            searchBarView.fastDeleviryButton.imageView?.image = searchBarView.fastDeleviryButton.imageView!.image!.withRenderingMode(.alwaysTemplate)
            searchBarView.fastDeleviryButton.imageView?.tintColor = .gray
        }
        
        getAllshops(filter: StoresFilter(minOrder: 0, fastDelivery: isFast, page: 0, pageLength: 5, rate: 0, name: textSearched))
    }
    
    func presentSubStores() {
        if let present = subStoreIsAvailable {
            if present{
                searchBarView.isHidden = true
                self.callingHttppApi()
            }
        }
    }
    
    func detectSelectedBarItem(){
        if let index = self.tabBarController?.selectedIndex {
            if index == 1 {
                self.title = "Account".localized
                searchBarView.isHidden = false
                getAllshops(filter: StoresFilter(minOrder: 0, fastDelivery: true, page: 0, pageLength: 5, rate: 0, name: ""))
            }
        }
    }
    
    func getAllshops(filter:StoresFilter){
        NetworkManager.sharedInstance.showLoader()
        storeCollectionModel.removeAll()
        allStores.removeAll()
        AllStoresApi.shared.getAllStores(filter: filter, viewController: self) { (stores, error) in
            if error.isEmpty {
                if stores.isEmpty {
                    self.allStores.removeAll()
                    self.storeCollectionModel.removeAll()
                    self.tableView.reloadData()
                    self.labelMessgae.isHidden = false
                    
                }else{
                    self.labelMessgae.isHidden = true
                    self.allStores = stores
                    self.tableView.reloadData()
                    NetworkManager.sharedInstance.dismissLoader()
                }
            }else{
                print("All shops error says: \(error)")
                NetworkManager.sharedInstance.dismissLoader()
            }
        }
    }
    
    func callingHttppApi(){
        NetworkManager.sharedInstance.showLoader()
        storeCollectionModel.removeAll()
        allStores.removeAll()
        
        var requstParams = [String:String]()
        let language = sharedPrefrence.object(forKey: "language")
        if(language != nil){
            requstParams["lang"] = language as! String
        }else{
            requstParams["lang"] = "en"
        }
        requstParams["type_id"] = self.typeId
            
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"store/list",cuurentView: self){val,responseObject in
                if val == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["error"] != nil{
                       //display the error to the customer
                    }else{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.storeCollectionModel = StoreData(data: dict["stores"]).stores
                        self.tableView.reloadData()

                    }
                }
                else{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "productSeller") {
            let viewController:Productcategory = segue.destination as UIViewController as! Productcategory
            viewController.storeId = storeId
            viewController.storeName = storeName
            viewController.storeImage = storeImage
        }
    }

}

extension SellerCategoryViewController: UITableViewDelegate,UITableViewDataSource{
    func setupTableView(){
      
        tableView.delegate = self
        tableView.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allStores.isEmpty {
            return storeCollectionModel.count
        }else{
            return allStores.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SellerCategoryTableViewCell
        if allStores.isEmpty{
            let substore = storeCollectionModel[indexPath.row]
            cell.configure(with: substore.name, url: substore.image, rate: substore.rate,
                           description:  substore.description, isFast: substore.isfast)
        }else{
            let store = allStores[indexPath.row]
            print("desc: \(store.description)")
            cell.configure(with: store.name, url: store.image, rate: store.rate,
                           description:  store.description, isFast: store.isfast)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allStores.isEmpty{
            storeId = storeCollectionModel[indexPath.row].id
            storeName = storeCollectionModel[indexPath.row].name
            storeImage = storeCollectionModel[indexPath.row].image
            self.performSegue(withIdentifier: "productSeller", sender: self)
        }else{
            storeId = allStores[indexPath.row].id
            storeName = allStores[indexPath.row].name
            storeImage = allStores[indexPath.row].image
            self.performSegue(withIdentifier: "productSeller", sender: self)
        }
    }
}


class StoreData
{
    var stores = [Store]()
    init(data: JSON) {
        if let arrayData1 = data.array{
            stores =  arrayData1.map({(value) -> Store in
                return  Store(data:value)
            })
        }
    }
}
struct Store{
    var id: String
    var name: String
    var description: String
    var rate: String
    var ratersCount: String
    var image: String
    var isfast: String
    init(data:JSON){
        name  = data["name"].stringValue.html2String
        description  = data["description"].stringValue.html2String
        id = data["id"].stringValue
        rate = data["rate"].stringValue
        ratersCount = data["raters_count"].stringValue
        image = data["image"].stringValue
        isfast = data["fast_delivery"].stringValue
    }
}


