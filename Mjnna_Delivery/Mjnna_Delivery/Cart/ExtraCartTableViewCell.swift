//
//  ExtraCartTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 29/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ExtraCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var applyVoucharCode: UIButton!
    @IBOutlet weak var updateCartButton: UIButton!
    @IBOutlet weak var applyCoupanCodeButton: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet var mainView: UIStackView!
    @IBOutlet weak var estimateShippingandtaxes: UILabel!
    @IBOutlet weak var shippingandTaxButton: UIButton!
    
    
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var applyrewardButton: UIButton!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyVoucharCode.setTitleColor(UIColor.white, for: .normal)
        updateCartButton.setTitleColor(UIColor.white, for: .normal)
        applyCoupanCodeButton.setTitleColor(UIColor.white, for: .normal)
        applyrewardButton.setTitleColor(UIColor.white, for: .normal)
        view1.isHidden = true
        view1.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        view1.layer.cornerRadius = 5;
        //view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY).cgColor
        
        view2.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        view2.layer.cornerRadius = 5;
        //view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY).cgColor
        
        view3.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        view3.layer.cornerRadius = 5;
        //view3.layer.borderWidth = 1
        view3.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY).cgColor
        
        view4.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        view4.layer.cornerRadius = 5;
        //view4.layer.borderWidth = 1
        view4.layer.borderColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY).cgColor
        
        estimateShippingandtaxes.text = "estimateshippingandtax".localized
        applyVoucharCode.setTitle(NetworkManager.sharedInstance.language(key: "applyvoucharcode"), for: .normal)
        updateCartButton.setTitle(NetworkManager.sharedInstance.language(key: "updatecart"), for: .normal)
        applyCoupanCodeButton.setTitle(NetworkManager.sharedInstance.language(key: "entercoupan"), for: .normal)
        estimateShippingandtaxes.textColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        applyrewardButton.setTitle(NetworkManager.sharedInstance.language(key: "applypoints"), for: .normal)
    }
    
    override func layoutSubviews() {
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
