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


class MyProfile: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bannerImageView:UIImageView!
    let defaults = UserDefaults.standard;
//    var userProfileData: NSMutableArray = []
    var whichApiToProcess:String = ""
    var languageCode:String = ""
    //var currencyData  = [Currency]()
    var languageData = [Languages]()
    var productModel = ProductViewModel()
    var privacyData:NSMutableArray = []
    //var footerData = [FooterData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var Arabic = Languages()
        Arabic.title = "Arabic".localized
        Arabic.code = "ar"
        var English = Languages()
        English.title = "English".localized
        English.code = "en"
        //languageData.append(Arabic)
        languageData.append(English)
        self.navigationController?.navigationBar.isHidden = false
     
        
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        
        userProfileData = ["edityouraccountinfo".localized,
                            "changeyourpassword".localized,
                            "logout".localized
                            ];
        
        
        self.navigationItem.title = "guestprofile".localized
        
        bannerImageView = UIImageView(image: UIImage(named: "beverley"))
        
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[0]
        let nav1 = paymentViewNavigationController as! UINavigationController;
//        let paymentMethodViewController = nav1.viewControllers[0] as! ViewController
        //currencyData = paymentMethodViewController.homeViewModel.currencyData
        //languageData = paymentMethodViewController.homeViewModel.languageData
        //self.footerData = paymentMethodViewController.homeViewModel.footerData
        //for data in self.footerData{
        //    privacyData.add(data.title)
        //}
    }
    
    @IBAction func wishlistTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "mywishlist", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
        whichApiToProcess = ""
        
        if defaults.object(forKey: "token") != nil{
            //self.navigationController?.isNavigationBarHidden = true
            self.navigationItem.title = "profile".localized
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
        }else{
            self.navigationItem.title = ""
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            performSegue(withIdentifier: "signInUp", sender: self)
            
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            //return privacyData.count
            return languageData.count
        }
        else{
            return userProfileData.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1{
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
                }else if indexPath.row == 2{
                    cell.imageView?.image = UIImage(named: "ic_reward")!
                }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingcell", for: indexPath)
            cell.accessoryType = .none
            cell.textLabel?.alingment()
            cell.textLabel?.text = languageData[indexPath.row].title
            if sharedPrefrence.object(forKey: "language") != nil{
                let currencyCode = sharedPrefrence.object(forKey: "language") as! String
                if currencyCode == languageData[indexPath.row].code{
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            return cell
        }
    }
    
    
    @objc func changeSetting(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AppSettingController") as? AppSettingController
        //vc?.languageData = self.languageData
        //vc?.currencyData = self.currencyData
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 1{
            if indexPath.row == 0{
                self.performSegue(withIdentifier: "myProfileToAccountInformation", sender: self)
            }else if indexPath.row == 1{
                self.performSegue(withIdentifier: "changePassword", sender: self)
            }
            else if indexPath.row == 2{
                let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "message"), message: NetworkManager.sharedInstance.language(key: "logoutmessagewarning"), preferredStyle: .alert)
                let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.whichApiToProcess = ""
                    self.callingHttppApi()
                })
                let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                })
                AC.addAction(okBtn)
                AC.addAction(noBtn)
                self.present(AC, animated: true, completion: nil)
            }
        }else if indexPath.section == 0{
            self.languageCode = languageData[indexPath.row].code
            self.callingLanguageHttppApi()
        }
    }
    
    func callingLanguageHttppApi(){
        self.view.isUserInteractionEnabled = false
               NetworkManager.sharedInstance.showLoader()
               
               let sessionId = self.defaults.object(forKey:"token") as! String;
               var requstParams = [String:String]();
               requstParams["token"] = sessionId;
                requstParams["code"] = self.languageCode;
        
               
               NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"customer/changeLanguage", cuurentView: self){success,responseObject in
                   if success == 1 {
                       
                       let dict = JSON(responseObject as! NSDictionary);
                       if dict["error"] != nil{
                          //display the error to the customer
                        if dict["error"] == "authentication required"{
                            self.loginRequest()
                        }
                        
                       }else{
                           
                           NetworkManager.sharedInstance.dismissLoader()
                        
                        self.defaults.set(self.languageCode, forKey: "language")
                        self.defaults.synchronize()
                        if self.languageCode == "ar" {
                               L102Language.setAppleLAnguageTo(lang: "ar")
                               if #available(iOS 9.0, *) {
                                   UIView.appearance().semanticContentAttribute = .forceRightToLeft
                               } else {
                                   // Fallback on earlier versions
                               }
                           }else {
                               L102Language.setAppleLAnguageTo(lang: "en")
                               if #available(iOS 9.0, *) {
                                   UIView.appearance().semanticContentAttribute = .forceLeftToRight
                               } else {
                                   // Fallback on earlier versions
                               }
                           }

                        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
                        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "rootnav")
                        let mainwindow = (UIApplication.shared.delegate?.window!)!
                        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
                        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
                            
                        }) { (finished) -> Void in
                        }
                       }
                   }else if success == 2{
                       NetworkManager.sharedInstance.dismissLoader()
                       self.callingHttppApi()
                   }
               }
              
        
    }
    
    func loginRequest(){
        var loginRequest = [String:String]();
        
        loginRequest["token"] = sharedPrefrence.object(forKey:"token") as! String;
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"refresh", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"] != nil{
                    print("go to login page")
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
        for key in UserDefaults.standard.dictionaryRepresentation().keys {  //guestcheckout
            if(
                key.description == "language" ||
                key.description == "AppleLanguages" ||
                key.description == "currency" ||
                key.description == "guest" ||
                key.description == "touchIdFlag" ||
                key.description == "TouchEmailId" ||
                key.description == "TouchPasswordValue" ||
                key.description == "deviceToken" ||
                key.description == "appstartlan")
            {
                continue
            }else{
                UserDefaults.standard.removeObject(forKey: key.description)
            }
        }
        
        UserDefaults.standard.synchronize()
        self.tabBarController!.tabBar.items?[1].badgeValue = nil
        self.viewWillAppear(true)
        NetworkManager.sharedInstance.updateCartShortCut(count:"", succ: false)
        self.productModel.deleteAllRecentViewProductData()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshRecentView"), object: nil)
        NetworkManager.sharedInstance.showSuccessSnackBar(msg:NetworkManager.sharedInstance.language(key: "logoutmessage"))
       // NotificationCenter.default.post(name: Notification.Name(rawValue: "removewishlistdata"), object: self)
    }
    
}


let APPLE_LANGUAGE_KEY = "AppleLanguages"

/// L102Language

public class L102Language {
    
    /// get current Apple language
    
    class func currentAppleLanguage() -> String{
        
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    
    class func setAppleLAnguageTo(lang: String) {
        
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
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






