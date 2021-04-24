//
//  ItemListTableViewCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 28/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var qtyValue: UILabel!
    @IBOutlet weak var subTotalValue: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet var optionDataLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        priceLabel.text = NetworkManager.sharedInstance.language(key: "price")+":"
        qtyLabel.text = NetworkManager.sharedInstance.language(key: "qty")
        subTotalLabel.text = NetworkManager.sharedInstance.language(key: "subtotal")+" :"
        optionDataLabel.text = ""
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
