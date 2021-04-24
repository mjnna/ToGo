//
//  EditAccountInformation.swift
//  OpenCartApplication
//
//  Created by shobhit on 24/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit

class EditAccountInformation: UIViewController,UITableViewDelegate ,UITableViewDataSource,FormFieldTextValueHandler{
    var editAccountInformationViewModel:EditAccountInformationViewModel!
    let defaults = UserDefaults.standard;
    var whichApiToProcess:String  = ""
    @IBOutlet var tableView: UITableView!
    var formTypeData = [FormFielderType]()
    var accesibleType = [String]()
    @IBOutlet var continueButton: UIButton!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = NetworkManager.sharedInstance.language(key: "accountinformation")
        whichApiToProcess = ""
        formTypeData = [.normalTextField,.normalTextField,.emailTextField,.phonetextField]
        accesibleType = ["firstname","lastname","email","phone","fax"]
        tableView.register(UINib(nibName: "NormalTextField", bundle: nil), forCellReuseIdentifier: "NormalTextField")
        tableView.register(UINib(nibName: "EmailTextFieldCell", bundle: nil), forCellReuseIdentifier: "EmailTextFieldCell")
        tableView.register(UINib(nibName: "PhoneTextFieldCell", bundle: nil), forCellReuseIdentifier: "PhoneTextFieldCell")
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 20
        continueButton.setTitle("continue".localized, for: .normal)
        continueButton.isHidden = true
        continueButton.applyCorner()
        callingHttppApi();
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
        
        if let sessionId = self.defaults.object(forKey:"token") as? String {
            let customerId = self.defaults.object(forKey:"customer_id") as! String
            var requstParams = [String:String]();
            requstParams["token"] = sessionId;
            requstParams["customer_id"] = customerId;
            
            if whichApiToProcess == "editCustomer" {
                requstParams["ar_name"] = self.editAccountInformationViewModel.addrerssReceivedModel.firstName
                requstParams["en_name"] = self.editAccountInformationViewModel.addrerssReceivedModel.lastName
                requstParams["email"] = self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress
                requstParams["phone"] = self.editAccountInformationViewModel.addrerssReceivedModel.telephone
                
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"customer/edit", cuurentView: self){success,responseObject in
                    
                    if success == 1 {
                        let dict = JSON(responseObject as! NSDictionary)
                        if dict["error"] != nil{
                            //display the error to the customer
                            if dict["error"] == "authentication required"{
                                self.loginRequest()
                            }
                            let AC = UIAlertController(title: "warning".localized, message: dict["error"].stringValue, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                
                            })
                            AC.addAction(okBtn)
                            self.present(AC, animated: true, completion:nil)
                        }else{
                            self.view.isUserInteractionEnabled = true
                            NetworkManager.sharedInstance.dismissLoader()
                            
                            self.defaults.set(self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress, forKey: "email")
                            self.defaults.set(self.editAccountInformationViewModel.addrerssReceivedModel.firstName, forKey: "firstname")
                            self.defaults.set(self.editAccountInformationViewModel.addrerssReceivedModel.lastName, forKey: "lastname")
                            self.defaults.synchronize()
                            self.navigationController?.popViewController(animated: true)
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg:"your info has been updated successfully".localized)
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }else{
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"customer/details", cuurentView: self){success,responseObject in
                    
                    if success == 1 {
                        let dict = JSON(responseObject as! NSDictionary)
                        if dict["error"] != nil{
                            //display the error to the customer
                            if dict["error"] == "authentication required"{
                                self.loginRequest()
                            }
                            let AC = UIAlertController(title: "warning".localized, message: dict["error"].stringValue, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                
                            })
                            AC.addAction(okBtn)
                            self.present(AC, animated: true, completion:nil)
                        }else{
                            self.view.isUserInteractionEnabled = true
                            NetworkManager.sharedInstance.dismissLoader()
                            self.editAccountInformationViewModel = EditAccountInformationViewModel(data: JSON(responseObject as! NSDictionary))
                            self.doFurtheProcessingWithResult()
                            
                            
                        }
                    }else if success == 2{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
        }else{
        
        }
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return formTypeData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formType = formTypeData[indexPath.row]
        
        switch  formType{
        case .emailTextField:
            let cell:EmailTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "EmailTextFieldCell") as! EmailTextFieldCell
            cell.delegate = self
            if accesibleType[indexPath.row] == "email"{
                cell.usernameTextFieldController.placeholderText = "email".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
                cell.textFieldNormal.text = self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress
            }
            return cell
        case .normalTextField:
            let cell:NormalTextField = tableView.dequeueReusableCell(withIdentifier: "NormalTextField") as! NormalTextField
            cell.delegate = self
            if accesibleType[indexPath.row] == "firstname"{
                cell.usernameTextFieldController.placeholderText = "firstname".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
                cell.textFieldNormal.text = self.editAccountInformationViewModel.addrerssReceivedModel.firstName
            }else if accesibleType[indexPath.row] == "lastname"{
                cell.usernameTextFieldController.placeholderText = "lastname".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
                cell.textFieldNormal.text = self.editAccountInformationViewModel.addrerssReceivedModel.lastName
            }
            return cell
        case .phonetextField:
            let cell:PhoneTextFieldCell = tableView.dequeueReusableCell(withIdentifier: "PhoneTextFieldCell") as! PhoneTextFieldCell
            cell.delegate = self
            if accesibleType[indexPath.row] == "phone"{
                cell.usernameTextFieldController.placeholderText = "telephoneno".localized
                cell.textFieldNormal.accessibilityLabel = accesibleType[indexPath.row]
                cell.textFieldNormal.text = self.editAccountInformationViewModel.addrerssReceivedModel.telephone
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func doFurtheProcessingWithResult(){
        continueButton.isHidden = false
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    
    @IBAction func continueAction(_ sender: UIButton) {
        whichApiToProcess = "editCustomer"
        
        if !self.editAccountInformationViewModel.addrerssReceivedModel.firstName.isValid(name:"firstname".localized ){
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NormalTextField {
                cell.textFieldNormal.becomeFirstResponder()
            }
            return
        }
        else if !self.editAccountInformationViewModel.addrerssReceivedModel.lastName.isValid(name:"lastname".localized ){
            if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? NormalTextField {
                cell.textFieldNormal.becomeFirstResponder()
            }
            return
        }
        else if !self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress.isValid(name:"email".localized ){
            if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EmailTextFieldCell {
                cell.textFieldNormal.becomeFirstResponder()
            }
            return
        }
        else if !self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress.isValidEmail() {
            NetworkManager.sharedInstance.showErrorSnackBar(msg: "invalidemail".localized)
            if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EmailTextFieldCell {
                cell.textFieldNormal.becomeFirstResponder()
            }
            return
        }
            
        else if !self.editAccountInformationViewModel.addrerssReceivedModel.telephone.isValid(name:"mobileno".localized ){
            if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? PhoneTextFieldCell {
                cell.textFieldNormal.becomeFirstResponder()
            }
            return
        }
        
        
        callingHttppApi();
        
    }
    
    
    
}



extension EditAccountInformation{
    
    
    func getFormFieldValue(val:String,type:String){
        switch  type {
        case "firstname":
            self.editAccountInformationViewModel.addrerssReceivedModel.firstName = val
            break
        case "lastname":
            self.editAccountInformationViewModel.addrerssReceivedModel.lastName = val
            break
        case "email":
            self.editAccountInformationViewModel.addrerssReceivedModel.emailAddress = val
            break
        case "phone":
            self.editAccountInformationViewModel.addrerssReceivedModel.telephone = val
            break
        default:
            break
        }
    }
}
