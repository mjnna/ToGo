//
//  LocationDetailsViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 1/2/21.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController {

    @IBOutlet weak var LocationDescription: UILabel!
    
    @IBOutlet weak var StreetTxt: UILabel!
    
    @IBOutlet weak var StreetVal: UILabel!
    
    @IBOutlet weak var BuildingTxt: UILabel!
    
    @IBOutlet weak var BuildingVal: UILabel!
    
    @IBOutlet weak var AppartmentTxt: UILabel!
    
    @IBOutlet weak var AppartmentVal: UILabel!
    
    @IBOutlet weak var StoreyTxt: UILabel!
        
    @IBOutlet weak var StoreyVal: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var setCurrentLocationButton: ShadowButton!
    
    @IBAction func SetLocationTapped(_ sender: Any) {
        callingSetHttppApi()
    }
    
    var locationId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StreetTxt.text = "Street: ".localized
        BuildingTxt.text = "Building".localized
        AppartmentTxt.text = "Appartment".localized
        StoreyTxt.text = "Flowor".localized
        callingHttppApi()
        map.isZoomEnabled = false
        map.isScrollEnabled = false
        map.isUserInteractionEnabled = false
        let title = "Set as default Location".localized
        setCurrentLocationButton.addTitle(title: title, fontSize: 20)
        setCurrentLocationButton.addCorner(with: 25)
        setCurrentLocationButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        // Do any additional setup after loading the view.
    }
    
    func loginRequest(){
        var loginRequest = [String:String]()
        guard let token = sharedPrefrence.object(forKey:"token") as? String else {return}
        loginRequest["token"] = token
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
        let sessionId = sharedPrefrence.object(forKey:"token") as! String;
        var requstParams = [String:String]()
        requstParams["token"] = sessionId
        requstParams["location_id"] = locationId
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"location/details",cuurentView: self){val,responseObject in
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
                    // go to the details page
                    let location = Location(data: dict)
                    self.StreetVal.text = location.street
                    self.BuildingVal.text = location.building
                    self.AppartmentVal.text = location.appartment
                    self.StoreyVal.text = location.storey
                    let selectedLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                    let region = MKCoordinateRegion( center: selectedLocation, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
                    self.map.setRegion(self.map.regionThatFits(region), animated: true)
                    //self.map.setCenter(selectedLocation, animated: true)
                   }
                   
               }else{
                   NetworkManager.sharedInstance.dismissLoader()
                   self.callingHttppApi()
               }
        }
    }

func callingSetHttppApi(){
        let sessionId = sharedPrefrence.object(forKey:"token") as! String;
        var requstParams = [String:String]()
        requstParams["token"] = sessionId
        requstParams["location_id"] = locationId
        
        NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"location/set",cuurentView: self){val,responseObject in
               if val == 1 {
                   self.view.isUserInteractionEnabled = true
                   let dict = JSON(responseObject as! NSDictionary)
                   if dict["error"] != nil{
                    
                    if dict["error"] == "authentication required"{
                        self.loginRequest()
                    }
                    
                   }
                   else{
                    NetworkManager.sharedInstance.dismissLoader()
                    // go to the details page
                    NetworkManager.sharedInstance.showSuccessSnackBar(msg: "Your Location Has Been Set Successfully".localized)
                }
                   
               }
               else{
                   NetworkManager.sharedInstance.dismissLoader()
                   self.callingHttppApi()
               }
           }
        }

}


struct Location{
    var id: String
    var longitude: Double
    var latitude: Double
    var street: String
    var building: String
    var storey: String
    var appartment: String
    var set: Bool
    init(data:JSON){
        longitude  = data["longitude"].doubleValue
        latitude  = data["latitude"].doubleValue
        id = data["id"].stringValue
        street = data["street"].stringValue
        building = data["building"].stringValue
        storey = data["storey"].stringValue
        appartment = data["apartment"].stringValue
        set = data["set"].boolValue
    }
}
