//
//  NotificationTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 04/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var contentsText: UILabel!
    @IBOutlet var notificationImage: UIImageView!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var imageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10;
        mainView.layer.masksToBounds = true
        imageHeight.constant = SCREEN_WIDTH/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
