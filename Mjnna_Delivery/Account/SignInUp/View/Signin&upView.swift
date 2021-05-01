//
//  Signin&upView.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 16/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit
import AuthenticationServices
import FBSDKLoginKit

@objc
protocol ActionsDelegate: class{
    func logIn(_ sender:UIButton)
    func signup(_ sender:UIButton)
    func signInWithApple(_ sender: UIButton)
    func signInWithGoogle(_ sender: UIButton)
    func signInWithFacebook(_ sender: UIButton)
    func continuePressed(_ sender:UIButton)
    func cancelPressed(_ sender:UIButton)
}
@available(iOS 13.0, *)
class SigninUpView: UIView{
    
    //MARK:- Compnent
    
    lazy var toGoView: UIView = {
        let view = UIView()
        view.anchor(height:170)
        view.addSubview(ToGoImageView)
        
        NSLayoutConstraint.activate([
            ToGoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ToGoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    lazy var ToGoImageView: UIImageView = {
        let iv = UIImageView()
        iv.anchor(width:150, height:150)
        iv.image = #imageLiteral(resourceName: "logo2")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var loginButton: UIButton = {
       let bt = UIButton()
        bt.anchor(height:45)
        bt.layer.cornerRadius = 22
        bt.backgroundColor = #colorLiteral(red: 0.9142650962, green: 0.7360221744, blue: 0, alpha: 1)
        bt.setTitle("LOG IN".localized, for: .normal)
        bt.addTarget(delegate, action: #selector(delegate.logIn(_:)), for: .touchUpInside)
       return bt
    }()
    lazy var SignupButton: UIButton = {
       let bt = UIButton()
        bt.anchor(height:45)
        bt.layer.cornerRadius = 22
        bt.backgroundColor = #colorLiteral(red: 0.1728341281, green: 0.2500136793, blue: 0.4368206263, alpha: 1)
        bt.setTitle("SIGN UP".localized, for: .normal)
        bt.addTarget(delegate, action: #selector(delegate.signup(_:)), for: .touchUpInside)
       return bt
    }()
 
    lazy var authenticationStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [SignupButton,loginButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 20
        return sv
    }()
    
    lazy var topStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [toGoView,authenticationStackView])
        sv.anchor( height: 300)
         sv.axis = .vertical
         sv.distribution = .fill
         sv.alignment = .fill
         sv.spacing = 20
         return sv
    }()
    lazy var label: UILabel = {
        let lb = UILabel()
        lb.text = "Or Log in with".localized
        lb.textColor = .gray
        lb.textAlignment = .center
        lb.anchor(height:40)
        return lb
    }()
    
    let appleButton = ASAuthorizationAppleIDButton()
    
    lazy var googleButton: UIButton = {
        let bt = UIButton()
        bt.anchor(height:40)
        bt.layer.cornerRadius = 20
        bt.backgroundColor = #colorLiteral(red: 0.8217146397, green: 0.1986177862, blue: 0.1534022689, alpha: 1)
        let myNormalAttributedTitle = NSAttributedString(string: "Sign in with Google".localized,
                                                         attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13),
                                                                      NSAttributedString.Key.foregroundColor:UIColor.white])
        bt.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        let image = #imageLiteral(resourceName: "G+")
        image.withRenderingMode(.alwaysOriginal)
        var spacing:CGFloat  = 0
        if let lang = sharedPrefrence.object(forKey: "language") as? String{
            if lang  == "ar" {
                spacing = -2
            }else{
                spacing = 2
            }
        }
        // the amount of spacing to appear between image and title
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        bt.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        bt.setImage(image, for: .normal)
        bt.addTarget(delegate, action: #selector(delegate.signInWithGoogle(_:)), for: .touchUpInside)

        return bt
    }()
    
    lazy var facebookButton: UIButton = {
        let bt = UIButton()
        bt.anchor(height:40)
        bt.layer.cornerRadius = 20
        bt.backgroundColor = #colorLiteral(red: 0.1672161222, green: 0.3455397785, blue: 0.6358581185, alpha: 1)
        let myNormalAttributedTitle = NSAttributedString(string: "Sign in with Facebook".localized,
                                                         attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13),
                                                                      NSAttributedString.Key.foregroundColor:UIColor.white])
        bt.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        let image = #imageLiteral(resourceName: "facebook")
        var spacing:CGFloat  = 0
        if let lang = sharedPrefrence.object(forKey: "language") as? String{
            if lang  == "ar" {
                spacing = -2
            }else{
                spacing = 2
            }
        } // the amount of spacing to appear between image and title
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        bt.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        image.withRenderingMode(.alwaysOriginal)
        bt.setImage(image, for: .normal)
        bt.addTarget(delegate, action: #selector(delegate.signInWithFacebook(_:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var socialAccountButtonsStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [label,appleButton,googleButton,facebookButton])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 15
        return sv
    }()

    lazy var socialAccountsView: UIView = {
        let view = UIView()
        view.anchor(height:225)

        view.addSubview(socialAccountButtonsStackView)
        socialAccountButtonsStackView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left: view.leadingAnchor, right: view.trailingAnchor,paddingTop: 10, paddingBottom: 10, paddingLeft: 20,paddingRight: 20)
       
        return view
    }()

    lazy var  mainView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [topStackView,socialAccountsView])
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }()
    
    lazy var phonNumberView:PhoneNumberView = {
        let v = PhoneNumberView()
        v.cancelButton.addTarget(delegate, action: #selector(delegate.cancelPressed(_:)), for: .touchUpInside)
        v.continueButton.addTarget(delegate, action: #selector(delegate.continuePressed(_:)), for: .touchUpInside)
        return v
    }()
    
    var delegate:ActionsDelegate!
    var topAnchorr: NSLayoutConstraint?
    var bottomAnchorr: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(){
        self.backgroundColor = .clear
        appleButton.anchor(height: 40)
        appleButton.cornerRadius = 20
        appleButton.addTarget(delegate, action: #selector(delegate.signInWithApple(_:)), for: .touchUpInside)
        //        appleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 180)
//        appleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        
        
        addSubview(mainView)
        mainView.anchor( left: self.leadingAnchor, right: self.trailingAnchor,paddingLeft: 20,paddingRight: 20,height: 525)
    
        
        NSLayoutConstraint.activate([
            mainView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.addSubview(phonNumberView)
        self.phonNumberView.anchor(left: self.leadingAnchor, right: self.trailingAnchor, paddingLeft: 1, paddingRight: 1, width: self.frame.width,height: 400 )
        
        topAnchorr = phonNumberView.topAnchor.constraint(equalTo: self.bottomAnchor)
        topAnchorr?.isActive = true

        bottomAnchorr = phonNumberView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: 0)
        bottomAnchorr?.isActive = false
       
    }
 
    func animtePhoneNumberViewWithKeyBoard(animate:Bool,viewController:UIViewController){
        if animate {
            phonNumberView.phonTextField.becomeFirstResponder()
        }
        bottomAnchorr?.isActive = animate
        topAnchorr?.isActive = !animate
        self.autoLayoutIfneeded()
    }
    
    
    func autoLayoutIfneeded(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
}
