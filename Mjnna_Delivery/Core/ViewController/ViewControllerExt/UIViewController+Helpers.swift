//
//  File.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import MessageUI

extension UIViewController : MFMailComposeViewControllerDelegate {
    
    @IBAction func _backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func bind(textField: UITextField, to behaviorRelay: BehaviorRelay<String>, disposeBag: DisposeBag) {
        behaviorRelay.asObservable()
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        textField.rx.text.unwrap()
            .bind(to: behaviorRelay)
            .disposed(by: disposeBag)
    }
    
    func bind(label: UILabel, to behaviorRelay: BehaviorRelay<String>, disposeBag: DisposeBag) {
        behaviorRelay.asObservable()
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bind(textView: UITextView, to behaviorRelay: BehaviorRelay<String>, disposeBag: DisposeBag) {
        behaviorRelay.asObservable()
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
        textView.rx.text.unwrap()
            .bind(to: behaviorRelay)
            .disposed(by: disposeBag)
    }
    
    func getViewController(storyboard: UIStoryboard, sceneID: String) -> UIViewController{
        let vc = storyboard.instantiateViewController(withIdentifier: sceneID)
        
        return vc
    }
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    func openWhatsapp(number : String){
        let urlWhats = "https://wa.me/966\(number)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    func openUrl(string : String){
        if let urlString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let appURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(appURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL)
                    }
                }
            }
        }
    }
    
    func sendEmail(email : String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            present(mail, animated: true)
        } else {
            self.alert(message: "send_email_Error".localized)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


extension ObservableType {
    
    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     - returns: An observable sequence of non-optional elements
     */
    
    public func unwrap<Result>() -> Observable<Result> where Element == Result? {
        return self.compactMap { $0 }
    }
}


