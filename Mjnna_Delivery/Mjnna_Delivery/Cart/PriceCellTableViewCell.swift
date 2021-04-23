//
//  PriceCellTableViewCell.swift
//  Abdullah
//
//  Created by kunal on 03/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class PriceCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deliveryTitle: UILabel!
    @IBOutlet weak var deliveryValue: UILabel!
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productValue: UILabel!

    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
