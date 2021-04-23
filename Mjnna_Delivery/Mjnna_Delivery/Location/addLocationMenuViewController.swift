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
    @IBOutlet weak var SreetLabel: UITextField!
    
    @IBOutlet weak var BuildingLabel: UITextField!
    
    @IBOutlet weak var AppartmentLabel: UITextField!
    
    @IBOutlet weak var StoreyLabel: UITextField!
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var SelectedLocation: UILabel!
    
    
    var longitude : Double = 0.0
    var latitude : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        SaveButton.layer.cornerRadius = 10
        SaveButton.layer.masksToBounds = true
        SaveButton.titleLabel?.text = "save".localized
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
        
        requstParams["street"] = self.SreetLabel.text
        requstParams["building"] = self.BuildingLabel.text
        requstParams["apartment"] = self.AppartmentLabel.text
        requstParams["storey"] = self.StoreyLabel.text
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
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let locViewController = storyBoard.instantiateViewController(withIdentifier: "locDetails") as! LocationDetailsViewController
                                locViewController.locationId = dict["id"].stringValue
                                self.modalPresentationStyle = .overFullScreen
                                self.navigationController?.pushViewController(locViewController, animated: true)
                                // go to the details page
                                
                               }
                               
                           }
                           else{
                               NetworkManager.sharedInstance.dismissLoader()
                               self.callingHttppApi()
                           }
                       }
               }

}
