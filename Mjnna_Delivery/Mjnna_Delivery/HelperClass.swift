//
//  HelperClass.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 04/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage



let SCREEN_WIDTH = ((UIApplication.shared.statusBarOrientation == .portrait) || (UIApplication.shared.statusBarOrientation == .portraitUpsideDown) ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height)

let SCREEN_HEIGHT = ((UIApplication.shared.statusBarOrientation == .portrait) || (UIApplication.shared.statusBarOrientation == .portraitUpsideDown) ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width)

let sharedPrefrence = UserDefaults.standard;


struct GlobalVariables {
    static var proceedToCheckOut:Bool = false
    static var hometableView:UITableView!
    ////static var billingAddressViewModel:BillingAddressViewModel!
    //static var shippingAddressViewModel:ShippingAddressViewModel!
    static var ExecuteShippingAddress:Bool = false
    static var  CurrentIndex:Int = 1;
    static var CartCount:Int = 0
    static var FilterCategory:String = ""
    
}


extension UIImage {
    func flipImage() -> UIImage{
        let languageCode = UserDefaults.standard
        if (languageCode.string(forKey: "language") == "ar"){
            if #available(iOS 10.0, *){
                let flippedImage = self.withHorizontallyFlippedOrientation()
                return flippedImage
            }
        }else{
            return self
        }
        return self
    }
    
}
extension UILabel{
    func alingment(){
        let languageCode = UserDefaults.standard
        if (languageCode.string(forKey: "language") == "ar") {
            self.textAlignment = .right
        }
        else{
            self.textAlignment = .left
        }
        
    }
}


enum APICallingType {
    case ADDTOCART,ADDTOWISHLIST,REMOVEWISHLIST,NONE
}




extension String {
    
    var localized: String {
        return NetworkManager.sharedInstance.language(key: self)
    }
    
    var localised: String {
        return NetworkManager.sharedInstance.language(key: self)
    }
    
    
}





extension String{
    
    
    func isValid(name:String)->Bool{
        var errorMessage:String = NetworkManager.sharedInstance.language(key: "pleasefill")+" "
        
        if self.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            errorMessage = errorMessage+name
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            return false
        }else  if self.containsEmoji == true{
            errorMessage = errorMessage+"valid".localized+" "+name
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            return false
            
        }else{
            return true
        }
    }
    
    func trimmSpace()->String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines) 
    }
    
    // email Validation
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    
}





extension UIImageView{
    func loadImageFrom(url: String, dominantColor:String = ""){
        
        self.backgroundColor = UIColor().HexToColor(hexString: dominantColor)
        let imageURL = (BASE_DOMAIN + url).removingPercentEncoding
        if let urlString = imageURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            SDImageCache.shared.config.maxDiskSize = 60 * 60 * 24 * 7
            
            self.sd_setImage(with: URL(string: urlString)) { (image, error, cacheType, url) in
                if error != nil{
                    self.image = UIImage(named: "ic_placeholder.png")
                }else{
                    self.backgroundColor = UIColor.white
                }
                
            }
        }
    }
    
    
    
    
    
}






extension UIFloatLabelTextField{
    
    func applyAlingment(){
        let languageCode = UserDefaults.standard
        
        if let lang = languageCode.object(forKey: "language") as? String{
            if lang == "ar" {
                self.textAlignment = .right
            }else{
                self.textAlignment = .left
            }
        }else{
            self.textAlignment = .natural
        }
    }
    
    
    func isValid(name:String)->Bool{
        var errorMessage:String = NetworkManager.sharedInstance.language(key: "pleasefill")+" "
        
        if self.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" == ""{
            errorMessage = errorMessage+name
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            return false
        }else  if self.text?.containsEmoji == true{
            errorMessage = errorMessage+"valid".localized+" "+name
            NetworkManager.sharedInstance.showErrorSnackBar(msg: errorMessage)
            return false
            
        }else{
            return true
        }
    }
    
    
    
    func trimmSpace()->String{
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    
}


extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        
        return value == 8205
    }
}


extension String {
    
    var glyphCount: Int {
        
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        
        return !isEmpty
            && !unicodeScalars.contains(where: {
                !$0.isEmoji
                    && !$0.isZeroWidthJoiner
            })
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map{ String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
}


extension UITextField{
    
    func setPlaceHolderColor(data:String){
        let strNumber: NSString = data.lowercased() as NSString
        let range = (strNumber).range(of: GlobalData.ASTERISK.lowercased())
        let attribute = NSMutableAttributedString.init(string: data)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.attributedPlaceholder = attribute  // NSAttributedString(string: data, attributes: [NSForegroundColorAttributeName : UIColor.black])
    }
    
    func applyTextFieldAlingment(){
        let languageCode = UserDefaults.standard
        
        if let lang = languageCode.object(forKey: "language") as? String{
            if lang == "ar" {
                self.textAlignment = .right
            }else{
                self.textAlignment = .left
            }
        }else{
            self.textAlignment = .natural
        }
    }
    
    
    
}


extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText.lowercased() as NSString
        let range = (strNumber).range(of: changeText.lowercased())
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        self.attributedText = attribute
    }
}





extension UIImageView{
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
}

extension UIButton{
    func applyCorner(){
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
    }
    
}

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.addSublayer(gradient)
    }
    
    func applyGradientToTopView(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func shadowBorder() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    func shadowBorderWithCorner() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
    }
}

extension UITableView {
    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
        
        
    }
}

extension UIColor{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

extension UITextField {
    func bottomBorder(texField : UITextField){
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 49, width: SCREEN_WIDTH, height: 1)
        topBorder.backgroundColor = UIColor.gray.cgColor
        texField.layer.addSublayer(topBorder)
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: texField.frame.height - 1.0, width: SCREEN_WIDTH , height: texField.frame.height - 1.0)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        texField.layer.addSublayer(bottomBorder)
        
    }
    
    func isLanguageLayoutDirectionRightToLeft() -> Bool {
        let languageCode = UserDefaults.standard
        if #available(iOS 9.0, *) {
            if (languageCode.string(forKey: "language") == "ar") {
                return true
            }
            else{
                return false;
            }
            
        } else {
            return false;
        }
    }
    
}


extension UINavigationBar
{
    /// Applies a background gradient with the given colors
    func applyNavigationGradient( colors : [UIColor]) {
        var frameAndStatusBar: CGRect = self.bounds
        frameAndStatusBar.size.height += 20 // add 20 to account for the status bar
        
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage?
    {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension String {
    
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate(capacity: digestLen)
        
        return String(format: hash as String)
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension UIView{
    func myBorder() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        
    }
    
}


extension UIButton{
    
    func applyRoundCorner(){
        self.layer.cornerRadius = self.layer.frame.size.width/2;
        self.layer.masksToBounds = true
        
    }
    
}


extension UILabel{
    
    func applyDarkGrey(){
        self.textColor = UIColor().HexToColor(hexString: GlobalData.DARKGREY)
    }
    
    func applyLightGrey(){
        self.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
    }
    
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UISearchBar {
    
    private var textField: UITextField? {
        return subviews.first?.subviews.flatMap { $0 as? UITextField }.first
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.flatMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.color = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
                    newActivityIndicator.backgroundColor = UIColor.white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}

extension UILabel {
    
    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}
