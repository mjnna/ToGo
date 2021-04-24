//
//  CartShipmentApplyCell.swift
//  DrCrazy
//
//  Created by kunal on 19/07/19.
//  Copyright © 2019 webkul. All rights reserved.
//

import UIKit

class CartShipmentApplyCell: UITableViewCell {
    
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        applyButton.setTitle("apply".localized, for: .normal)
        cancelButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        cancelButton.setTitle("cancel".localized, for: .normal)
    }
    
}
