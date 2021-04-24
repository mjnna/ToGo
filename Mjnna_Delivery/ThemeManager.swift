//
//  ThemeManager.swift
//  MobikulMagento-2
//
//  Created by kunal on 22/06/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
import SwiftMessages


class PassthroughWindow: UIWindow {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}



class ThemeManager{
    
  static  func applyTheme(bar:UINavigationBar){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().HexToColor(hexString: GlobalData.NAVIGATION_TINTCOLOR),NSAttributedString.Key.font: UIFont(name: BOLDFONT, size: 15)!]
        UINavigationBar.appearance().tintColor = UIColor().HexToColor(hexString: GlobalData.NAVIGATION_TINTCOLOR)
        var frameAndStatusBar: CGRect = bar.bounds
        frameAndStatusBar.size.height += 20
        UINavigationBar.appearance().setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: GlobalData.GRADIENTCOLOR), for: .default)
        UITabBar.appearance().barStyle = .default
        UISwitch.appearance().onTintColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR).withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        UITabBar.appearance().tintColor =  UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        activityIndicator.radius = 15
        activityIndicator.center = CGPoint(x: UIScreen.main.bounds.midX,y: UIScreen.main.bounds.midY);
        UIApplication.shared.keyWindow?.addSubview(activityIndicator)
        UIApplication.shared.keyWindow?.bringSubviewToFront(activityIndicator)
    
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.addSubview(activityIndicator)
        
    
        activityIndicator.cycleColors = [UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR), UIColor().HexToColor(hexString: GlobalData.ACCENT_COLOR)]
        activityIndicator.strokeWidth = 3
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).textColor = UIColor.white
        UITextField.appearance().tintColor = UIColor.black
        UIBarButtonItem.appearance().setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: REGULARFONT, size: 15)!,NSAttributedString.Key.foregroundColor: UIColor().HexToColor(hexString: GlobalData.NAVIGATION_TINTCOLOR)], for: .normal)
    
    }

}

enum GlobalData {
    static var ASTERISK = " ⃰"
    static var REDCOLOR = "FF4848"
    static var GOLDCOLOR = "FFB800"
    static var BLUECOLOR = "00BFFF"
    static var ORANGECOLOR = "FF9C05"
    static var EXTRALIGHTGREY = "ECEFF1"
    static var LIGHTGREY = "8E8E93";
    static var DARKGREY = "A0A0A0"
    static var ACCENT_COLOR = "000000";
    static var BUTTON_COLOR = "000000";
    static var TEXTHEADING_COLOR = "000000";
    static var NAVIGATION_TINTCOLOR = "000000"
    static var LINK_COLOR = "000000"
    static var SHOW_COMPARE = false;
    static var GREEN_COLOR = "05C149"
    static var STAR_COLOR = "dc831a"
    static var GRADIENTCOLOR = [UIColor.white]
    static var STARGRADIENT = [UIColor().HexToColor(hexString: "FFDF00") , UIColor().HexToColor(hexString: "D4AF37")]
    static var WIDTH = String(format:"%.0f", SCREEN_WIDTH * UIScreen.main.scale)
}

public var BOLDFONT = "AvenirNext-DemiBold";
public var REGULARFONT = "AvenirNext-Regular";
public var BOLDFONTMEDIUM = "AvenirNext-Medium";


public var ASTERISK = " ⃰"
public var REDCOLOR = "FF4848"
public var ORANGECOLOR = "FF9C05"
public var EXTRALIGHTGREY = "ECEFF1"
public var LIGHTGREY = "8E8E93";
public var DARKGREY = "A0A0A0"
public var ACCENT_COLOR = "000000";
public var BUTTON_COLOR = "000000";
public var TEXTHEADING_COLOR = "000000";
public var NAVIGATION_TINTCOLOR = "000000"
public var LINK_COLOR = "000000"
public var SHOW_COMPARE = false;
public var GREEN_COLOR = "05C149"
public var STAR_COLOR = "dc831a"
public var GRADIENTCOLOR = [UIColor.white]
public var STARGRADIENT = [UIColor().HexToColor(hexString: "93BC4B") , UIColor().HexToColor(hexString: "9ED836")]
public var WIDTH = String(format:"%.0f", SCREEN_WIDTH * UIScreen.main.scale)







