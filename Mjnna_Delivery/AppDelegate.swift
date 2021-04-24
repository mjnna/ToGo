//
//  AppDelegate.swift
//  OpenCartMpV3
//
//  Created by kunal on 11/12/17.
//  Copyright © 2017 kunal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseAnalytics
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import IQKeyboardManagerSwift
//import Siren
import RealmSwift
import Firebase
import UserNotificationsUI
import GoogleSignIn
import FBSDKCoreKit

   

//MARK:- Google Sign in Configration
extension AppDelegate{
    @available(iOS 9.0, *)

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url) || ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }


}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    
    var launchedShortcutItem: UIApplicationShortcutItem?
    let realmCurrentVersion = 1
    var deviceTokenData = ""
    var window: UIWindow?

    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func registerForPushNotifications() {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
                    print("Permission granted: \(granted)")
            }
    }
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Requiered to signin with google
        GIDSignIn.sharedInstance().clientID = SocialAccounts.googleID
        GMSServices.provideAPIKey("AIzaSyASLK-B4S9oeITg6BoOcfywqqZjx7mB6Sg")
        GMSPlacesClient.provideAPIKey("AIzaSyASLK-B4S9oeITg6BoOcfywqqZjx7mB6Sg")
        
        //Requiered to signin with facebook
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )

        IQKeyboardManager.shared.enable = true
    
        self.migration()
        UITabBar.appearance().tintColor =  UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        if #available(iOS 11.0, *) {
            UIImageView.appearance().accessibilityIgnoresInvertColors = true
        }
        
        if let languageCode =  sharedPrefrence.object(forKey: "language") as? String{
        
        if languageCode == "ar" {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
        }
        self.setupAppShortCut(application, launchOptions: launchOptions)
        }
    
        

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: Notification.Name.MessagingRegistrationTokenRefreshed,
                                               object: nil)

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            FirebaseApp.configure()
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        if let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.application(application, didReceiveRemoteNotification: remoteNotif)
            })
        }
        
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
                launchedShortcutItem = shortcutItem
        }

        

        application.registerForRemoteNotifications()
        //FirebaseApp.configure()
        registerForPushNotifications()
        return true
       
    }

    
    
    func setupAppShortCut(_ application: UIApplication,launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        // If a shortcut was launched, display its information and take the appropriate action.
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            launchedShortcutItem = shortcutItem
        }
        
        
        if let shortcutItems = application.shortcutItems, shortcutItems.isEmpty {
            
            
            let icon1 = UIApplicationShortcutIcon(templateImageName:"ic_cart")
            let item1 = UIApplicationShortcutItem(type: AppShortCutKey.cartKey.rawValue, localizedTitle: "cart".localized, localizedSubtitle: "startshopping".localized, icon: icon1, userInfo: nil)
            
            let icon2 = UIApplicationShortcutIcon(templateImageName:"ic_search")
            let item2 = UIApplicationShortcutItem(type: AppShortCutKey.searchKey.rawValue, localizedTitle: "search".localized, localizedSubtitle: "searchentirestore".localized, icon: icon2, userInfo: nil)
            
            
            
            let icon3 = UIApplicationShortcutIcon(templateImageName:"ic_wishlist_fill")
            let item3 = UIApplicationShortcutItem(type: AppShortCutKey.wishlist.rawValue, localizedTitle: "mywishlist".localized, localizedSubtitle: "checkyourwishlist".localized, icon: icon3, userInfo: nil)
            UIApplication.shared.shortcutItems = [item2,item1,item3]
            
        }
        
    }
    
    //MARK:- PUSH
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        if Messaging.messaging().fcmToken != nil {

            Messaging.messaging().subscribe(toTopic: "global")
        }

    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var tokenq = ""

        for i in 0..<deviceToken.count {
            tokenq = tokenq + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }

        Messaging.messaging().apnsToken = deviceToken
        deviceTokenData = tokenq;
        Messaging.messaging().subscribe(toTopic: "global")
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("Hooray! I'm registered!")
        Messaging.messaging().subscribe(toTopic: "global")
    }

    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            deviceTokenData = refreshedToken
            let defaults = UserDefaults.standard;
            defaults.set(refreshedToken, forKey: "deviceToken")

            if defaults.object(forKey:"customer_id") != nil {
                var dict = [String: Any]()
                dict["wk_token"] = defaults.object(forKey:"wk_token")
                dict["ios_device_id"] = refreshedToken
                callingHttpAPI(dict)
            }

            defaults.synchronize()
            Messaging.messaging().subscribe(toTopic: "global")
        }

        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func callingHttpAPI(_ dict: [String:Any]){
         DispatchQueue.main.async{
            NetworkManager.sharedInstance.callingHttpRequest(params:dict, apiname:"customer/registerDeviceToken", cuurentView: UIViewController()){success,responseObject in
                if success == 1 {
                    print("Hello world")
                }
            }
        }
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }

        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    //background Siddhant
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        
        if UIApplication.shared.applicationState == .inactive {// tap
            
            var count:Int = 0
            if defaults.object(forKey: "notificationCount") != nil{
                let stored = (defaults.object(forKey: "notificationCount") as! String)
                count = Int(stored)! - 1
                
                if count > 0    {
                    let data =  String(format: "%d", count as CVarArg)
                    defaults.set(data, forKey: "notificationCount")
                }else{
                    defaults.set("0", forKey: "notificationCount")
                }
            }
            
            if count > 0{
                UIApplication.shared.applicationIconBadgeNumber = count
            }
            
            if userInfo["type"] as! String  == "product"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil, userInfo: userInfo)
            }
            else if userInfo["type"] as! String  == "category"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil, userInfo: userInfo)
            }
            else if userInfo["type"] as! String  == "Custom"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCustomCategoryOnTap"), object: nil, userInfo: userInfo)
            }
            else if userInfo["type"] as! String  == "other"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil, userInfo: userInfo)
            }
            
        }else if UIApplication.shared.applicationState == .background{
            var count:Int = 0;
            if defaults.object(forKey: "notificationCount") != nil{
                let stored = (defaults.object(forKey: "notificationCount") as! String);
                count = Int(stored)! + 1;
                let data =  String(format: "%d", count as CVarArg)
                defaults.set(data, forKey: "notificationCount");
            }else{
                defaults.set("1", forKey: "notificationCount");
                count = 1;
            }
            if count > 0{
                application.applicationIconBadgeNumber = count;
            }
        }
    }
    
    //MARK:-
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        defaults.set("0", forKey: "notificationCount");
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        defaults.set("0", forKey: "notificationCount");
        UIApplication.shared.applicationIconBadgeNumber = 0
            
        launchedShortcutItem = nil
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

struct AppFontName {
    static let regular = REGULARFONT
    static let bold = BOLDFONT
    static let italic = "CourierNewPS-ItalicMT"
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.regular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.bold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.italic
                case "CTFontHeavyUsage":
                    fontName = AppFontName.bold
                    
                default:
                    fontName = AppFontName.regular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            }else {
                self.init(myCoder: aDecoder)
            }
        }else {
            self.init(myCoder: aDecoder)
        }
    }
    
    class func overrideInitialize() {
        if self == UIFont.self {
            let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:)))
            method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)
            
            let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:)))
            method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)
            
            let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:)))
            method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)
            
            let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
            method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
        }
    }
}



// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        var count:Int = 0
        if defaults.object(forKey: "notificationCount") != nil{
            let stored = (defaults.object(forKey: "notificationCount") as! String);
            count = Int(stored)! + 1
            let data =  String(format: "%d", count as CVarArg)
            defaults.set(data, forKey: "notificationCount");
        }else{
            defaults.set("1", forKey: "notificationCount");
            count = 1
        }
        if count > 0{
            UIApplication.shared.applicationIconBadgeNumber = count
        }

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler(UNNotificationPresentationOptions.alert)
    }

    // Foreground Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo


        // Print full message.
        print("tap on on forground app",userInfo)

        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            (topController as! UITabBarController).selectedIndex = 0
            let navigation:UINavigationController = (topController as! UITabBarController).viewControllers?[0] as! UINavigationController
            navigation.popToRootViewController(animated: true)

            // topController should now be your topmost view controller
        }


        var count:Int = 0
        if defaults.object(forKey: "notificationCount") != nil{
            let stored = (defaults.object(forKey: "notificationCount") as! String)
            count = Int(stored)! - 1

            if count > 0    {
                let data =  String(format: "%d", count as CVarArg)
                defaults.set(data, forKey: "notificationCount")
            }else{
                defaults.set("0", forKey: "notificationCount")
            }
        }

        if count > 0{
            UIApplication.shared.applicationIconBadgeNumber = count
        }


        if userInfo["type"] as! String  == "product"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil, userInfo: userInfo)
        }
        else if userInfo["type"] as! String  == "category"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil, userInfo: userInfo)
        }
        else if userInfo["type"] as! String  == "Custom"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCustomCategoryOnTap"), object: nil, userInfo: userInfo)
        }
        else if userInfo["type"] as! String  == "other"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil, userInfo: userInfo)
        }

        completionHandler()
    }

//    func switchViewControllers() {
//        // switch root view controllers
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let nav = storyboard.instantiateViewController(withIdentifier: "rootnav")
//
//        self.window?.rootViewController = nav
//    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Messaging.messaging().subscribe(toTopic: "global")
        Messaging.messaging().shouldEstablishDirectChannel = true
        connectToFcm()
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}




extension AppDelegate{
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
        
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
       
        
        switch shortCutType {
        case AppShortCutKey.searchKey.rawValue:
            handled = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shortcutsearchtap"), object: nil, userInfo: nil)
            break
            
        case AppShortCutKey.cartKey.rawValue:
            handled = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shortcutcarttap"), object: nil, userInfo: nil)
            break
            
        case AppShortCutKey.wishlist.rawValue:
            handled = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "shortcutwishlisttap"), object: nil, userInfo: nil)
            break
            
        default:
            break
        }
        
        
        return handled
    }
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        completionHandler(handledShortCutItem)
    }
    
}


enum AppShortCutKey:String{
    case cartKey = "cartselection"
    case searchKey = "searchselection"
    case wishlist = "wishlistselection"
}



extension AppDelegate{
    
    func migration(){
        
        var config = Realm.Configuration(
            
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            
            schemaVersion: UInt64(realmCurrentVersion),
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            
            migrationBlock: { migration, oldSchemaVersion in
                
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                
                if (oldSchemaVersion < self.realmCurrentVersion ) {
                    
                    //                    migration.enumerateObjects(ofType: AllDataCollection.className()) { oldObject, newObject in
                    //
                    //                    }
                    
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
    }
}









// for Siri Shortcut
//
//extension AppDelegate{
//    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
//        if userActivityType == kNewArticleActivityType {
//            return true
//        }
//         return false
//    }
//    
//    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if userActivity.activityType == kNewArticleActivityType {
//            handleUserActivity()
//            return true
//        }
//        
//        return false
//    }
//    
//    private func handleUserActivity() {
//         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sirishortcutforcart"), object: nil, userInfo: nil)
//    }
//    
//    
//    
//    
//}

