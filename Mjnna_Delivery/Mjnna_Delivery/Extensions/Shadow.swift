//
//  shadow.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 18/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit
    
extension UIView {
    func dropShadow(scale: Bool = true,radius:CGFloat,opacity:Float,color:UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

