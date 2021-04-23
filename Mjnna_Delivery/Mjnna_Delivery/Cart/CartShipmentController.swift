////
////  CartShipmentController.swift
////  DrCrazy
////
////  Created by kunal on 05/07/19.
////  Copyright © 2019 webkul. All rights reserved.
////
//
//import UIKit
//
//class CartShipmentController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
//    
//    
//    @IBOutlet weak var closeButton: UIButton!
//    @IBOutlet weak var topMessage: UILabel!
//    @IBOutlet weak var countryLabel: UILabel!
//    @IBOutlet weak var countryPickerView: UIPickerView!
//    @IBOutlet weak var stateLabel: UILabel!
//    @IBOutlet weak var statePickerView: UIPickerView!
//    @IBOutlet weak var zipLabel: UILabel!
//    @IBOutlet weak var zipField: UITextField!
//    @IBOutlet weak var applyButton: UIButton!
//    var shipmentCountryViewModel:ShipmentCountryViewModel!
//    var shipingMethodViewModel:ShipingMethodViewModel!
//    @IBOutlet weak var tableView: UITableView!
//    var defaultShipmentCode:String = ""
//    
//    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
//    
//    var countryId:String = ""
//    var zoneId:String = ""
//    var defaultZonePos:Int = -1
//    
//    enum API_TO_CAll{
//        case getCountryData
//        case getShipmentData
//        case applyShipment
//    }
//    
//    var apiToCall:API_TO_CAll = .getCountryData
//    
//    
//    
//    
//    
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tableView.isHidden = true
//        topMessage.text = "shippingestimate".localized
//        countryLabel.text = "country".localized
//        stateLabel.text = "state".localized
//        zipLabel.text = "zip".localized
//        applyButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
//        applyButton.setTitle("getquotes".localized, for: .normal)
//        apiToCall = .getCountryData
//        
//        self.callingHttppApi()
//    }
//    
//    
//    @IBAction func closeClick(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    
//    @IBAction func applyClick(_ sender: UIButton) {
//        apiToCall = .getShipmentData
//        self.defaultShipmentCode = ""
//        self.callingHttppApi()        
//    }
//    
//    
//    func loginRequest(){
//        var loginRequest = [String:String]();
//        loginRequest["apiKey"] = API_USER_NAME;
//        loginRequest["apiPassword"] = API_KEY.md5;
//        if sharedPrefrence.object(forKey: "language") != nil{
//            loginRequest["language"] = sharedPrefrence.object(forKey: "language") as? String;
//        }
//        if sharedPrefrence.object(forKey: "currency") != nil{
//            loginRequest["currency"] = sharedPrefrence.object(forKey: "currency") as? String;
//        }
//        if sharedPrefrence.object(forKey: "customer_id") != nil{
//            loginRequest["customer_id"] = sharedPrefrence.object(forKey: "customer_id") as? String;
//        }
//        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", cuurentView: self){val,responseObject in
//            if val == 1{
//                
//                let dict = responseObject as! NSDictionary
//                sharedPrefrence.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
//                sharedPrefrence.set(dict.object(forKey: "language") as! String, forKey: "language")
//                sharedPrefrence.set(dict.object(forKey: "currency") as! String, forKey: "currency")
//                sharedPrefrence.synchronize();
//                self.callingHttppApi()
//            }else if val == 2{
//                self.activityIndicatorView.stopAnimating()
//                self.loginRequest()
//            }
//        }
//    }
//    
//    
//    
//    func callingHttppApi(){
//        self.view.isUserInteractionEnabled = false
//        activityIndicatorView.startAnimating()
//        let sessionId = sharedPrefrence.object(forKey:"wk_token");
//        var requstParams = [String:Any]();
//        requstParams["wk_token"] = sessionId;
//        var ApiName:String = ""
//        
//        switch apiToCall {
//        case .getCountryData:
//            ApiName = "cart/getCountry"
//        case .getShipmentData:
//            ApiName = "cart/getShipping"
//            requstParams["zone_id"] = self.zoneId;
//            requstParams["country_id"] = self.countryId;
//            requstParams["postcode"] = self.zipField.text;
//        case .applyShipment:
//            ApiName = "cart/applyShipping";
//            requstParams["shipping_method"] = self.defaultShipmentCode
//            
//        }
//        
//        
//        
//        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:ApiName, cuurentView: self){val,responseObject in
//            if val == 1 {
//                self.view.isUserInteractionEnabled = true
//                self.activityIndicatorView.stopAnimating()
//                let dict = JSON(responseObject as! NSDictionary)
//                if dict["fault"].intValue == 1{
//                    self.loginRequest()
//                }else{
//                    if self.apiToCall == .getCountryData{
//                        self.shipmentCountryViewModel = ShipmentCountryViewModel(data: dict)
//                    }else if self.apiToCall == .getShipmentData{
//                        self.shipingMethodViewModel = ShipingMethodViewModel(data:dict)
//                    }else if self.apiToCall == .applyShipment{
//                        if dict["error"].intValue == 0{
//                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
//                            self.dismiss(animated: true, completion: nil)
//                        }else{
//                            NetworkManager.sharedInstance.showWarningSnackBar(msg: dict["message"].stringValue)
//                        }
//                        
//                    }
//                    self.doFurther()
//                }
//            }else if val == 2{
//                self.activityIndicatorView.stopAnimating()
//                self.callingHttppApi()
//            }
//        }
//    }
//    
//    func doFurther(){
//        
//        if self.apiToCall == .getCountryData{
//            if self.shipmentCountryViewModel.shipmentCountry.count > 0{
//                self.countryPickerView.delegate = self
//                self.countryPickerView.dataSource = self
//                self.countryId = shipmentCountryViewModel.shipmentCountry[0].country_id
//                let data = shipmentCountryViewModel.shipmentCountry[0].zoneData
//                if data.count > 0{
//                    self.defaultZonePos = 0;
//                    self.zoneId = data[0].zone_id
//                }
//                self.statePickerView.delegate =  self
//                self.statePickerView.dataSource = self
//            }
//        }else if self.apiToCall == .getShipmentData{
//            if self.shipingMethodViewModel.shipping_method.count > 0{
//                self.tableView.isHidden = false
//                self.tableView.delegate = self
//                self.tableView.dataSource = self
//                self.tableView.reloadData()
//            }else{
//                NetworkManager.sharedInstance.showWarningSnackBar(msg: "noshipmentavailable".localised)
//            }
//        }
//    }
//    
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == self.countryPickerView{
//            return self.shipmentCountryViewModel.shipmentCountry.count
//        }else if pickerView == self.statePickerView{
//            if defaultZonePos != -1{
//                return self.shipmentCountryViewModel.shipmentCountry[defaultZonePos].zoneData.count
//            }else{
//                return 0
//            }
//        }
//            
//            
//        else{
//            return 0
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == self.countryPickerView{
//            return self.shipmentCountryViewModel.shipmentCountry[row].name
//        }else if pickerView == self.statePickerView{
//            if defaultZonePos != -1{
//                return self.shipmentCountryViewModel.shipmentCountry[defaultZonePos].zoneData[row].name
//            }else{
//                return ""
//            }
//        }
//        else{
//            return ""
//        }
//    }
//    
//    
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        if pickerView == self.countryPickerView{
//            self.countryId = self.shipmentCountryViewModel.shipmentCountry[row].country_id
//            self.defaultZonePos = row
//            self.statePickerView.reloadAllComponents()
//            
//            if self.shipmentCountryViewModel.shipmentCountry[row].zoneData.count > 0{
//                self.zoneId = self.shipmentCountryViewModel.shipmentCountry[row].zoneData[0].zone_id
//            }else{
//                self.zoneId = ""
//            }
//        }else if pickerView == self.statePickerView{
//            self.zoneId = self.shipmentCountryViewModel.shipmentCountry[defaultZonePos].zoneData[row].zone_id
//        }
//    }
//    
//    
//    
//    
//}
//
//
//
//
//extension CartShipmentController:UITableViewDelegate,UITableViewDataSource{
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0{
//            return "shipmentmethod".localized;
//        }else{
//            return ""
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
//            return self.shipingMethodViewModel.shipping_method.count
//        }else{
//            return 1
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if indexPath.section == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            let data = self.shipingMethodViewModel.shipping_method[indexPath.row]
//            if self.defaultShipmentCode == data.code{
//                cell.accessoryType = .checkmark
//            }else{
//                cell.accessoryType = .none
//            }
//            cell.textLabel?.text = data.title
//            cell.detailTextLabel?.text = data.text
//            return cell
//        }else{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartShipmentApplyCell", for: indexPath) as? CartShipmentApplyCell else { return UITableViewCell()}
//            cell.applyButton.addTarget(self, action: #selector(applyShipment(sender:)), for: .touchUpInside)
//            cell.cancelButton.addTarget(self, action: #selector(dismissShipment(sender:)), for: .touchUpInside)
//            return cell
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        defaultShipmentCode = self.shipingMethodViewModel.shipping_method[indexPath.row].code
//        self.tableView.reloadData()
//    }
//    
//    
//    @objc func applyShipment(sender: UIButton){
//        if  defaultShipmentCode == ""{
//            NetworkManager.sharedInstance.showWarningSnackBar(msg: "pleaseselectshipmentmethod".localized)
//        }else{
//            apiToCall = .applyShipment
//            self.callingHttppApi()
//        }
//        
//    }
//    
//    @objc func dismissShipment(sender: UIButton){
//        self.tableView.isHidden = true
//    }
//    
//    
//    
//}
