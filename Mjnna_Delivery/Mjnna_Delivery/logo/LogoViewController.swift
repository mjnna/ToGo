//
//  LogoViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 12/13/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit
import SwiftyGif

class LogoViewController: UIViewController {

    @IBOutlet weak var LogoGIF: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do{
            let gif = try UIImage(gifName: "Iphone 11 Pro Max.gif")
            self.LogoGIF.setGifImage(gif, loopCount: 1)
            self.LogoGIF.delegate = self
        }catch {
            print(error)
        }
        // Do any additional setup after loading the view.
    }
 

}

extension LogoViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        let newViewController = self.storyboard!.instantiateViewController(withIdentifier: "rootnav") as! tabBarController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
}

