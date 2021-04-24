//
//  LocationTableViewCell.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 12/29/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: DashedView!
    @IBOutlet weak var locationDetailsLabel: UILabel!
    
    @IBOutlet weak var viewLocationButton: UIButton!
    
    @IBOutlet weak var checkedImageView: UIImageView!
    static let identifier = "LocationTableViewCell"
    
    var locationId:String = ""
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
       
    public func configure(with details: String, set: Bool){
        locationDetailsLabel.text = details
        if(set == false){
            checkedImageView.isHidden = true
        }
        viewLocationButton.setTitle("View Location".localized, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
