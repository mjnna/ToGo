//
//  StepperView.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 13/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class StepperView:UIView {
    
    lazy var minuseButton: UIButton = {
       let btn = UIButton()
        let attributedTitle  = NSAttributedString(string: "-", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),NSAttributedString.Key.foregroundColor: UIColor.black])
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.anchor(width:15,height: 15)
        return btn
    }()
    
    lazy var QuantityLabel:UILabel = {
       let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.anchor(width:30,height: 15)
      return lb
    }()
    
    lazy var plusButton: UIButton = {
       let btn = UIButton()
        let attributedTitle  = NSAttributedString(string: "+", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),NSAttributedString.Key.foregroundColor: UIColor.black])
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.anchor(width:15,height: 15)
        return btn
    }()
    
    lazy var stepperStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [minuseButton,QuantityLabel,plusButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 5
        return sv
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        self.addSubview(stepperStackView)
        self.stepperStackView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor)
       
    }
}
