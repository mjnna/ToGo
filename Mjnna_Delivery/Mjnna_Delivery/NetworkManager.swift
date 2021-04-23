//
//  NetworkManager.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 31/10/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftMessages
import WebKit
import MaterialComponents.MaterialActivityIndicator



var queue = OperationQueue()
var profileImageCache = NSCache<AnyObject, AnyObject>()
let defaults = UserDefaults.standard;
let activityIndicator = MDCActivityIndicator()
var homeAPIRequest = HOST_NAME + "common/getHomepage"



class NetworkManager:NSObject{
    public var languageBundle:Bundle!
    
    class var sharedInstance:NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
        
    }
    
    func callingNewHttpRequest( params: Dictionary<String,String>,
    apiname: String,
    cuurentView: UIViewController,
    requestType: HTTPMethod = .post,
    includeHost: Bool = true,
    taskCallback: @escaping (Int, AnyObject?) -> Void)
    {
        var headers = HTTPHeaders()
        let urlString  = includeHost ? (HOST_NAME + apiname) : (BASE_DOMAIN + apiname)
        var lang = ""
        if(params["lang"] != nil)
        {
            lang = params["lang"]!
            
        }
        if(params["token"] != nil)
        {
            headers = ["Authorization" : "Bearer "+(params["token"]!)+"",
                       "Content-Type": "application/json", "lang": lang]
        }
        AF.request(urlString,method: .post ,parameters:params,encoder: JSONParameterEncoder.default, headers: headers).responseJSON
                  { response in
            
              switch response.result {
              case .success(let resultData):
                  debugPrint(resultData)
                  taskCallback(1,resultData as AnyObject)
                  break
              case .failure(let error):
                guard let data  = response.data else {
                    print("Inrenet connectinon")
                    return
                    
                }
                  let returnData = String(data: data , encoding: .utf8)
                  print("returnData" ,returnData ?? "")
                  print("request URL", response.request ?? "")
                  
                  if !Connectivity.isConnectedToInternet(){
                      NetworkManager.sharedInstance.dismissLoader()
                      cuurentView.view.isUserInteractionEnabled = true
                      DBManager.sharedInstance.getJSONDatafromDatabase(ApiName: apiname, taskCallback: { (val, data) in
                          if val{
                              NetworkManager.sharedInstance.showInfoSnackBar(msg: "youareofflinecurrently".localized)
                              taskCallback(3,data as AnyObject)
                          }else{
                              let AC = UIAlertController(title: "warning".localized, message: error.localizedDescription, preferredStyle: .alert)
                              let okBtn = UIAlertAction(title: "retry".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                  taskCallback(2, "" as AnyObject)
                              })
                              let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                                  if let controller = cuurentView.navigationController{
                                      controller.popViewController(animated: true)
                                  }
                              })
                              AC.addAction(okBtn)
                              AC.addAction(noBtn)
                              cuurentView.present(AC, animated: true, completion: nil)
                          }
                      })
                  }
                  else{
                      let errorCode:Int = error._code;
                      if errorCode != -999 && errorCode != -1005{
                          NetworkManager.sharedInstance.dismissLoader()
                          cuurentView.view.isUserInteractionEnabled = true
                          var message:String = self.getRespectiveName(statusCode: 0)
                          if let statusCode =  response.response?.statusCode{
                              message = self.getRespectiveName(statusCode: statusCode)
                          }
                          let AC = UIAlertController(title: "warning".localized, message: message, preferredStyle: .alert)
                          let okBtn = UIAlertAction(title: "retry".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                              taskCallback(2, "" as AnyObject)
                          })
                          let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                          })
                          AC.addAction(okBtn)
                          AC.addAction(noBtn)
                          cuurentView.present(AC, animated: true, completion: nil)
                      }else if errorCode == -1005{
                          NetworkManager.sharedInstance.dismissLoader()
                          taskCallback(2, "" as AnyObject)
                      }
                  }
                  break;
              }
          }
    }
    
    func callingHttpRequest( params: Dictionary<String,Any>,
                             apiname: String,
                             cuurentView: UIViewController,
                             requestType: HTTPMethod = .get,
                             includeHost: Bool = true,
                             taskCallback: @escaping (Int, AnyObject?) -> Void)  {
        
        var headers = HTTPHeaders()
        let urlString  = includeHost ? (HOST_NAME + apiname) : (BASE_DOMAIN + apiname)
        var lang = ""
        if(params["lang"] != nil)
        {
            lang = params["lang"] as! String
            
        }
        if(params["token"] != nil)
        {
            headers = ["Authorization" : "Bearer "+(params["token"] as! String)+"",
                       "Content-Type": "application/json", "lang": lang]
        }
        else{
            headers = ["Content-Type": "application/json", "lang": lang]
        }
        print("url",urlString)
        print("params", params)
        AF.request(urlString,method: requestType,parameters:params, headers: headers).validate().responseJSON { response in
            
            //MARK: Headers & Cookies
            //            if let headerFields = response.response?.allHeaderFields as? [String: String], let URL = response.response?.url {
            //              print("header ", headerFields)
            //              let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
            //                print("cookies ", cookies)
            //            }
            
            switch response.result {
            case .success(let resultData):
                debugPrint(resultData)
                taskCallback(1,resultData as AnyObject)
                break
            case .failure(let error):
             //Crash
                guard let data = response.data else {return}
                
                let returnData = String(data: data , encoding: .utf8)
                print("returnData" ,returnData ?? "")
                print("request URL", response.request ?? "")
                
                if !Connectivity.isConnectedToInternet(){
                    NetworkManager.sharedInstance.dismissLoader()
                    cuurentView.view.isUserInteractionEnabled = true
                    DBManager.sharedInstance.getJSONDatafromDatabase(ApiName: apiname, taskCallback: { (val, data) in
                        if val{
                            NetworkManager.sharedInstance.showInfoSnackBar(msg: "youareofflinecurrently".localized)
                            taskCallback(3,data as AnyObject)
                        }else{
                            let AC = UIAlertController(title: "warning".localized, message: error.localizedDescription, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "retry".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                taskCallback(2, "" as AnyObject)
                            })
                            let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                                if let controller = cuurentView.navigationController{
                                    controller.popViewController(animated: true)
                                }
                            })
                            AC.addAction(okBtn)
                            AC.addAction(noBtn)
                            cuurentView.present(AC, animated: true, completion: nil)
                        }
                    })
                }
                else{
                    let errorCode:Int = error._code;
                    if errorCode != -999 && errorCode != -1005{
                        NetworkManager.sharedInstance.dismissLoader()
                        cuurentView.view.isUserInteractionEnabled = true
                        var message:String = self.getRespectiveName(statusCode: 0)
                        if let statusCode =  response.response?.statusCode{
                            message = self.getRespectiveName(statusCode: statusCode)
                        }
                        let AC = UIAlertController(title: "warning".localized, message: message, preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: "retry".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            taskCallback(2, "" as AnyObject)
                        })
                        let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        AC.addAction(okBtn)
                        AC.addAction(noBtn)
                        cuurentView.present(AC, animated: true, completion: nil)
                    }else if errorCode == -1005{
                        NetworkManager.sharedInstance.dismissLoader()
                        taskCallback(2, "" as AnyObject)
                    }
                }
                break;
            }
        }
    }
    
    func callingHttpRequestForAutoAddress(params:Dictionary<String,Any>, apiname:String,taskCallback: @escaping (Int,
        AnyObject?) -> Void)  {
        let urlString  = apiname
        print("url",urlString)
        print("params", params)
        
        AF.request(urlString,method: .get , parameters:params).responseJSON { response in
            switch response.result {
            case .success(let resultData):
                //                print(resultData)
                taskCallback(1,resultData as AnyObject)
                break
            case .failure(let error):
                if !Connectivity.isConnectedToInternet(){
                    taskCallback(2, "" as AnyObject)
                }
                else{
                    let returnData = String(data: response.data! , encoding: .utf8)
                    print("errrr",error.localizedDescription ,"cccc", error._code, returnData)
                    taskCallback(3, error._code as AnyObject)
                }
                break;
                
            }
        }
    }
    
   /* func getImageFromUrl(imageUrl:String,imageView:UIImageView){
        let url = imageUrl.removingPercentEncoding
        if let urlString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            let image = profileImageCache.object(forKey: urlString as AnyObject)
            if image != nil{
                imageView.image = image as? UIImage
                imageView.backgroundColor = UIColor.white
            } else{
                if let urlData =  URL(string:urlString){
                    DispatchQueue.global(qos: .background).async {
                        let operation = BlockOperation(block: {
                            let data = try? Data(contentsOf: urlData)
                            if data != nil{
                                if let img = UIImage(data: data!){ OperationQueue.main.addOperation({
                                    imageView.image = img
                                    profileImageCache.setObject(img, forKey: urlString as AnyObject)
                                    imageView.backgroundColor = UIColor.white
                                })

                                }

                            }

                        })
                        queue.addOperation(operation)
                    }
                }

            }
        }

    }*/
    
    func getAppIcon() -> UIImage? {
        if let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary{
            let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? NSDictionary
            let iconFiles = primaryIconsDictionary!["CFBundleIconFiles"] as? NSArray
            if let lastIcon = iconFiles?.lastObject as? String{
                if let icon = UIImage(named: (lastIcon)){
                    return icon
                }
            }
        }else{
            return nil
        }
        return nil
    }
    
    func removePreviousNetworkCall(){
        print("dismisstheconnection")
        let sessionManager = AF
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            
            dataTasks.forEach {
                if $0.currentRequest?.url != URL(string: homeAPIRequest){
                    $0.cancel()
                }
            }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    func getRespectiveName(statusCode:Int?) -> String{
        var message:String = ""
        if statusCode == 404{
            message = "servererror".localized
        }else if statusCode == 500{
            message = "servernotfound".localized
        }else{
            message = "somethingwentwrongpleasetryagain".localized
        }
        return message
    }
    
    func showLoader(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func dismissLoader(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func language(key:String) ->String{
        let languageCode = UserDefaults.standard
        if languageCode.object(forKey: "language") != nil {
            let language = languageCode.object(forKey: "language")
            if let path = Bundle.main.path(forResource: language as! String?, ofType: "lproj") {
                languageBundle = Bundle(path: path)
            }
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }
        else {
            languageCode.set("en", forKey: "language")
            languageCode.synchronize()
            let language = languageCode.string(forKey: "language")!
            var path = Bundle.main.path(forResource: language, ofType: "lproj")!
            if path .isEmpty {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")!
            }
            languageBundle = Bundle(path: path)
        }
        return languageBundle.localizedString(forKey: key, value: "", table: nil)
    }
    
    //MARK:- SnackBar Methods
    func showSuccessSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .cardView)
        info.configureTheme(.success)
        info.button?.isHidden = true
        info.configureContent(title: NetworkManager.sharedInstance.language(key: "success"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar.rawValue)
        infoConfig.duration = .automatic
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showErrorSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.error)
        info.button?.isHidden = true
        info.configureContent(title: NetworkManager.sharedInstance.language(key: "error"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar.rawValue)
        infoConfig.presentationStyle = .top
        infoConfig.dimMode = .gray(interactive: true)
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showWarningSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .cardView)
        info.configureTheme(.warning)
        info.button?.isHidden = true
        info.configureContent(title: NetworkManager.sharedInstance.language(key: "warning"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar.rawValue)
        infoConfig.presentationStyle = .top
        //infoConfig.dimMode = .gray(interactive: true)
        infoConfig.duration = .automatic
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showInfoSnackBar(msg:String){
        let info = MessageView.viewFromNib(layout: .cardView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: NetworkManager.sharedInstance.language(key: "info"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel:UIWindow.Level.statusBar.rawValue)
        infoConfig.presentationStyle = .top
        infoConfig.duration = .automatic
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showSnackBars(msg:String){
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: NetworkManager.sharedInstance.language(key: "info"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar.rawValue)
        infoConfig.presentationStyle = .top
        infoConfig.duration = .forever
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func showStatusLineSuggestionBars(msg:String){
        let info = MessageView.viewFromNib(layout: .statusLine)
        info.configureTheme(.error)
        info.button?.isHidden = true
        info.configureContent(title: NetworkManager.sharedInstance.language(key: "info"), body: msg)
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar.rawValue)
        infoConfig.presentationStyle = .bottom
        infoConfig.duration = .automatic
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    func updateCartShortCut(count:String,succ:Bool){
        
        var shortMessage = ""
        
        if succ{
            shortMessage =  count+" "+"itemsincart".localized
        }else{
            shortMessage = "startshopping".localized
        }
        
        if let shortcutItem = UIApplication.shared.shortcutItems?.filter({ $0.type == AppShortCutKey.cartKey.rawValue }).first {
            if let index:Int = (UIApplication.shared.shortcutItems?.index(of: shortcutItem)){
                let icon1 = UIApplicationShortcutIcon(templateImageName:"ic_cart")
                let item1 = UIApplicationShortcutItem(type: AppShortCutKey.cartKey.rawValue, localizedTitle: "cart".localized, localizedSubtitle: shortMessage, icon: icon1, userInfo: nil)
                var dynamicShortcuts = UIApplication.shared.shortcutItems ?? []
                dynamicShortcuts[index] = item1
                UIApplication.shared.shortcutItems = dynamicShortcuts
            }
        }
        
        if let shortcutItem = UIApplication.shared.shortcutItems?.filter({ $0.type == AppShortCutKey.searchKey.rawValue }).first {
            if let index:Int = (UIApplication.shared.shortcutItems?.index(of: shortcutItem)){
                let icon1 = UIApplicationShortcutIcon(templateImageName:"ic_search")
                let item1 = UIApplicationShortcutItem(type: AppShortCutKey.searchKey.rawValue, localizedTitle: "search".localized, localizedSubtitle: "searchentirestore".localized, icon: icon1, userInfo: nil)
                var dynamicShortcuts = UIApplication.shared.shortcutItems ?? []
                dynamicShortcuts[index] = item1
                UIApplication.shared.shortcutItems = dynamicShortcuts
            }
        }
        
        if let shortcutItem = UIApplication.shared.shortcutItems?.filter({ $0.type == AppShortCutKey.wishlist.rawValue }).first {
            if let index:Int = (UIApplication.shared.shortcutItems?.index(of: shortcutItem)){
                let icon1 = UIApplicationShortcutIcon(templateImageName:"ic_wishlist_fill")
                let item1 = UIApplicationShortcutItem(type: AppShortCutKey.wishlist.rawValue, localizedTitle: "mywishlist".localized, localizedSubtitle: "checkyourwishlist".localized, icon: icon1, userInfo: nil)
                var dynamicShortcuts = UIApplication.shared.shortcutItems ?? []
                dynamicShortcuts[index] = item1
                UIApplication.shared.shortcutItems = dynamicShortcuts
            }
        }
    }
    
    func getBundleID()->String{
        if let data = Bundle.main.bundleIdentifier{
            return data
        }else{
            return "com.siri.ios"
        }
    }
    
    func showErrorMessage(view:UIViewController,message:String){
        let AC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        view.present(AC, animated: true, completion: nil)
    }
    
    func showSuccessMessage(view:UIViewController,message:String){
        let AC = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        view.present(AC, animated: true, completion: nil)
    }
    
    func showSuccessMessageWithBack(view:UIViewController,message:String){
        let AC = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            view.navigationController?.popViewController(animated: true)
        })
        AC.addAction(okBtn)
        view.present(AC, animated: true, completion: nil)
    }
    
    func showErrorMessageWithBack(view:UIViewController,message:String){
        let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "error"), message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            view.navigationController?.popViewController(animated: true)
        })
        AC.addAction(okBtn)
        view.present(AC, animated: true, completion: nil)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func getMimeType(type:String)-> String{
        switch type {
        case "txt":
            return "text/plain";
        case "htm":
            return "text/html";
        case "html":
            return "text/html";
        case "php":
            return "text/html";
        case "css":
            return "text/css";
        case "js":
            return "application/javascript";
        case "json":
            return "application/json";
        case "xml":
            return "application/xml";
        case "swf":
            return "application/x-shockwave-flash";
        case "flv":
            return "video/x-flv";
        case "png":
            return "image/png";
        case "jpe":
            return "image/jpeg";
        case "jpeg":
            return "image/jpeg";
        case "gif":
            return "image/gif";
        case "bmp":
            return "image/bmp";
        case "ico":
            return "image/vnd.microsoft.icon";
        case "tiff":
            return "image/tiff";
        case "tif":
            return "image/tiff";
        case "svg":
            return "image/svg+xml";
        case "svgz":
            return "image/svg+xml";
        case "zip":
            return "application/zip";
        case "rar":
            return "application/x-rar-compressed";
        case "exe":
            return "application/x-msdownload";
        case "msi":
            return "application/x-msdownload";
        case "mp3":
            return "audio/mpeg";
        case "qt":
            return "video/quicktime";
        case "mov":
            return "video/quicktime";
        case "pdf":
            return "application/pdf";
        case "psd":
            return "image/vnd.adobe.photoshop";
        case "ai":
            return "application/postscript";
        case "eps":
            return "application/postscript";
        case "ps":
            return "application/postscript";
        case "doc":
            return "application/msword";
        case "rtf":
            return "application/rtf";
        case "xls":
            return "application/vnd.ms-excel";
        case "ppt":
            return "application/vnd.ms-powerpoint";
        case "odt":
            return "application/vnd.oasis.opendocument.text";
        case "ods":
            return "application/vnd.oasis.opendocument.spreadsheet";
        default:
            return ""
        }
    }
    
//    func ApplyPulseAnimation(parentView:UIView,childView:UIView){
//        let pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:20, position:childView.center)
//        parentView.layer.insertSublayer(pulseEffect, below: childView.layer)
//        pulseEffect.radius = 20
//    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}


//MARK: -  AR related methods
extension NetworkManager{
    /*
    func downloadARFile(filename:String,arUrl:String , taskCallback: @escaping (Bool,
        URL?) -> Void){
        if !self.containsFileInDirectory(imageFileName: filename){
            self.downloadUsingAlmofire(url: URL(string:arUrl)!, fileName: filename) { (value, fileURL) in
                if value{
                    taskCallback(true,fileURL)
                }else{
                    taskCallback(false,fileURL)
                }
            }
        }else{
            let data = self.returnFilePath(imageFileName: filename)
            taskCallback(true,data)
        }
    }
    
    func downloadUsingAlmofire(url: URL, fileName:String,taskCallback: @escaping (Bool,
        URL?) -> Void) {
        let manager = AF
        var documentsURL: URL!
        let destination: DownloadRequest.Destination = { _, _ in
            documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
            return (documentsURL, [.removePreviousFile])
        }
        manager.download(url, to: destination)
            
            .downloadProgress(queue: .main, closure: { (progress) in
            })
            .validate { request, response, destinationURL in
                return
        }
        .responseData { response in
            if let destinationUrl = response.destinationURL {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                let  documentPathUrl = response.destinationURL
                print("Success URL:",documentPathUrl)
                taskCallback(true,response.destinationURL)
            }else{
                taskCallback(false,response.destinationURL)
            }
        }
    }
    */
    func containsFileInDirectory(imageFileName:String)->Bool{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(imageFileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func returnFilePath(imageFileName:String) -> URL?{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(imageFileName) {
            return pathComponent
        }
        return nil
    }
    
    func scaleWebView() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
             "meta.name = 'viewport';" +
             "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
             "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta); "
         
         return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
    }
    
}
