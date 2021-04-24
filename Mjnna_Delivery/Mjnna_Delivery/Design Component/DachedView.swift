//
//  DachedView.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 05/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class DashedView: UIView{
    
    let borderLayer = CAShapeLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .topLeft, .topRight, .bottomRight, .bottomLeft ], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.layer.addSublayer(borderLayer)
        
    }
    private func setup(){
        borderLayer.lineWidth = 0.5
        borderLayer.strokeColor = UIColor.gray.cgColor
        borderLayer.lineDashPattern = [6, 6]
        borderLayer.fillColor = nil
        borderLayer.frame = self.bounds
        
    }
    
    
}

class DashedTextView: UITextView{
    
    let borderLayer = CAShapeLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .topLeft, .topRight, .bottomRight, .bottomLeft ], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.layer.addSublayer(borderLayer)
        
    }
    private func setup(){
    
        borderLayer.strokeColor = UIColor.gray.cgColor
        borderLayer.lineDashPattern = [6, 6]
        borderLayer.fillColor = nil
        borderLayer.frame = self.bounds
        
    }
    
    
}
