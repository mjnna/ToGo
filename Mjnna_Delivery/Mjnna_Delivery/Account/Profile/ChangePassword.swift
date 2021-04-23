//
//  ChangePassword.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class ChangePassword: UIViewController,UITableViewDelegate,UITableViewDataSource,FormFieldTextValueHandler {
    let defaults = UserDefaults.standard;
    @IBOutlet var tableView: UITableView!
    var formTypeData = [FormFielderType]()
    var accesibleType = [String]()
    
    
    @IBOutlet var continueButton: UIButton!
    var passwordData:String = ""
    var conPasswordData:String = ""
    var curPasswordData:String = ""
    
    
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.title = NetworkManager.sharedInstance.language(key: "changepassword")
        formTypeData = [.passwordTextField,.passwordTextField,.passwordTextField]
        accesibleType = ["curpassword","password","conpassword"]
        tableView.register(UINib(nibName: "PasswordTextFieldCell", bundle: nil), forCellReuseIdentifier: "PasswordTextFieldCell")
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 20
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        continueButton.setTitle("save".localized, for: .normal)
        continueButton.applyCorner()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        self.view.isUserInteractionEnabled = false
        NetworkManager.sharedInstance.showLoader()
        
        let sessionId = self.defaults.object(forKey:"token") as! String;
        var requstParams = [String:String]();
        requstParams["token"] = sessionId;
        requstParams["newPassword"] = passwordData
        requstParams["oldPassword"] = curPasswordData
        
        NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"changePassword", cuurentView: self){success,responseObject in
            if success == 1 {
                
                let dict = JSON(responseObject as! NSDictionary);
                if dict["error"] != nil{
                   //display the error to the customer
                 if dict["error"] == "authentication required"{
                     self.loginRequest()
                 }
                 
                }else{
                    
                    NetworkManager.sharedInstance.dismissLoader()
                    self.navigationController?.popViewController(animated: true)
                    NetworkManager.sharedInstance.showSuccessSnackBar(msg:dict["suceess"].stringValue)
                }
            }else if success == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
        
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        var msg : String = ""
        var passwdStatus = false
        if curPasswordData == ""{
            msg = NetworkManager.sharedInstance.language(key: "pleasefillpassword");
        }
        if passwordData == ""{
            msg = NetworkManager.sharedInstance.language(key: "pleasefillpassword");
        }
        else if (passwordData.count) < 4{
            msg = NetworkManager.sharedInstance.languageBundle.localizedString(forKey: "passwordmusthave4characters", value: "", table: nil);
        }
        else if conPasswordData == ""{
            msg = NetworkManager.sharedInstance.language(key: "pleasefillconfirmnewpassword");
            passwdStatus = true
            if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PasswordTextFieldCell {
                cell.textFieldNormal.becomeFirstResponder()
            }
        }
        else if (passwordData != conPasswordData){
            msg = NetworkManager.sharedInstance.language(key:  "passwordnotmatch");
        }
        
        if msg != ""{
            NetworkManager.sharedInstance.showErrorSnackBar(msg:msg)
            if !passwdStatus {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PasswordTextFieldCell {
                    cell.textFieldNormal.becomeFirstResponder()
                }
            }
            
        }else{
            callingHttppApi();
        }
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return formTypeData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formType = formTypeData[indexPath.row]
        switch  formType{
        case .passwordTextField:
            let cell:PasswordTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "PasswordTextFieldCell") as! PasswordTextFieldCell
            cell.delegate = self
            if accesibleType[indexPath.row] == "password"{
                cell.usernameTextFieldController.placeholderText = "password".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
            }else if accesibleType[indexPath.row] == "conpassword"{
                cell.usernameTextFieldController.placeholderText = "conpassword".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
            }else if accesibleType[indexPath.row] == "curpassword"{
                cell.usernameTextFieldController.placeholderText = "Current Password".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    
    
    func getFormFieldValue(val:String,type:String){
        switch  type {
        case "password":
            passwordData = val
            break
        case "conpassword":
            conPasswordData = val
            break
        case "curpassword":
            curPasswordData = val
            break
        default:
            break
        }
    }
    
    
    
    
    
    
    
    
    
}
