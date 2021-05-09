//
//  QoustomImageView.swift
//  CaseStudy
//
//  Created by Khaled Kutbi on 01/03/1442 AH.
//  Copyright © 1442 LeanScale. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

let imageCashe = NSCache<AnyObject,AnyObject>()

class CustomImageView: UIImageView{
   
    let acvtivityIndecator = UIActivityIndicatorView(style: .gray)

    func loadImage(stringURL: String ){
        
        self.image = nil
        addActivityIndecator()
       
        let imageURL = (BASE_DOMAIN + stringURL).removingPercentEncoding
        if let urlString = imageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            SDImageCache.shared.config.maxDiskSize = 60 * 60 * 24 * 7
            
            self.sd_setImage(with: URL(string: urlString)) { (image, error, cacheType, url) in
                if error != nil{
                    self.image = UIImage(named: "ic_placeholder.png")
                    self.removeActivityIndecator()
                }else{
                    self.backgroundColor = UIColor.white
                    self.removeActivityIndecator()

                }
                
            }
        }
     }
    
    func addActivityIndecator(){
        
        addSubview(acvtivityIndecator)
        acvtivityIndecator.translatesAutoresizingMaskIntoConstraints = false
        acvtivityIndecator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        acvtivityIndecator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        acvtivityIndecator.startAnimating()
    }
    func removeActivityIndecator(){
        acvtivityIndecator.removeFromSuperview()
    }
}
