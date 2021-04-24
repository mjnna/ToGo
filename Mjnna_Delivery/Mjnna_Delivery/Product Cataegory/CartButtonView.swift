//
//  CartButtonView.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 12/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class CartButton: UIView {
    
    //MARK:- Component
    
    lazy var badgeLabel: UILabel = {
       let lb = UILabel()
        lb.backgroundColor = #colorLiteral(red: 0.7438884377, green: 0, blue: 0.0006261569797, alpha: 1)
        lb.layer.cornerRadius = 12.5
        lb.textColor = .white
        lb.layer.masksToBounds = true
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.isHidden = true
        return lb
    }()
    lazy var cartButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = #colorLiteral(red: 0.997813046, green: 0.7226907611, blue: 0, alpha: 1)
        btn.layer.cornerRadius = 30
        let image = #imageLiteral(resourceName: "ic_cart-1")
        btn.imageEdgeInsets = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        btn.setImage(image, for: .normal)
        //shadow
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btn.layer.shadowOpacity = 0.6
        btn.layer.shadowRadius = 4
        btn.layer.masksToBounds = false
        return btn
    }()
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK:- Handler
    
    func setup() {
        self.addSubview(cartButton)
        cartButton.anchor(top:self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor,right: self.trailingAnchor,paddingTop: 5,paddingBottom: 5,paddingLeft: 5,paddingRight: 5, width: 60, height: 60)
        self.addSubview(badgeLabel)
        badgeLabel.anchor(top:self.topAnchor,right: self.trailingAnchor,paddingTop: 3,paddingRight: 3, width: 25, height: 25)

    }

}

