//
//  CheckOutViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 1/9/21.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit
import PassKit

@available(iOS 13.4, *)
class CheckOutViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var deliveryAddressView: DashedView!
    @IBOutlet weak var DateView: DashedView!
    @IBOutlet weak var DeliveryAddresText: UILabel!
    @IBOutlet weak var DeliveryAddressValue: UILabel!
    @IBOutlet weak var ChangeAddresButton: UIButton!
    @IBOutlet weak var NotesText: UILabel!
    @IBOutlet weak var NotesValue: DashedTextView!
    @IBOutlet weak var DeliveryDateText: UILabel!
    @IBOutlet weak var paymentWayTitle: UILabel!
    @IBOutlet weak var PaymentView: DashedView!
    @IBOutlet weak var CheckoutButton: ShadowButton!
    @IBOutlet weak var paymentName: UILabel!
    @IBOutlet weak var checkPaymentButton: UIButton!
    @IBOutlet weak var checkPaymentView: UIView!
    @IBOutlet weak var applePayLabel: UILabel!
    @IBOutlet weak var checkApplePayButton: UIButton!
    @IBOutlet weak var checkApplePayView: UIView!
    
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBOutlet weak var deliveryDateTextField: UITextField!
    //MARK:- Properties
    var fastDelivery:Int = 0
    var checkout:Bool = false
    let borderLayer = CAShapeLayer()
    let datePicker = UIDatePicker()
    var payWithApple = false
    var subTotal = ""
    var delivery = ""
    var total = ""
    
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    
    //MARK:- Init
    @IBAction func checkPAymentPressed(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callingLocationHttppApi()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callingLocationHttppApi()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @available(iOS 13.4, *)
    private func setupView(){
        CheckoutButton.addCorner(with: 25)
        CheckoutButton.addTitle(title: "Check out".localized, fontSize: 20)
        CheckoutButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        
        //PaymentView
        checkPaymentView.layer.borderWidth = 1
        checkPaymentView.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR).cgColor
        checkPaymentView.layer.cornerRadius = checkPaymentView.frame.height/2
        checkPaymentButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        checkPaymentButton.layer.cornerRadius = checkPaymentButton.frame.height/2
        
        checkApplePayView.layer.borderWidth = 1
        checkApplePayView.layer.cornerRadius = checkPaymentView.frame.height/2
        checkApplePayButton.layer.cornerRadius = checkPaymentButton.frame.height/2
        
        paymentName.text = "On delivery".localized
        paymentWayTitle.text = "Payment way:".localized
        
        applePayLabel.text = "Apple Pay"
        
        notesLabel.text = "Notes".localized
        
        //Delivery view
        DeliveryAddresText.text = "Delivery Address:".localized
        DeliveryDateText.text = "Delivery Date".localized
        ChangeAddresButton.setTitle("change".localized, for: .normal)
        
        DateView.layer.cornerRadius = 10
        
        setupDatePicker()
        //Notes view
        self.supportFastDelivery()
        
    }
    
    
    @IBAction func didChoosePaymentMethod(_ sender: UIButton) {
        payWithApple = sender.tag == 3 // 3 equals to apple pay
        
        checkApplePayView.layer.borderColor = payWithApple ? UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR).cgColor : UIColor().HexToColor(hexString: GlobalData.DARKGREY).cgColor
        checkApplePayButton.backgroundColor = payWithApple ? UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR) : .clear
        
        checkPaymentView.layer.borderColor = payWithApple ? UIColor().HexToColor(hexString: GlobalData.DARKGREY).cgColor : UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR).cgColor
        checkPaymentButton.backgroundColor = payWithApple ? .clear : UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        
    }
    
    func setupDatePicker(){
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let currentDay = calendar.component(.day, from: Date())
        
        
        guard let maximumDate = calendar.date(from: DateComponents(year: currentYear  ,month: currentMonth,day: currentDay + 1))?.addingTimeInterval(-1) else {
            fatalError("Couldn't get next year")
        }
        datePicker.minimumDate = maximumDate
        //        print(datePicker.maximumDate ?? "")
        
        datePicker.addTarget(self, action: #selector(dateDidChanged), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        deliveryDateTextField.inputView = datePicker
    }
    
    func processToPayWithApple() {
        
        let ticket = PKPaymentSummaryItem(label: "Sub total ".localized, amount: NSDecimalNumber(string: subTotal))
        let tax = PKPaymentSummaryItem(label: "Delivery ".localized, amount: NSDecimalNumber(string: delivery))
        let total = PKPaymentSummaryItem(label: "Total ".localized, amount: NSDecimalNumber(string: self.total))
        paymentSummaryItems = [ticket, tax, total]
        
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa, .mada]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let paymentRequest = PKPaymentRequest()
            paymentRequest.paymentSummaryItems = paymentSummaryItems
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.currencyCode = "SAR" // 1
            paymentRequest.countryCode = "SA" // 2
            paymentRequest.merchantIdentifier = "merchant.com.ios.togo" // 3
            paymentRequest.shippingType = .delivery
            paymentRequest.supportedNetworks = paymentNetworks // 5
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {
                NetworkManager.sharedInstance.showErrorSnackBar(msg:"unableToMakeApplePayTransaction".localized)
                return
            }
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
        } else {
            NetworkManager.sharedInstance.showErrorSnackBar(msg:"unableToMakeApplePayTransaction".localized)
        }
    }
    //MARK:- Actions
    @IBAction func CheckoutTapped(_ sender: Any) {
        if(checkout){
            if payWithApple {
                processToPayWithApple()
            } else {
                callingCheckoutHttppApi()
            }
        }
        else{
            NetworkManager.sharedInstance.showWarningSnackBar(msg:"please set your address!".localized)
        }
    }
    
    
    @IBAction func ChangeAddressTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let LocationsController = storyBoard.instantiateViewController(withIdentifier: "LocationList") as! LocationViewController
        LocationsController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(LocationsController, animated: true)
    }
    @objc
    func dateDidChanged(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        deliveryDateTextField.text = formatter.string(from: datePicker.date)
    }
    
    //MAR:- Handler
    
    func supportFastDelivery(){
        if(fastDelivery == 1){
            DateView.isHidden = true
            DeliveryDateText.isHidden = true
        }else{
            NotesText.text = "Notes".localized
            DateView.isHidden = false
            DeliveryDateText.isHidden = false
        }
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
                    self.callingCheckoutHttppApi()
                }
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
            }
        }
    }
    
    func callingCheckoutHttppApi(){
        let sessionId = sharedPrefrence.object(forKey:"token") as! String;
        var requstParams = [String:String]()
        requstParams["token"] = sessionId
        // this is for the cod method
        requstParams["payment_method_id"] =  (paymentStatus == PKPaymentAuthorizationStatus.success && payWithApple) ? "3" : "1"
        requstParams["note"] = NotesValue.text
        
        let selectedDate = deliveryDateTextField.text
        if (fastDelivery == 0) {
            if let dateText = selectedDate {
                if (!dateText.isEmpty){
                    requstParams["date"] = dateText
                    checkOut(requstParams: requstParams)
                }else{
                    NetworkManager.sharedInstance.showErrorSnackBar(msg: "deliveryDateMessage".localized)
                }
            }
        }else{
            checkOut(requstParams: requstParams)
        }
        
        
    }
    
    func checkOut(requstParams:[String:String]){
        NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"order/checkout",cuurentView: self){val,responseObject in
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
                    // go to order page
                    NetworkManager.sharedInstance.showSuccessSnackBar(msg:"your order has been placed successfully".localized)
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let orderViewController = storyBoard.instantiateViewController(withIdentifier: "orderDetails") as! OrderDetailsViewController
                    orderViewController.orderId = dict["id"].stringValue
                    orderViewController.modalPresentationStyle = .overFullScreen
                    self.navigationController?.pushViewController(orderViewController, animated: true)
                }
            }
            else{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingCheckoutHttppApi()
            }
        }
    }
    
    func callingLocationHttppApi(){
        let sessionId = sharedPrefrence.object(forKey:"token") as! String;
        var requstParams = [String:String]()
        requstParams["token"] = sessionId
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"location/myLocation",cuurentView: self){val,responseObject in
            if val == 1 {
                self.view.isUserInteractionEnabled = true
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"] != nil{
                    //display the error to the customer
                    if dict["error"] == "authentication required"{
                        self.loginRequest()
                    }
                    else{
                        self.DeliveryAddressValue.text = "Please Set your Address before you continue".localized
                        self.checkout = false
                    }
                    
                }
                else{
                    NetworkManager.sharedInstance.dismissLoader()
                    // get the location
                    self.DeliveryAddressValue.text = dict["location"].stringValue
                    self.checkout = true
                }
                
            }
            else{
                NetworkManager.sharedInstance.dismissLoader()
                self.callingCheckoutHttppApi()
            }
        }
    }
    
}

@available(iOS 13.4, *)
extension CheckOutViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        print("Success")
        paymentStatus = .success
        NetworkManager.sharedInstance.showSuccessSnackBar(msg:"theApplePayTransactionWasComplete".localized)
        callingCheckoutHttppApi()
    }
}
