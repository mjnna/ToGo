//
//  SettingsViewController.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 25/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK:- Compnent
    lazy var tableView:UITableView = {
       let tv = UITableView()
        tv.tableFooterView = UIView()
        return tv
    }()
    
    //MARK:- properties
    var languageData = [Languages]()
    var languageCode:String = ""
    let defaults = UserDefaults.standard

   
    //MARK:- Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup(){
        configureLanguages()
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom:  view.safeAreaLayoutGuide.bottomAnchor,
                         left: view.leadingAnchor,
                         right: view.trailingAnchor,
                         paddingTop: 0,
                         paddingBottom: 0,
                         paddingLeft: 0,
                         paddingRight: 0)
        tableViewDelegate_dataSource()
    }
    //MARK:- Handler
    func configureLanguages(){
        var Arabic = Languages()
        Arabic.title = "Arabic".localized
        Arabic.code = "ar"
        var English = Languages()
        English.title = "English".localized
        English.code = "en"
        languageData.append(Arabic)
        languageData.append(English)
    }
    func callingLanguageHttppApi(){
        self.view.isUserInteractionEnabled = false
               NetworkManager.sharedInstance.showLoader()
               
                var requstParams = [String:String]()
                if let sessionId = self.defaults.object(forKey:"token") as? String {
                       requstParams["token"] = sessionId
                }
                requstParams["code"] = self.languageCode
        
               
               NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"customer/changeLanguage", cuurentView: self){success,responseObject in
                   if success == 1 {
                       
                       let dict = JSON(responseObject as! NSDictionary)
                       if dict["error"] != nil{
                          //display the error to the customer
                        
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
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        rootviewcontroller.rootViewController =   storyBoard.instantiateViewController(withIdentifier: "rootnav")
                        let mainwindow = (UIApplication.shared.delegate?.window!)!
                        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
                        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
                            
                        }) { (finished) -> Void in
                        }
                       }
                   }else if success == 2{
                       NetworkManager.sharedInstance.dismissLoader()
                   }
               }

    }
    
  

}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableViewDelegate_dataSource(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cell.accessoryType = .none
        cell.textLabel?.alingment()
        let data = languageData[indexPath.row]
        cell.textLabel?.text = data.title.localized
        if sharedPrefrence.object(forKey: "language") != nil{
            let currencyCode = sharedPrefrence.object(forKey: "language") as! String
            if currencyCode == data.code{
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        } 
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Language".localized
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.languageCode = languageData[indexPath.row].code
        self.callingLanguageHttppApi()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return  40
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
