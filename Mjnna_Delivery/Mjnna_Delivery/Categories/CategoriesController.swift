//
//  CategoriesController.swift
//  OpenCartMpV3
//
//  Created by kunal on 12/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class CategoriesController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var cataegoriesCollectionModel = [Categories]()
    var arrayForBool :NSMutableArray = [];
    var categoryName:String = ""
    var categoryId:String = ""
    var categoryDict :NSDictionary = [:]
    var subCategory:NSArray = []
    var subId:String = ""
    var subName:String = ""
    var subImage:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "categories")
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[0]
        let nav1 = paymentViewNavigationController as! UINavigationController;
        let paymentMethodViewController = nav1.viewControllers[0] as! ViewController
        //cataegoriesCollectionModel = paymentMethodViewController.homeViewModel.cataegoriesCollectionModel
        categoriesTableView.register(UINib(nibName: "CategoryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCellTableViewCell")
        self.categoriesTableView.separatorStyle = .none
        categoriesTableView.delegate = self;
        categoriesTableView.dataSource = self;
        categoriesTableView.separatorColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_WIDTH / 2;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cataegoriesCollectionModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        categoriesTableView.register(UINib(nibName: "CategoryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCellTableViewCell")
        let cell:CategoryCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellTableViewCell") as! CategoryCellTableViewCell
        cell.image1.loadImageFrom(url:cataegoriesCollectionModel[indexPath.row].thumbnail , dominantColor: cataegoriesCollectionModel[indexPath.row].dominant_color)
        cell.nameLabel.text = cataegoriesCollectionModel[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isChild = cataegoriesCollectionModel[indexPath.row].isChild
        if isChild{
            subId = cataegoriesCollectionModel[indexPath.row].id
            subName = cataegoriesCollectionModel[indexPath.row].name
            subImage = cataegoriesCollectionModel[indexPath.row].thumbnail
            self.performSegue(withIdentifier: "subcategory", sender: self)
        }
        else{
            categoryId = cataegoriesCollectionModel[indexPath.row].id
            categoryName = cataegoriesCollectionModel[indexPath.row].name
            //self.performSegue(withIdentifier: "productCategorySegue", sender: self)
            self.performSegue(withIdentifier: "sellerCategory", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "subcategory") {
            let viewController:subCategory = segue.destination as UIViewController as! subCategory
            viewController.subName = subName
            viewController.subId = subId
            viewController.subImage = self.subImage
            
        }else if (segue.identifier == "sellerCategory") {
            let viewController:SellerCategoryViewController = segue.destination as UIViewController as! SellerCategoryViewController
            viewController.typeId = categoryId
            viewController.typeName = categoryName
            
        }
    }
}
