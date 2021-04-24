//
//  SectionCell.swift
//  OpenCartMpV3
//
//  Created by kunal on 12/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {
    
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var sectionImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
