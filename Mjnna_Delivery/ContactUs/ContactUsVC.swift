//
//  ContactUsVC.swift
//  Mjnna_Delivery
//
//  Created by Amr Saleh on 1/8/22.
//  Copyright © 2022 Webkul. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UIFloatLabelTextField!
    
    @IBOutlet weak var mailTextField: UIFloatLabelTextField!
    
    @IBOutlet weak var phoneTextField: UIFloatLabelTextField!
    
    @IBOutlet weak var subjectTextField: UIFloatLabelTextField!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "contactus".localized
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        var errorMessage = NetworkManager.sharedInstance.language(key: "pleasefill")+" "
        var isValid:Int = 1
        
        if nameTextField.text == ""{
            errorMessage+=NetworkManager.sharedInstance.language(key: "name")
            nameTextField.becomeFirstResponder()
            isValid = 0
        }else if mailTextField.text == ""{
            errorMessage+=NetworkManager.sharedInstance.language(key: "email")
            mailTextField.becomeFirstResponder()
            isValid = 0
        } else if phoneTextField.text == "" {
            errorMessage+=NetworkManager.sharedInstance.language(key: "phone")
            phoneTextField.becomeFirstResponder()
            isValid = 0
        } else if subjectTextField.text == "" {
            errorMessage+=NetworkManager.sharedInstance.language(key: "subject")
            subjectTextField.becomeFirstResponder()
            isValid = 0
        }
        
        if isValid == 0{
            NetworkManager.sharedInstance.showWarningSnackBar(msg: errorMessage)
            return
        }
        
        callingHttppApi()
    }
    
    func callingHttppApi() {
        DispatchQueue.main.async{
            self.view.isUserInteractionEnabled = false
            let sessionId = sharedPrefrence.object(forKey:"token")
            var requstParams = [String:String]()
            requstParams["token"] = sessionId as? String
            NetworkManager.sharedInstance.showLoader()
            requstParams["full_name"] = self.nameTextField.text
            requstParams["email"] = self.mailTextField.text
            requstParams["phone"] = self.phoneTextField.text
            requstParams["body"] = self.messageTextView.text
            requstParams["subject"] = self.subjectTextField.text
            
            NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"customer/sendMessage", cuurentView: self){success,responseObject in
                if success == 1 {
                    self.view.isUserInteractionEnabled = true
                    NetworkManager.sharedInstance.dismissLoader()
                    let dict = JSON(responseObject as! NSDictionary)
                    
                    if dict["error"].intValue == 0{
                        NetworkManager.sharedInstance.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.navigationController?.popToRootViewController(animated: true)
                    }else{
                        NetworkManager.sharedInstance.showInfoSnackBar(msg: dict["message"].stringValue)
                    }
                    
                } else if success == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
}
