//
//  YallowButton.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 05/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit
class ShadowButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    private func setup(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
      
    }
    func addCorner(with corner: CGFloat) {
        self.layer.cornerRadius = corner
    }
    func addTitle(title:String,fontSize:CGFloat) {
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.foregroundColor:UIColor.white])
        
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
}
