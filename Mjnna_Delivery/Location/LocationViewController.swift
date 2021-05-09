//
//  LocationViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 12/29/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet weak var locationsTable: UITableView!
    
    @IBOutlet weak var addLocationButton: ShadowButton!
    
    var locationsCollectionModel = [Locations]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationsTable.delegate = self
        self.locationsTable.dataSource = self

        designNavigationBar()
        self.navigationItem.title = ""
        self.callingHttppApi()
        self.tabBarController?.tabBar.isHidden = true
        locationsTable.register(LocationTableViewCell.nib(), forCellReuseIdentifier: LocationTableViewCell.identifier)
        locationsTable.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        
        addLocationButton.addCorner(with: 25)
        addLocationButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        addLocationButton.addTitle(title: "Add Location".localized, fontSize: 20)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //super.viewWillDisappear(_animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func designNavigationBar(){
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(1.0, 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 1.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    //MARK:- Actions
    @IBAction func addLocationClick(_ sender: Any) {
        self.performSegue(withIdentifier: "newLocation", sender: self)
    }
    @objc func viewLocationPressed(_ sender:UIButton){
        let buttonIndex:Int = sender.tag
        print("locations index\(buttonIndex)")

        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "locDetails") as! LocationDetailsViewController
        vc.locationId = locationsCollectionModel[buttonIndex].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- Handler
    func callingHttppApi(){
        if let sessionId = sharedPrefrence.object(forKey:"token") as? String{
            var requstParams = [String:String]()
            requstParams["token"] = sessionId
            
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"location/list",cuurentView: self){val,responseObject in
                    if val == 1 {
                        self.view.isUserInteractionEnabled = true
                        let dict = JSON(responseObject as! NSDictionary)
                        if dict["error"] != nil{
                            NotificationCenter.default.post(name: .availablelocation, object: false)
                        }else{
                            
                            NetworkManager.sharedInstance.dismissLoader()
                            self.locationsCollectionModel = LocationsData(data: dict["locations"]).locations
                        
                            self.locationsTable.reloadData()
                            NotificationCenter.default.post(name: .availablelocation, object: true)

                        }
                        
                    }
                    else{
                        NetworkManager.sharedInstance.dismissLoader()
                       
                        self.callingHttppApi()
                    }
                    
                }
        }else{
            self.tabBarController?.selectedIndex = 2
        }
        
    }
    func callingSetHttppApi(locationId:String){
            let sessionId = sharedPrefrence.object(forKey:"token") as! String;
            var requstParams = [String:String]()
            requstParams["token"] = sessionId
            requstParams["location_id"] = locationId
            self.locationsCollectionModel.removeAll()
            NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"location/set",cuurentView: self){val,responseObject in
                               if val == 1 {
                                   self.view.isUserInteractionEnabled = true
                                   let dict = JSON(responseObject as! NSDictionary)
                                   if dict["error"] != nil{
                                    
                                    if dict["error"] == "authentication required"{
                                        self.tabBarController?.selectedIndex = 2
                                    }
                                    
                                   }
                                   else{
                                    NetworkManager.sharedInstance.dismissLoader()
                                    // go to the details page
                                    NetworkManager.sharedInstance.showSuccessSnackBar(msg: "Your Location Has Been Set Successfully".localized)
                                    self.callingHttppApi()
                                }
                                   
                               }
                               else{
                                   NetworkManager.sharedInstance.dismissLoader()
                                   self.callingHttppApi()
                               }
                           }
                   }

}

    extension LocationViewController: UITableViewDelegate{
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    }
    extension LocationViewController: UITableViewDataSource{
     
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return locationsCollectionModel.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
            var location = ""
            location += locationsCollectionModel[indexPath.row].street + ", "
            location += locationsCollectionModel[indexPath.row].building + ", "
            location += locationsCollectionModel[indexPath.row].storey + ", "
            location += locationsCollectionModel[indexPath.row].appartment  + ""
            
            cell.configure(with: location , set: locationsCollectionModel[indexPath.row].set)
            cell.viewLocationButton.addTarget(self, action: #selector(viewLocationPressed(_:)), for: .touchUpInside)
            cell.viewLocationButton.tag = indexPath.row

            return cell

        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            callingSetHttppApi(locationId: locationsCollectionModel[indexPath.row].id)
        }
     
    }

    class LocationsData
    {
        var locations = [Locations]()
        init(data: JSON) {
            if let arrayData1 = data.array{
                locations =  arrayData1.map({(value) -> Locations in
                    return  Locations(data:value)
                })
            }
        }
    }

    struct Locations{
        var id: String
        var longitude: String
        var latitude: String
        var street: String
        var building: String
        var storey: String
        var appartment: String
        var set: Bool
        init(data:JSON){
            longitude  = data["longitude"].stringValue
            latitude  = data["latitude"].stringValue
            id = data["id"].stringValue
            street = data["street"].stringValue
            building = data["building"].stringValue
            storey = data["storey"].stringValue
            appartment = data["apartment"].stringValue
            set = data["set"].boolValue
        }
    }
   


