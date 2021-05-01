//
//  SignInUpViewController.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 7/26/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit
import TransitionButton
import GoogleSignIn
import MaterialComponents.MaterialActivityIndicator
import AuthenticationServices
import FBSDKLoginKit


@available(iOS 13.0, *)
class SignInUpViewController: UIViewController ,GIDSignInDelegate,ActionsDelegate{
   
    //MARK:- Properties
    let activityIndicator = MDCActivityIndicator()
    var signinupView = SigninUpView()
    var socialUserToRegister: SocialAccount?

    //MARK:- Init

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false

        GIDSignIn.sharedInstance().delegate = self
        setupView()
       
//        checkFacebookUserAuthticationStatus()
//        self.view.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setupView(){
        self.view.addSubview(self.signinupView)
        signinupView.anchor(top: self.view.topAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, left: self.view.leadingAnchor, right: self.view.trailingAnchor)
    }
    
    @available(iOS 13.0, *)
    private func getSignUpOrInButton() -> ASAuthorizationAppleIDButton {
        if #available(iOS 13.2, *) {
            return ASAuthorizationAppleIDButton(type: .signUp, style: .black)
        } else {
            return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        }
    }
    
    //MARK:- Actions
    func logIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "signin", sender: self)
    }
    
    func signup(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createaccount", sender: self)
    }
    func continuePressed(_ sender: UIButton) {
        self.activityIndicator.isAnimating = true
        if let phone = self.signinupView.phonNumberView.phonTextField.text {
            if phone.count == 10 {
                if let user = socialUserToRegister{
                    let newUser = SocialAccount(firstName: user.firstName,
                                                lastName: user.lastName,
                                                email: user.email,
                                                phoneNumber: phone)
                    self.signInSocialAccount(isRegistration: true, user: newUser)
                }
            }else if (phone.count>10) {
                print(phoneNumberError.toLong.errorMessage)
            }else{
                print(phoneNumberError.toShort.errorMessage)
            }
        }else{
            print(phoneNumberError.notEnterd.errorMessage)
        }
    }
    func cancelPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        signinupView.animtePhoneNumberViewWithKeyBoard(animate: false, viewController: self)
    }
    
  
    //MARK:- apple aithentication

    func signInWithApple(_ sender: UIButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    //MARK:- Google aithentication
    func signInWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.signIn()
        
        //TODO: signOut proccess
//        GIDSignIn.sharedInstance()?.signOut()

       
    }
    //MARK:- Facebook aithentication
    func signInWithFacebook(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in! \(grantedPermissions) \(declinedPermissions)")
                if let token = accessToken{
                    self.getFacebookUserInfo(token: token)
                }
            }
        }
    }
    func getFacebookUserInfo(token:AccessToken){
        let parameters = ["fields": "id, name, first_name, last_name, email"]
        let request =   GraphRequest(graphPath: "me", parameters: parameters)
            request.start(completionHandler: { (connection, result, error) -> Void in
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let data = result as? NSDictionary{
                    let user = SocialAuthenticationsModles.FacebookUser(user: data)
                    print("facebook user: \(user)")
                    let userToRegister = SocialAccount(firstName: user.firstName, lastName: user.lastName, email: user.email, phoneNumber: "")
                    self.checkIsNewUser(user: userToRegister)
                   
                }
            }
        })
    }
    

    //MARK:- Handler
    func checkIsNewUser(user:SocialAccount){
        ApisServices.shared.checkUserAuthenticationStatus(viewController: self, email: user.email) { dicData, error in
            if error.isEmpty {
               if let isAvailable = dicData.object(forKey: "login") as? Bool {
                    if isAvailable {
                        self.signInSocialAccount(isRegistration: false, user: user)
                    }else{
                        let newUser = SocialAccount(firstName: user.firstName, lastName: user.lastName, email: user.email, phoneNumber: "")
                        self.socialUserToRegister = newUser
                        self.view.endEditing(false)
                        self.signinupView.animtePhoneNumberViewWithKeyBoard(animate: true, viewController: self)
                    }
               }
            }else{
                print("error: \(error)")
            }
        }
    }

    func signInSocialAccount(isRegistration:Bool,user:SocialAccount){
        
        ApisServices.shared.signinWithSocialAccounts(isRegisteration: isRegistration, user: user, viewController: self, compleation: { token,error in
            if error.isEmpty{
                print("socialServer token: \(token)")
                self.signinupView.animtePhoneNumberViewWithKeyBoard(animate: false, viewController: self)
                self.activityIndicator.isAnimating = false
                self.tabBarController?.selectedIndex = 2
            }else{
                print("socialServer error: \(error)")
            }
          
        })
    }

    func checkFacebookUserAuthticationStatus(){
      
        if let token = AccessToken.current, !token.isExpired {
        }else{
                       
        }
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        }else{
            let user = SocialAuthenticationsModles.GoogleUser(user: user)
            print("google user: \(user)")
            let userToRegister = SocialAccount(firstName: user.firstName, lastName: user.lastName, email: user.email, phoneNumber: "")
            self.checkIsNewUser(user: userToRegister)
        }
    }
    
}

@available(iOS 13.0, *)
extension SignInUpViewController:ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = SocialAuthenticationsModles.AppleUser(credentials: credentials)
            print("apple user: \((user.id,user.email,user.firstName,user.lastName))")
            let userToRegister = SocialAccount(firstName: user.firstName, lastName: user.lastName, email: user.email, phoneNumber: "")
            self.checkIsNewUser(user: userToRegister)
        default:
            break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("somthing went wrong with apple signin:",error )
    }
    
}

@available(iOS 13.0, *)
extension SignInUpViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}




