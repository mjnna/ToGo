//
//  ReserveTableVC.swift
//  Mjnna_Delivery
//
//  Created by Amr Saleh on 12/5/21.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit


class ReserveTableVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var resturantImageView: UIImageView!
    @IBOutlet weak var DeliveryLabel: UILabel!
    @IBOutlet weak var AvailabilityLabel: UILabel!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var selectDateView: DashedView!
    @IBOutlet weak var timesCollectionView: UICollectionView!
    @IBOutlet weak var numberOfSeatsTextField: UITextField!
    @IBOutlet weak var notesTextView: DashedTextView!
    
    @IBOutlet weak var txtDatePicker: UITextField!
    let datePicker = UIDatePicker()
    let defaults = UserDefaults.standard
    
    var selectedStore: Store!
    var selectedTime = ""
    var selectedDate = ""
    var times: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        nameLabel.text = selectedStore.name
        resturantImageView.loadImageFrom(url: selectedStore.image)
        DeliveryLabel.text = selectedStore.description
        AvailabilityLabel.text = "KSAAvailable".localized
        showDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func payButton(_ sender: Any) {
        var errorMessage = NetworkManager.sharedInstance.language(key: "pleaseselect")+" "
        var isValid:Int = 1
        
        if selectedDate.isEmpty {
            errorMessage+=NetworkManager.sharedInstance.language(key: "theDate")
            txtDatePicker.becomeFirstResponder()
            isValid = 0
        }else if selectedTime.isEmpty {
            errorMessage+=NetworkManager.sharedInstance.language(key: "theTime")
            isValid = 0
        }else if numberOfSeatsTextField.text == "" {
            errorMessage+=NetworkManager.sharedInstance.language(key: "numberOfSeats")
            numberOfSeatsTextField.becomeFirstResponder()
            isValid = 0
        }
        
        if isValid == 0{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: errorMessage)
            return
        }
        
        reserveTableAPI()
    }
    
    func setupViews() {
        HeaderView.layer.shadowColor = UIColor.lightGray.cgColor
        HeaderView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        HeaderView.layer.shadowRadius = 2.0
        HeaderView.layer.shadowOpacity = 0.5
        HeaderView.layer.masksToBounds = false
        
        HeaderView.layer.borderColor = UIColor.lightGray.cgColor
        HeaderView.layer.borderWidth = 0.2
        HeaderView.layer.cornerRadius = 10
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        self.selectedDate = txtDatePicker.text ?? ""
        callingHttppApi()
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    func reloadData() {
        timesCollectionView.register(SlotsCVC.nib(), forCellWithReuseIdentifier: "SlotsCVC")
        //        timesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        timesCollectionView.dataSource = self
        timesCollectionView.delegate = self
    }
    
    func reserveTableAPI() {
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            let sessionId = sharedPrefrence.object(forKey:"token")
            var requstParams = [String:String]()
            requstParams["token"] = sessionId as? String
            
            NetworkManager.sharedInstance.showLoader()
            requstParams["num"] = self.numberOfSeatsTextField.text
            requstParams["date"] = self.selectedDate
            requstParams["time"] = self.selectedTime
            requstParams["store_id"] = "\(self.selectedStore.id)"
            let customerId = self.defaults.object(forKey:"customer_id") as! String
            requstParams["customer_id"] = customerId
            requstParams["description"] = self.notesTextView.text
            
            NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"booking/create", cuurentView: self){success,responseObject in
                
                if success == 1 {
                    self.view.isUserInteractionEnabled = true
                    NetworkManager.sharedInstance.dismissLoader()
                    let dict = JSON(responseObject as! NSDictionary)
                    
                    if dict["state"].intValue != 0{
                        NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.navigationController?.popToRootViewController(animated: false)
                    }else{
                        NetworkManager.sharedInstance.showInfoSnackBar(msg: dict["message"].stringValue)
                    }
                    
                    
                }else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    
    func callingHttppApi(){
        NetworkManager.sharedInstance.showLoader()
        //        storeCollectionModel.removeAll()
        //        allStores.removeAll()
        
        var requstParams = [String:String]()
        let language = sharedPrefrence.object(forKey: "language")
        if(language != nil){
            requstParams["lang"] = language as? String
        } else {
            requstParams["lang"] = "en"
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"time/getAvailableTime?store_id=\(selectedStore.id)&date=\(txtDatePicker.text!)",cuurentView: self){val,responseObject in
            if val == 1 {
                self.view.isUserInteractionEnabled = true
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"] != nil{
                    //display the error to the customer
                } else{
                    if let fetchedTimes = dict["available time"].arrayObject as? [String] {
                        self.times = fetchedTimes
                        self.reloadData()
                    }
                    NetworkManager.sharedInstance.dismissLoader()
                }
            }
            else{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
}


extension ReserveTableVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotsCVC", for: indexPath) as! SlotsCVC
        cell.configureCell(time: times[indexPath.row], isSelected: selectedTime == times[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTime = times[indexPath.row]
        self.timesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height:60)
        
    }
    
}
