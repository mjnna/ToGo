//
//  NameCollectionViewCell.swift
//  Opencart
//
//  Created by kunal on 30/07/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class NameCollectionViewCell: UICollectionViewCell {
@IBOutlet var labelName: UILabel!
@IBOutlet var mainView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 20;
        mainView.layer.masksToBounds = true
        mainView.layer.borderWidth = 0.5
        mainView.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY).cgColor
        labelName.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
    }
    


}
