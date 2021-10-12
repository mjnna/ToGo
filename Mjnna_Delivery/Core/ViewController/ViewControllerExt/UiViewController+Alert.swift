//
//  UiViewController+Alert.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
import UIKit



extension UIViewController {
    
    func alert(message: String, title: String = "", buttonMessage: String? = "OK".localized) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: buttonMessage, style: .default, handler: nil)
        alertController.addAction(OKAction)
        if viewIfLoaded?.window != nil {
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func alert(_ title: String, message: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString( "OK".localized , comment: ""), style: .default) { (action) in
            completion?()
        }
        alertController.addAction(action)
        if viewIfLoaded?.window != nil {
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func add(asChildViewController viewController: UIViewController, contianerView:UIView) {
        addChild(viewController)
        contianerView.addSubview(viewController.view)
        viewController.view.frame = contianerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
//    func startLoading() {
//        let iprogress: iProgressHUD = iProgressHUD()
//        iprogress.isShowModal = true
//        iprogress.isShowCaption = false
//        iprogress.isTouchDismiss = false
//        if iprogress.isShowing() {
//            return
//        }
//        iprogress.attachProgress(toViews: view)
//        view.showProgress()
//    }
//
//    func stopLoading() {
//        view.dismissProgress()
//    }
    
}

