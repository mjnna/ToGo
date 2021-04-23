//
//  ViewReturnRequestDataController.swift
//  MobikulOpencartMp
//
//  Created by kunal on 02/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class ViewReturnRequestDataController: UIViewController {
    
    var returnId:String = ""
    let defaults = UserDefaults.standard;
    var returnRequestModel: ViewReturnRequestModel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NetworkManager.sharedInstance.language(key: "viewreturnrequest");
        
        tableView.register(UINib(nibName: "ViewOrderInfoCell", bundle: nil), forCellReuseIdentifier: "ViewOrderInfoCell")
        tableView.register(ViewHistoryStatusTableViewCell.nib, forCellReuseIdentifier: ViewHistoryStatusTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        tableView.separatorColor = UIColor.clear
        
        if(defaults.object(forKey:"wk_token") == nil){
            loginRequest()
        } else{
            callingHttppApi()
        }
    }
    
    func loginRequest() {
        var loginRequest = [String:String]();
        loginRequest["apiKey"] = API_USER_NAME;
        loginRequest["apiPassword"] = API_KEY.md5;
        if self.defaults.object(forKey: "language") != nil{
            loginRequest["language"] = self.defaults.object(forKey: "language") as? String;
        }
        if self.defaults.object(forKey: "currency") != nil{
            loginRequest["currency"] = self.defaults.object(forKey: "currency") as? String;
        }
        if self.defaults.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = self.defaults.object(forKey: "customer_id") as? String;
        }
        NetworkManager.sharedInstance.callingHttpRequest(
            params:loginRequest,
            apiname:"common/apiLogin",
            cuurentView: self
        ) {val,responseObject in
            if val == 1{
                let dict = responseObject as! NSDictionary
                self.defaults.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
                self.defaults.set(dict.object(forKey: "language") as! String, forKey: "language")
                self.defaults.set(dict.object(forKey: "currency") as! String, forKey: "currency")
                self.defaults.synchronize();
                self.callingHttppApi()
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
            }
        }
    }
    
    func callingHttppApi() {
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        let sessionId = self.defaults.object(forKey:"wk_token");
        var requstParams = [String:Any]();
        requstParams["wk_token"] = sessionId;
        requstParams["return_id"] = self.returnId;
        
        NetworkManager.sharedInstance.callingHttpRequest(
            params:requstParams,
            apiname:"customer/getReturnInfo",
            cuurentView: self
        ) {success,responseObject in
            if success == 1 {
                self.view.isUserInteractionEnabled = true
                NetworkManager.sharedInstance.dismissLoader()
                let dict = responseObject as! NSDictionary;
                if dict.object(forKey: "fault") != nil{
                    let fault = dict.object(forKey: "fault") as! Bool;
                    if fault {
                        self.loginRequest()
                    }
                }else{
                    self.returnRequestModel = ViewReturnRequestModel(data:JSON(responseObject as! NSDictionary))
                    self.tableView.delegate  = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
               }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
}

//MARK:- TableView Methods
extension ViewReturnRequestDataController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if returnRequestModel.returnHistoryDataModel.count > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return section == 1 ? returnRequestModel.returnHistoryDataModel.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewOrderInfoCell", for: indexPath) as! ViewOrderInfoCell
            cell.data = returnRequestModel
            return cell
        }else {
            let cell:ViewHistoryStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: ViewHistoryStatusTableViewCell.reuseIdentifier) as! ViewHistoryStatusTableViewCell
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.dateAdded.font = UIFont.boldSystemFont(ofSize: 14.0)
                cell.status.font = UIFont.boldSystemFont(ofSize: 14.0)
                cell.comment.font = UIFont.boldSystemFont(ofSize: 14.0)
                cell.dateAdded.text = "dateadded".localized
                cell.status.text = "orderstatus".localized
                cell.comment.text = "comment".localized
            }else {
                cell.data = returnRequestModel.returnHistoryDataModel[indexPath.row - 1]
            }
            return cell
        }
    }
}
