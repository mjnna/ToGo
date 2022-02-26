//
//  SlotsCVC.swift
//  Mjnna_Delivery
//
//  Created by Amr Saleh on 12/5/21.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit

class SlotsCVC: UICollectionViewCell {

    @IBOutlet weak var slotLabel: UILabel!
    @IBOutlet weak var containerDashedView: DashedView!
    
    static let identifier = "SlotsCVC"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(time: String, isSelected: Bool) {
        slotLabel.text = time
        containerDashedView.backgroundColor = isSelected ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : .clear
        slotLabel.textColor = isSelected ?  .white : .black 
    }
}
