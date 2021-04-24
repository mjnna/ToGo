//
//  SubMenuCell.swift
//  GlobDeals
//
//  Created by kunal on 22/10/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SubMenuCell: UICollectionViewCell {
    
    
    @IBOutlet var imageData: UIImageView!
    @IBOutlet var titleValue: UILabel!
    @IBOutlet var nameBackgroundView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameBackgroundView.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        mainView.layer.cornerRadius = 5
        mainView.layer.borderColor = UIColor.lightGray.cgColor
        mainView.layer.borderWidth = 0.25
        mainView.layer.masksToBounds = true
        
    }
    
}
