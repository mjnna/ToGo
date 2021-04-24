//
//  SuggestedPrductCollectionCell.swift
//  Opencart
//
//  Created by kunal on 30/07/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SuggestedPrductCollectionCell: UICollectionViewCell {

    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var specialPrice: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        specialPrice.textColor = UIColor.lightGray
    }

}
