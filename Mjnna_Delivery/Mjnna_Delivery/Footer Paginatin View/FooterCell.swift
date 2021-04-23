//
//  FooterCell.swift
//  MobikulOpencartMp
//
//  Created by kunal on 01/09/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class FooterCell: UITableViewCell {
    
    @IBOutlet var loadingLabel: UILabel!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingLabel.text = "loading".localized;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
