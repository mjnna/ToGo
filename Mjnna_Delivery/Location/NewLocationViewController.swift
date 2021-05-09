//
//  addLocationViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 12/30/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit
import FloatingPanel
import GoogleMaps
import GooglePlaces

class NewLocationViewController: UIViewController, FloatingPanelControllerDelegate, CLLocationManagerDelegate {

    @IBAction func LocationTapped(_ sender: Any) {
        gotoPlaces()
    }
    
    
    @IBOutlet weak var TextSearch: UITextField!
    
    @IBOutlet weak var mapView: GMSMapView!
    var menuVc:addLocationMenuViewController? = nil
    var GoogleMapView:GMSMapView!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var geoCoder :CLGeocoder!
    var fromCart:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        TextSearch.isHidden = true
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.locationManager.startUpdatingLocation()
        // floating panel
        let fpc = FloatingPanelController()
        fpc.layout = MyFloatingPanelLayout()
        fpc.delegate = self
        fpc.surfaceView.contentPadding = .init(top: 0, left: 5, bottom: 20, right: 5)
        guard let contentVc = storyboard?.instantiateViewController(withIdentifier: "fpc_location") as? addLocationMenuViewController else{
            return
        }
        menuVc = contentVc
        fpc.set(contentViewController: contentVc)
        fpc.addPanel(toParent: self)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .fromCart, object: fromCart)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
   
    func gotoPlaces(){
        TextSearch.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.menuVc!.latitude = manager.location?.coordinate.latitude ?? self.menuVc!.latitude
        self.menuVc!.longitude = manager.location?.coordinate.longitude ?? self.menuVc!.longitude
        let camera = GMSCameraPosition.camera(withLatitude:self.menuVc!.latitude , longitude: self.menuVc!.longitude, zoom: 15)
        self.mapView.camera = camera
        locationManager.stopUpdatingLocation()
    }
}


extension NewLocationViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        mapView.clear()
        TextSearch.text = place.name
        
        let cord2D = CLLocationCoordinate2D(latitude: (place.coordinate.latitude),longitude: (place.coordinate.longitude))
        let marker = GMSMarker()
        marker.position = cord2D
        marker.title = "Location".localized
        marker.snippet = place.name
        let markerImage = UIImage(named: "marker")
        let markerView = UIImageView(image: markerImage)
        
        marker.iconView = markerView
        marker.map = self.mapView
        
        mapView.camera = GMSCameraPosition.camera(withTarget: cord2D, zoom: 15)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
    
    
}



extension NewLocationViewController: GMSMapViewDelegate {
    
    func SetUpMap(){
        let camera = GMSCameraPosition.camera(withLatitude:self.menuVc!.latitude, longitude: self.menuVc!.longitude, zoom: 15)
        GoogleMapView = GMSMapView.map(withFrame: CGRect(0, 0, SCREEN_WIDTH, self.mapView.frame.height), camera: camera)
        GoogleMapView.delegate = self
        self.mapView.addSubview(GoogleMapView)
        //self.mapView.bringSubviewToFront(pinImage)
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.menuVc!.latitude = position.target.latitude
        self.menuVc!.longitude = position.target.longitude
        
        mapView.clear()
        //TextSearch.text = place.name
        
        let cord2D = CLLocationCoordinate2D(latitude: (menuVc!.latitude),longitude: (menuVc!.longitude))
        let marker = GMSMarker()
        marker.position = cord2D
        marker.title = "Location".localized
        marker.snippet = "location"
        let markerImage = UIImage(named: "marker")
        let markerView = UIImageView(image: markerImage)
        
        marker.iconView = markerView
        marker.map = self.mapView
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.menuVc!.latitude, longitude: self.menuVc!.longitude)
                geoCoder.reverseGeocodeLocation(location, completionHandler:
                    {
                        placemarks, error -> Void in
        
                        // Place details
                        guard let placeMark = placemarks?.first else { return }
        
                        // Location name
                        if let locationName = placeMark.location {
                            
                            print(locationName)
                        }
                        // Street address
                        if let street = placeMark.thoroughfare {
                            self.menuVc?.streetTextField.text = street.trimmingCharacters(in:.whitespacesAndNewlines)
                            print(street)
                        }
                        // City
                        if let city = placeMark.subAdministrativeArea {
                            self.menuVc?.selectedLocation.text = city.trimmingCharacters(in:.whitespacesAndNewlines)
                            print(city)
                        }
                        else if let country = placeMark.country {
                            self.menuVc?.selectedLocation.text = country.trimmingCharacters(in:.whitespacesAndNewlines)
                            print(country)
                        }
                        else
                        {
                            self.menuVc?.selectedLocation.text = "not defined".localized
                        }
                        // Zip code
                        if let zip = placeMark.isoCountryCode {
                            print(zip)
                        }
                        // Country
                })
    }
    
}
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 5.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 10.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}


