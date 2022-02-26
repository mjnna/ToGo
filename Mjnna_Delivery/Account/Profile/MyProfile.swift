//
//  MyProfile.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 17/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

var languages1: NSMutableArray = []
var currencyData1: NSMutableArray = []


class MyProfile: UIViewController,UIScrollViewDelegate {
    
    //MARK:- Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties

    var bannerImageView:UIImageView!
    let defaults = UserDefaults.standard
    var userProfileData: NSMutableArray = []
    var languageCode:String = ""
//    var currencyData  = [Currency]()
    var languageData = [Languages]()
    var productModel = ProductViewModel()
    var privacyData:NSMutableArray = []
    
    //MARK:- Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        
        userProfileData = ["edityouraccountinfo".localized,
                            "changeyourpassword".localized,
                            "deleteAccount".localized]
    
        self.navigationItem.title = "guestprofile".localized
        
        
        bannerImageView = UIImageView(image: UIImage(named: "beverley"))
//        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = true
    }
}

extension MyProfile:UITableViewDelegate,UITableViewDataSource {
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
//            return privacyData.count
            return languageData.count
        }else{
            return userProfileData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell:UITableViewCell = UITableViewCell(style:.value1, reuseIdentifier:"cell")
            let contentForThisRow  = userProfileData[indexPath.row]
            cell.textLabel?.text = contentForThisRow as? String
            cell.textLabel?.font = UIFont(name: REGULARFONT, size: 15)
            cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
            cell.imageView?.tintColor = .gray
            cell.imageView?.layer.cornerRadius = 4;
            cell.imageView?.clipsToBounds = true
            cell.selectionStyle = .none
            cell.imageView?.contentMode = .scaleAspectFit
            cell.textLabel?.alingment()
            
            if indexPath.row == 0{
                cell.imageView?.image = UIImage(named: "ic_editaccountinfo")!
            }
            else if indexPath.row == 1{
                cell.imageView?.image = UIImage(named: "ic_change_password")!
            } else {
                cell.imageView?.image = UIImage(named: "order_cancel")!
            }
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.navigationBar.isHidden = true

            if indexPath.row == 0{
                self.performSegue(withIdentifier: "myProfileToAccountInformation", sender: self)
            }else if indexPath.row == 1{
                self.performSegue(withIdentifier: "changePassword", sender: self)
            } else {
                let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "message"), message: NetworkManager.sharedInstance.language(key: "logoutmessagewarning"), preferredStyle: .alert)
                let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
//                    self.logoutCustomer()
//                    self.sideMenu.loadMenu()
                })
                let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                })
                AC.addAction(okBtn)
                AC.addAction(noBtn)
                self.present(AC, animated: true, completion: nil)
            }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
        
    }
    
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
}

extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}






