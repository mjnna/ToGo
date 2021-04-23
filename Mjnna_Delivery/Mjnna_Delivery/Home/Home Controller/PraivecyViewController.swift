//
//  PraivecyViewController.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 30/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit
import WebKit
class PrivecyViewController: UIViewController {




    let webView:UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false

    }
    private func setup(){
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        openPrivacy()
    }

    //MARK:- Handler
    func openPrivacy(){
        if let url:URL = URL(string: "https://togoksa.com/home/privacy"){
            let urlRequest: URLRequest = URLRequest(url: url)
            webView.loadRequest(urlRequest)
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
}
