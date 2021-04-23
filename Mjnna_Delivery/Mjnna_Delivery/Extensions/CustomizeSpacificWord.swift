//
//  ColorSpacificWord.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 06/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

extension UIViewController{
  
    
    func coloringSpacificWrod(fullString:String,colerdWord: String,color: UIColor) -> NSAttributedString{
        let fullString = fullString

        // Choose wwhat you want to be colored.
        let coloredString = colerdWord

        // Get the range of the colored string.
        let rangeOfColoredString = (fullString as NSString).range(of: coloredString)

        // Create the attributedString.
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color],
                                range: rangeOfColoredString)
        return attributedString

    }
    
    func boldSpacificWrod(fullString:String,boldWord: String,fontSize:CGFloat) -> NSAttributedString{
        let fullString = fullString

        // Choose wwhat you want to be colored.
        let boldString = boldWord

        // Get the range of the colored string.
        let rangeOfboldString = (fullString as NSString).range(of: boldString)

        // Create the attributedString.
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)],
                                range: rangeOfboldString)
        return attributedString

    }
    
}

extension UITableViewCell{
  
    
    func coloringSpacificWrod(fullString:String,colerdWord: String,color: UIColor) -> NSAttributedString{
        let fullString = fullString

        // Choose wwhat you want to be colored.
        let coloredString = colerdWord

        // Get the range of the colored string.
        let rangeOfColoredString = (fullString as NSString).range(of: coloredString)

        // Create the attributedString.
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color],
                                range: rangeOfColoredString)
        return attributedString

    }
    
    func boldSpacificWrod(fullString:String,boldWord: String,fontSize:CGFloat) -> NSAttributedString{
        let fullString = fullString

        // Choose wwhat you want to be colored.
        let boldString = boldWord

        // Get the range of the colored string.
        let rangeOfboldString = (fullString as NSString).range(of: boldString)

        // Create the attributedString.
        let attributedString = NSMutableAttributedString(string:fullString)
        attributedString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)],
                                range: rangeOfboldString)
        return attributedString

    }
    
}
