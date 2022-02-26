//
//  LoginViewController.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 13/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButton(_ sender: Any) {
        //CustomerLogin
        let vc = UIStoryboard.init(name: "Account", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomerLogin")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupButton(_ sender: Any) {
        //CustomerSignup
        let vc = UIStoryboard.init(name: "Account", bundle: Bundle.main).instantiateViewController(withIdentifier: "CustomerSignup")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
