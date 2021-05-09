//
//  AddLocationPopup.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 21/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class AddLocationPopup:UIView {
    
    lazy var messageLabel:UILabel = {
       let lb = UILabel()
        lb.text = "You don't have any location to continue ordering ,so please add new one".localized
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.lineBreakMode = .byWordWrapping
        return lb
    }()
    lazy var button:ShadowButton = {
       let btn = ShadowButton()
        btn.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        btn.setTitle("Add Location".localized, for: .normal)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        
        addSubview(messageLabel)
        messageLabel.anchor(top: self.topAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 50)
        addSubview(button)
        button.anchor(top: messageLabel.bottomAnchor,bottom:self.bottomAnchor, paddingTop: 20,paddingBottom: 20, width:130,height: 30)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
}
