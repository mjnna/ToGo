//
//  QoustomImageView.swift
//  CaseStudy
//
//  Created by Khaled Kutbi on 01/03/1442 AH.
//  Copyright © 1442 LeanScale. All rights reserved.
//

import Foundation
import UIKit

let imageCashe = NSCache<AnyObject,AnyObject>()

class CustomImageView: UIImageView{
   
    var task: URLSessionDataTask!
    let acvtivityIndecator = UIActivityIndicatorView(style: .gray)

    func loadImage(stringURL: String ){
        
        self.image = nil
        addActivityIndecator()
        if let task = task{
        task.cancel()
        }
       
        if let url = URL(string: stringURL){
        if let imagefromCashe = imageCashe.object(forKey: url.absoluteString as AnyObject) as? UIImage{
           image = imagefromCashe
           removeActivityIndecator()
           return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
             guard
                 let data = data ,
                 let newImage = UIImage(data: data)
                 else{
                     print("could't load the image")
                     return
             }
            imageCashe.setObject(newImage, forKey: url.absoluteString as AnyObject)
             DispatchQueue.main.async {
                 self.image = newImage
                 self.removeActivityIndecator()
             }
        }
        task.resume()
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
