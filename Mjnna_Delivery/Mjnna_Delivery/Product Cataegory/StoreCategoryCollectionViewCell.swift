//
//  StoreCategoryCollectionViewCell.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 12/17/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit

class StoreCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var CategoryName: UILabel!
    @IBOutlet weak var CategoryImage: UIImageView!
    
    
    static let identifier = "StoreCategoryCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public func configure(with title: String, url: String){
        CategoryName.text = title
        CategoryImage.loadImageFrom(url: url)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        CategoryImage.contentMode = .scaleAspectFit
        CategoryImage.layer.borderColor = UIColor.lightGray.cgColor
        CategoryImage.layer.borderWidth = 0.5
        CategoryImage.layer.cornerRadius = 25
        CategoryImage.layer.masksToBounds = true
        // Initialization code
    }

}
