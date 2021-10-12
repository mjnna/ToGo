//
//  LocalizedUIControllers.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    @IBInspectable var loclizedPlaceHolderText: String  {
        get {
            return placeholder ?? ""
        }
        set {
            placeholder = NSLocalizedString(newValue, comment: "")
        }
    }
}



extension UIButton {
    @IBInspectable var localizedText: String  {
        get {
            return titleLabel?.text ?? ""
        }
        set {
            setTitle(NSLocalizedString(newValue, comment: ""), for: .normal)
        }
    }
    
    @IBInspectable
    var imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }
    
}




extension UILabel {
    @IBInspectable var localizedText: String  {
        get {
            return text ?? ""
        }
        set {
            let comps = newValue.components(separatedBy: ":")
            if comps.isEmpty {
                text = NSLocalizedString(newValue, comment: "")
            }else {
                guard comps.count == 2 else {
                    text = NSLocalizedString(newValue, comment: "")
                    return
                }
                let tableName = comps[0]
                let key = comps[1]
                text = NSLocalizedString(key, tableName: tableName, comment: "")
            }
            
        }
    }
}
