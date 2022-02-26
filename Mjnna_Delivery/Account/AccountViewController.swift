//
//  AccountViewController.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 03/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var signinupContainerView: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkUserStatus()
        designNavigationBar()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserStatus()
    }
    //MARK:- Handler
    func designNavigationBar(){
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(1.0, 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 1.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }
    func checkUserStatus(){
            if defaults.object(forKey: "token") != nil{
                showView(isGuest: false)
                self.navigationItem.title = "profile".localized
            }else{
                showView(isGuest: true)
                
            }
    }
    func showView(isGuest:Bool) {
        //self.navigationController?.navigationBar.isHidden = isGuest
        profileContainerView.isHidden = isGuest
        signinupContainerView.isHidden = !isGuest
    }
}
