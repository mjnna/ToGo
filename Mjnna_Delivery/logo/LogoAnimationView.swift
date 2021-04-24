//
//  LogoAnimationView.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 12/13/20.
//  Copyright © 2020 Webkul. All rights reserved.
//
import UIKit
import SwiftyGif

class LogoAnimationView: UIView {
    
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "Iphone 11 Pro Max.gif") else {
            return UIImageView()
        }
        return UIImageView(gifImage: gifImage, loopCount: 1)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
        
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoGifImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoGifImageView.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH).isActive = true
        logoGifImageView.heightAnchor.constraint(equalToConstant: SCREEN_HEIGHT).isActive = true
    }
}
