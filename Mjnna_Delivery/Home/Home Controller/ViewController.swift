//
/**
 * @author amr obaid
 */

import UIKit
import IQKeyboardManagerSwift

class ViewController: UIViewController,UISearchBarDelegate,CategoryViewControllerHandlerDelegate,bannerViewControllerHandlerDelegate,UITabBarControllerDelegate, UICollectionViewDelegate{
    
    
    
 
    
    //MARK:- Outlet
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var RefreshView: UIVisualEffectView!
    @IBOutlet var refreshingLabel: UILabel!

  
    //MARK:- View component
    
    lazy var menuNavigationButtonItem: UIBarButtonItem = {
        var image = UIImage()
        image = #imageLiteral(resourceName: "ic_hamburg")
        let lang = sharedPrefrence.object(forKey: "language") as! String
        if lang == "ar"{
            var ni = UIBarButtonItem(image: image.flipImage() , style: .plain, target: self, action: #selector(menuPressed))
            ni.tintColor = .black
           
            return ni
        }else{
            var ni = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(menuPressed))
            ni.tintColor = .black
            return ni
        }
    }()
    lazy var settingNavigationButtonItem: UIBarButtonItem = {
        var ni = UIBarButtonItem(image: #imageLiteral(resourceName: "settings (1)") , style: .plain, target: self, action: #selector(settingPressed))
        ni.tintColor = .black
        return ni
    }()
    
    lazy var sideMenuLeftSwiper: UISwipeGestureRecognizer = {
       let sg = UISwipeGestureRecognizer()
        sg.direction = .left
        sg.addTarget(self, action: #selector(handleMenuSwipedLeft))
        return sg
    }()
    lazy var sideMenuRightSwiper: UISwipeGestureRecognizer = {
       let sg = UISwipeGestureRecognizer()
        sg.direction = .right
        sg.addTarget(self, action: #selector(handleMenuSwipedRight))
        return sg
    }()
    
    lazy var sideMenu: SideMenu = {
        let sm = SideMenu()
        sm.menuTableView.backgroundColor = .clear
        sm.menuTableView.separatorStyle = .none
      
        return sm
    }()
    lazy var bullerEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    //MARK: - Properties
    
    var homeViewModel:HomeViewModel!
    var typeId:String = ""
    var typeName:String = ""
    var typeImage:String = ""
    var location:String = ""
    
    var launchView:UIViewController!
    var refreshControl:UIRefreshControl!
    var responseObject : AnyObject!
    var homeData : JSON!
    var dataBaseObject:AllDataCollection!
    var apiCallingType:APICallingType = .NONE
    var isHomeRefreshed:Bool = false
    var whichApiToProcess: String = ""
    
    var leftAnchor: NSLayoutConstraint!
    var rightAnchor: NSLayoutConstraint!
    var sideMenuOpen = false
    var productModel = ProductViewModel()
    var showSubStore:Bool = false


    //MARK:- Init
 
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeTabBar()
        
        searchBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = false
        dataBaseObject = AllDataCollection()
        
        searchBar.delegate = self
        RefreshView.layer.cornerRadius = 10
        RefreshView.layer.masksToBounds = true
        RefreshView.isHidden = true
    
        self.tabBarController?.delegate = self
        
        refreshControl = UIRefreshControl()
    
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            homeTableView.refreshControl = refreshControl
        } else {
            homeTableView.backgroundView = refreshControl
        }
        
        ThemeManager.applyTheme(bar:(self.navigationController?.navigationBar)!)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor().HexToColor(hexString: GlobalData.NAVIGATION_TINTCOLOR)]
        navigationController?.navigationBar.tintColor = UIColor().HexToColor(hexString: GlobalData.NAVIGATION_TINTCOLOR)
        
        
        // IQKeyboard Manager Setting
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "done".localized
        IQKeyboardManager.shared.toolbarTintColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
            self.navigationItem.title = NetworkManager.sharedInstance.language(key: "applicationname")
            searchBar.placeholder = NetworkManager.sharedInstance.language(key: "searchentirestore")
            refreshingLabel.text = "refreshing".localized
        
        self.callingHttppApi()
        let token = sharedPrefrence.object(forKey: "token")
        if(token != nil){
            self.getLocation()
        }
        
        self.setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(subMenuPressed(_:)), name: .subMenu, object: nil)
        setupMainTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateSideMenu(animate: false)
    }
    
    func typeClick(name: String, ID: String, thumbnail: String) {
        typeId = ID
        typeName = name
        typeImage = thumbnail
        self.performSegue(withIdentifier: "sellerCategory", sender: self)
    }
    
    func localizeTabBar() {
        let items = self.tabBarController?.tabBar.items
        items?[0].title = "Home".localized
        items?[1].title = "Stores".localized
        items?[2].title = "Account".localized
    }
    
    func setupMainTableView(){
        homeViewModel  = HomeViewModel()
        self.homeViewModel.homeViewController = self
        
        homeTableView?.register(BannerTableCell.self, forCellReuseIdentifier: "bannercell")
        homeTableView?.register(StoresCategoryCell.self, forCellReuseIdentifier: "cell")

        GlobalVariables.hometableView = homeTableView
        
        self.homeTableView?.dataSource = homeViewModel
        self.homeTableView?.delegate = homeViewModel
        homeTableView.rowHeight = UITableView.automaticDimension
        self.homeTableView.estimatedRowHeight = 100
        self.homeTableView.separatorColor = UIColor.clear
    }
    
    func setupView(){
        navigationItem.leftBarButtonItem = menuNavigationButtonItem
        navigationItem.rightBarButtonItem = settingNavigationButtonItem
        
        view.addGestureRecognizer(sideMenuLeftSwiper)
        view.addGestureRecognizer(sideMenuRightSwiper)
        
        setupSideMenu()
        designNavigationBar()
    }
    
   
    func setupSideMenu(){
        self.view.addSubview(sideMenu)
        sideMenu.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor,  width: self.view.frame.width/1.8)

        rightAnchor = sideMenu.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        leftAnchor = sideMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        
        rightAnchor.isActive = true
        leftAnchor.isActive = false
    }
    func designNavigationBar(){
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(1.0, 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 1.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }
    //MARK:- Actions
    @objc func subMenuPressed(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animateSideMenu(animate: false)
           }
       handleMenu(notification: notification)
    }
    
    func handleMenu(notification:Notification){
        enum customerMenu: Int {
              case discover = 0, myAccount, myOrders, myAddresses, aboutus, contactus,privacy,logout
          }
        enum gestMenu: Int {
              case discover = 0, aboutus, contactus,privacy,login,signup
          }
        var menu: Menu?
        if let castedMenu = notification.object as? Menu {
            menu =  castedMenu
        }
        if menu?.isGuestMenu == false{
            switch customerMenu(rawValue: menu!.menuIndex) {
                case .discover:
                    print("discover")
                case .myAccount:
                    self.tabBarController?.selectedIndex = 2
                case .myAddresses:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "LocationList")
                        self.modalPresentationStyle = .overCurrentContext
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .myOrders:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.performSegue(withIdentifier: "orderhistory", sender: nil)
                    }
                case .aboutus:
                    print("aboutus")
                case .contactus:
                    print("contactus")
                case .privacy:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.performSegue(withIdentifier: "privacy", sender: nil)
                    }
                case .logout:
                    let AC = UIAlertController(title: NetworkManager.sharedInstance.language(key: "message"), message: NetworkManager.sharedInstance.language(key: "logoutmessagewarning"), preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        self.whichApiToProcess = ""
                        self.logoutCustomer()
                        self.sideMenu.loadMenu()
                    })
                    let noBtn = UIAlertAction(title: NetworkManager.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(okBtn)
                    AC.addAction(noBtn)
                    self.present(AC, animated: true, completion: nil)
                default:
                    break
                    
                }
        }else{
            switch gestMenu(rawValue: menu!.menuIndex) {
            case .discover:
                print("discover")
            case .aboutus:
                print("aboutus")
            case .contactus:
                print("contactus")
            case .privacy:
                self.performSegue(withIdentifier: "privacy", sender: nil)
            case .login:
//                self.tabBarController?.selectedIndex = 2
                if let vc = getViewController(storyboard: UIStoryboard(name: "AuthStoryboard", bundle: nil), sceneID: "LoginViewController") as? LoginViewController{
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            break
            case .signup:
                self.tabBarController?.selectedIndex = 2
            default:
                break
            }
        }
    }
    func logoutCustomer(){
        for key in UserDefaults.standard.dictionaryRepresentation().keys {  //guestcheckout
            if(
                key.description == "language" ||
                key.description == "AppleLanguages" ||
                key.description == "currency" ||
                key.description == "guest" ||
                key.description == "touchIdFlag" ||
                key.description == "TouchEmailId" ||
                key.description == "TouchPasswordValue" ||
                key.description == "deviceToken" ||
                key.description == "appstartlan")
            {
                continue
            }else{
                UserDefaults.standard.removeObject(forKey: key.description)
                defaults.removeObject(forKey: "token")
            }
        }
        
        UserDefaults.standard.synchronize()
        NetworkManager.sharedInstance.updateCartShortCut(count:"", succ: false)
        self.productModel.deleteAllRecentViewProductData()
        NetworkManager.sharedInstance.showSuccessSnackBar(msg:NetworkManager.sharedInstance.language(key: "logoutmessage"))
     }
    
    @objc
    func settingPressed(){
        self.performSegue(withIdentifier: "settings", sender: nil)
    }
    @objc
    func menuPressed(){
        sideMenuOpen = !sideMenuOpen
        if sideMenuOpen {
            let indexPath = IndexPath(row: 0, section: 0)
            sideMenu.menuTableView.selectRow(at: indexPath , animated: false, scrollPosition: .none)
            animateSideMenu(animate: true)
        }else{
            animateSideMenu(animate: false)
        }
    }
    @objc
    func handleMenuSwipedLeft(){
        if let language = sharedPrefrence.object(forKey: "language") as? String{
            switch language {
            case "ar":
                animateSideMenu(animate: true)
            case "en":
                animateSideMenu(animate: false)
            default:
                break
            }
        }
    }
    @objc
    func handleMenuSwipedRight(){
        if let language = sharedPrefrence.object(forKey: "language") as? String{
            switch language {
            case "ar":
                animateSideMenu(animate: false)
            case "en":
                animateSideMenu(animate: true)
            default:
                break
            }
        }
    }
    
    
    @IBAction func changeClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "locationList", sender: self)
    }
    
    @objc func goToSearch(_ note: Notification) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc func goToCart(_ note: Notification) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        callingHttppApi()
    }
    //MARK:- Handler
    func animateSideMenu(animate:Bool){
        rightAnchor.isActive = !animate
        leftAnchor.isActive = animate
        sideMenuOpen = animate
        self.autoLayoutIfneeded()
        if animate {
            self.view.addSubview(self.bullerEffectView)
            self.view.bringSubviewToFront(sideMenu)
        }else{
            self.bullerEffectView.removeFromSuperview()
        }
        sideMenu.loadMenu()
    }
    
    func autoLayoutIfneeded(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func loginRequest(){
        var loginRequest = [String:String]();
        let token = sharedPrefrence.object(forKey:"token")
        if(token == nil){
            return
        }
        else{
            loginRequest["token"] = token as? String
        }
        NetworkManager.sharedInstance.callingHttpRequest(params:loginRequest, apiname:"refresh", cuurentView: self){val,responseObject in
            if val == 1{
                let dict = JSON(responseObject as! NSDictionary)
                if dict["error"] != nil{
                    UserDefaults.standard.removeObject(forKey: "token")
                }
                else{
                    sharedPrefrence.set(dict["newToken"].stringValue , forKey: "token")
                    sharedPrefrence.synchronize();
                    self.callingHttppApi()
                }
            }else if val == 2{
                NetworkManager.sharedInstance.dismissLoader()
                self.loginRequest()
            }
        }
    }
    func getLocation(){
        let sessionId = sharedPrefrence.object(forKey:"token") as! String;
            var requstParams = [String:String]()
            requstParams["token"] = sessionId
            
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"location/myLocation",cuurentView: self){val,responseObject in
                if val == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["error"] != nil{
                        self.loginRequest()
                    }
                    else{
                        NetworkManager.sharedInstance.dismissLoader()
                        self.location = dict["location"].stringValue
                        let button =  UIButton(type: .custom)
                        button.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 50, height: 40)
                        button.setTitleColor(.gray, for: .normal)
                        button.setTitle(self.location, for: .normal)
                        button.titleLabel?.font =  UIFont(name: "System", size: 14)
                        //button.addTarget(self, action: #selector(self.changeClick), for: .touchUpInside)
//                        self.navigationItem.titleView = button
                        
                    }                    
                }
                else{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
        }
    }
    func getHomeOfflineData(data:AnyObject){
        if let storeData = data as? JSON{
            self.homeViewModel.getData(data: storeData){(data : Bool) in
                if data {
                    self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                    self.launchView!.view.removeFromSuperview()
                    self.navigationController?.isNavigationBarHidden = false
                    self.tabBarController?.tabBar.isHidden = false
                    if let refreshControl = self.refreshControl{
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
    }
    
   
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        NetworkManager.sharedInstance.removePreviousNetworkCall()
        NetworkManager.sharedInstance.dismissLoader()
        
        if let refreshControl = self.refreshControl{
            refreshControl.endRefreshing()
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabitem: Int = tabBarController.selectedIndex
        let navigation:UINavigationController = tabBarController.viewControllers?[tabitem] as! UINavigationController
        navigation.popToRootViewController(animated: true)
        
        if tabitem != 2{
            let navigation:UINavigationController = tabBarController.viewControllers?[2] as! UINavigationController
            navigation.popToRootViewController(animated: true)
        }
    }
    
    func callingHttppApi(){
        DispatchQueue.main.async{
            var requstParams = [String:Any]()
            if !self.refreshControl.isRefreshing{
                self.RefreshView.isHidden = false
            }
            if let lang = sharedPrefrence.object(forKey: "language") as? String{
                requstParams["lang"] = lang
            }
            NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"common/homepage", cuurentView: self){val,responseObject in
                if val == 1 {
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["error"].stringValue != ""{
                        self.loginRequest()
                    }else{
                        self.homeData = dict
                        if let refreshControl = self.refreshControl{
                            refreshControl.endRefreshing()
                        }
                        
                        self.homeViewModel.getData(data: dict) {
                            (data : Bool) in
                            if data {
                                self.homeTableView.reloadDataWithAutoSizingCellWorkAround()

                                // store the data to data base
                                if let data = NetworkManager.sharedInstance.json(from: responseObject as! NSDictionary){
                                    DBManager.sharedInstance.storeDataToDataBase(data: data, ApiName: "common/homepage", dataBaseObject: self.dataBaseObject)
                                }

                                if sharedPrefrence.object(forKey: "appstartlan") == nil{
                                    sharedPrefrence.set(self.homeViewModel.defaultLanguage, forKey: "language")
                                    sharedPrefrence.set(self.homeViewModel.defaultLanguage, forKey: "appstartlan")
                                    sharedPrefrence.synchronize()
                                    
                                    if self.homeViewModel.defaultLanguage == "ar" {
                                        L102Language.setAppleLAnguageTo(lang: "ar")
                                        if #available(iOS 9.0, *) {
                                            UIView.appearance().semanticContentAttribute = .forceRightToLeft
                                        }
                                    }

                                    
                                }
                                
                                
                                sharedPrefrence.synchronize()
                                self.isHomeRefreshed = true
                                self.RefreshView.isHidden = true
                                
                            }
                            else{
                                
                            }
                        }}
                    
                    
                }else if val == 2{
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                    
                }else if val == 3{
                    self.homeData = (responseObject as! JSON)
                    self.homeViewModel.getData(data: responseObject as! JSON){
                        (data : Bool) in
                        if data {
                            self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                            UIView.animate(withDuration: 1, animations: {
                                self.launchView?.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                                self.launchView?.view.alpha = 0.0;
                            }) { _ in
                                if let Appname = self.launchView.view.viewWithTag(998) as? UILabel{
                                    Appname.stopBlink()
                                }
                                self.launchView!.view.removeFromSuperview()
                                self.navigationController?.isNavigationBarHidden = false
                                self.tabBarController?.tabBar.isHidden = false
                            }
                            sharedPrefrence.synchronize()
                            if let refreshControl = self.refreshControl{
                                refreshControl.endRefreshing()
                            }
                            self.RefreshView.isHidden = true
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.performSegue(withIdentifier: "search", sender: self)
    }
    
    func typeClick(name:String,ID:String,isChild:Bool,thumbnail:String){
        typeId = ID
        typeName = name
        typeImage = thumbnail
        self.performSegue(withIdentifier: "sellerCategory", sender: self)
    }
    
    func bannerProductClick(type:String,image:String,id:String,title:String){
       
    }
      
    //MARK:-
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "sellerCategory") {
            self.view.endEditing(true)
//            let backItem = UIBarButtonItem()
//            backItem.title = typeName
//            navigationItem.backBarButtonItem = backItem
            let viewController:SellerCategoryViewController = segue.destination as UIViewController as! SellerCategoryViewController
            viewController.typeId = typeId
            viewController.typeName = typeName
            viewController.typeImage = typeImage
            viewController.subStoreIsAvailable = true
        }

//        }else if (segue.identifier == "subcategory") {
//            let viewController:subCategory = segue.destination as UIViewController as! subCategory
//            viewController.subName = typeName
//            viewController.subId = typeId
//            viewController.subImage = self.typeImage
//        }
    }
}




extension ViewController{
    func showLanguageOptionWindow(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguageChooseController") as! LanguageChooseController
        popOverVC.modalPresentationStyle = .overFullScreen
        popOverVC.modalTransitionStyle = .crossDissolve
        self.present(popOverVC, animated: true, completion: nil)
    }
    
    
    
    func getCurrentLaunchImage() -> UIImage? {
        
        guard let launchImages = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else { return nil }
        
        let screenSize = UIScreen.main.bounds.size
        
        var interfaceOrientation: String
        switch UIApplication.shared.statusBarOrientation {
        case .portrait,
             .portraitUpsideDown:
            interfaceOrientation = "Portrait"
        default:
            interfaceOrientation = "Landscape"
        }
        
        for launchImage in launchImages {
            
            guard let imageSize = launchImage["UILaunchImageSize"] as? String else { continue }
            let launchImageSize = NSCoder.cgSize(for: imageSize)
            
            guard let launchImageOrientation = launchImage["UILaunchImageOrientation"] as? String else { continue }
            
            if
                launchImageSize.equalTo(screenSize),
                launchImageOrientation == interfaceOrientation,
                let launchImageName = launchImage["UILaunchImageName"] as? String {
                return UIImage(named: launchImageName)
            }
        }
        
        return nil
    }
}


