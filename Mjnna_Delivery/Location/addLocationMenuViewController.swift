//
//  addLocationMenuViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 12/30/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class addLocationMenuViewController: UIViewController {
    @IBOutlet weak var streetTextField: UITextField!
    
    @IBOutlet weak var buildingTextField: UITextField!
    
    @IBOutlet weak var appartmentTextField: UITextField!
    
    @IBOutlet weak var floorTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var selectedLocation: UILabel!
    
    
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var backToCart: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.selectedLocation.text = "Selected location".localized
        self.streetTextField.placeholder = "Street".localized
        self.buildingTextField.placeholder = "Building".localized
        self.appartmentTextField.placeholder = "Appartment".localized
        self.floorTextField.placeholder = "Floor".localized

        saveButton.layer.cornerRadius = 10
        saveButton.layer.masksToBounds = true
        saveButton.titleLabel?.text = "save".localized
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(fromCartFlagUpdated(_:)), name: .fromCart, object: nil)
    }
    
    //MARK: - Actions
    
    @objc func fromCartFlagUpdated(_ notifcation:Notification){
        if let notification = notifcation.object as? Bool {
            backToCart = notification
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        callingHttppApi()
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
                    sharedPrefrence.set(dict["token"].stringValue , forKey: "token")
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
        let sessionId = sharedPrefrence.object(forKey:"token") as! String;
        var requstParams = [String:String]()
        requstParams["token"] = sessionId
        
        requstParams["street"] = self.streetTextField.text
        requstParams["building"] = self.buildingTextField.text
        requstParams["apartment"] = self.appartmentTextField.text
        requstParams["storey"] = self.floorTextField.text
        requstParams["latitude"] = String(format: "%f", self.latitude)
        requstParams["longitude"] = String(format: "%f", self.longitude)
        
        NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"location/add",cuurentView: self){val,responseObject in
                           if val == 1 {
                               self.view.isUserInteractionEnabled = true
                               let dict = JSON(responseObject as! NSDictionary)
                               if dict["error"] != nil{
                                  //display the error to the customer
                                if dict["error"] == "authentication required"{
                                    self.loginRequest()
                                }
                                
                               }
                               else{
                                NetworkManager.sharedInstance.dismissLoader()
                                NetworkManager.sharedInstance.showSuccessSnackBar(msg: "Your Location Has Been Added Successfully".localized)
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                                if self.backToCart {
                                    self.navigationController?.popViewController(animated: true)
                                }else{
                                    let locViewController = storyBoard.instantiateViewController(withIdentifier: "locDetails") as! LocationDetailsViewController
                                    locViewController.locationId = dict["id"].stringValue
                                    self.modalPresentationStyle = .overFullScreen
                                    self.navigationController?.pushViewController(locViewController, animated: true)
                                }
                               }
                               
                           }
                           else{
                               NetworkManager.sharedInstance.dismissLoader()
                               self.callingHttppApi()
                           }
                       }
               }

}
