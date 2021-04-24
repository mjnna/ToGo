//
//  Constraint.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 09/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func anchor (top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil , paddingTop: CGFloat? = 0, paddingBottom: CGFloat? = 0 , paddingLeft: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = 0){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
                topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        if let bottom = bottom {
           if let paddingBottom = paddingBottom{
                self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
  
        if let left = left {
                leadingAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let right = right {
                trailingAnchor.constraint(equalTo: right, constant: -paddingRight!).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true

        }

    }
    
}
