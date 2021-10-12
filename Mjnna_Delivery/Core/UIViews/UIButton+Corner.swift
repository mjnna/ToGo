//
//  UIButton+Corner.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    
    @IBInspectable
    var CornerRadius: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var masksToBounds: Bool{
        get{
            return layer.masksToBounds
        }
        set{
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat{
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable
    var borderColor: UIColor?{
        get{
            if let color = layer.borderColor{
                return UIColor(cgColor: color)
            }
            return nil
        }
        set{
            if let color = newValue{
                layer.borderColor = color.cgColor
            }else{
                layer.borderColor = nil
            }
        }
    }

}
