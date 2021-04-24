

//
//  OrderRejectedViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 1/11/21.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit

class OrderRejectedViewController: UIViewController {

    @IBOutlet weak var OopsImage: UIImageView!
    
    @IBOutlet weak var AppologyText: UILabel!
    
    @IBOutlet weak var StoreResponseText: UILabel!
    
    @IBOutlet weak var StoreResponseValue: UITextView!
    
    var response:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppologyText.text = "Sorry, your order has been rejected by the store".localized
        StoreResponseText.text = "Store Response".localized
        StoreResponseValue.text = response
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
