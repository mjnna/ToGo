//
//  tabBarController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 7/27/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit
import SwiftyGif

class tabBarController: UITabBarController {

    //let logoAnimationView = LogoAnimationView()
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        // change the title text color
        self.tabBar.tintColor = #colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1)
        self.tabBar.unselectedItemTintColor = .black

    }
    

}
extension tabBarController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        //logoAnimationView.isHidden = true
    }
}
