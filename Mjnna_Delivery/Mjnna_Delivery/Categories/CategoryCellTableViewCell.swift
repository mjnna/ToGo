//
//  CategoryCellTableViewCell.swift
//  BroPhone
//
//  Created by kunal on 18/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class CategoryCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet var childView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.masksToBounds = true
        
        //let color = [UIColor.white,UIColor.black]
        //childView.applyGradient(colours:color )
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
