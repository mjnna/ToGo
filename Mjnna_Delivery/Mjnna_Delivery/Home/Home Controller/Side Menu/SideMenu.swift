//
//  SideMenu.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 09/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation
import UIKit

 struct CellContnet {
    let image: UIImage
    let title: String
}

class SideMenu: UIView {
    
   
    lazy var userName: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 25)
        lb.text = "Obaid Ahmed"
        return lb
    }()
    lazy var userEmail: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "customer@gmail.com"
        return lb
    }()
    lazy var userPhoneNumber: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .left
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "0550000000"
        return lb
    }()
    lazy var userInfoStackView: UIStackView  = {
        let sv = UIStackView(arrangedSubviews: [userName,userEmail,userPhoneNumber])
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.spacing = 5
        sv.axis = .vertical
        return sv
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var twitter: UIButton = {
      let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "twitter"), for: .normal)
        btn.anchor(width:30,height: 30)
        btn.addTarget(self, action: #selector(twitterPressed(_:)), for: .touchUpInside)
        btn.tag = 0
      return btn
    }()
    
    lazy var facebook: UIButton = {
      let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "facebook-1"), for: .normal)
        btn.anchor(width:30,height: 30)
        btn.addTarget(self, action: #selector(facebookPressed(_:)), for: .touchUpInside)
        btn.tag = 1
      return btn
    }()
    lazy var instagram: UIButton = {
      let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "instagram"), for: .normal)
        btn.anchor(width:30,height: 30)
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(instagramPressed(_:)), for: .touchUpInside)
        btn.tag = 2
      return btn
    }()
    
    lazy var socialAccountsStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [instagram,facebook,twitter])
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.spacing = 7
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var versionLabel: UILabel = {
       let lb = UILabel()
        lb.backgroundColor = .clear
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = #colorLiteral(red: 0.6262935996, green: 0.3690022528, blue: 0.004603609908, alpha: 1)
        lb.text = "versoin no. 1".localized
        lb.anchor(height:15)
       return lb
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [socialAccountsStackView,versionLabel])
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 10
        sv.axis = .vertical
        return sv
    }()
    
    var dataSource: [CellContnet]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupDelegates()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addCornerToSideMenu()
    }

    func setup(){
        self.backgroundColor = #colorLiteral(red: 0.997813046, green: 0.7226907611, blue: 0, alpha: 1)
        
        addSubview(userInfoStackView)
        userInfoStackView.anchor(top: self.topAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20, height:70)
        
        
        addSubview(tableView)
        tableView.anchor(top: userInfoStackView.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 25, paddingLeft: 20, paddingRight: 20,height: 50*8)
        
        addSubview(bottomStackView)
        bottomStackView.anchor(top: tableView.bottomAnchor, bottom: self.bottomAnchor, paddingTop: 10, paddingBottom: 30, height: 65)
        
        NSLayoutConstraint.activate([
            bottomStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        setCustomerData()
        loadMenu()
    }
    
    func addCornerToSideMenu(){
        if let language = sharedPrefrence.object(forKey: "language") as? String{
            switch language {
            case "ar":
                self.roundCorners(corners: [.topLeft,.bottomLeft], radius: 30)
            case "en":
                self.roundCorners(corners: [.topRight,.bottomRight], radius: 30)
            default:
                break
            }
           
        }
    }
    
    //MARK: - Actions
    enum socialMediaAccount:Int{case twiter = 0,facebook,instagram}
    @objc
    func twitterPressed(_ sender: UIButton) {
        if let url = URL(string: "https://twitter.com/togoappksa?s=21") {
            UIApplication.shared.open(url)
        }
    }
    @objc
    func facebookPressed(_ sender: UIButton){
         if let url = URL(string: "https://www.facebook.com/Togoappksa/") {
            UIApplication.shared.open(url)
         }
    }
    @objc
    func instagramPressed(_ sender: UIButton){
        if let url = URL(string: "https://instagram.com/togoappksa?igshid=1rov4skc3lf2e") {
            UIApplication.shared.open(url)
        }
    }
    
    //Handler
    func loadMenu(){
        if defaults.object(forKey: "token") != nil{
            dataSource = [CellContnet(image: #imageLiteral(resourceName: "ic_discover"), title: "Discover".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_nav_profile"), title: "My Account".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_order_history"), title: "My Orders".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_addresses_nav"), title: "My Addresses".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_nav_support"), title: "About us".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_nav_support"), title: "Contact us".localized),
                          CellContnet(image: #imageLiteral(resourceName: "privacy"), title: "Privacy&Policy".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_logout"), title: "Logout".localized)
                          ]
        }else{
            dataSource = [CellContnet(image: #imageLiteral(resourceName: "ic_discover"), title: "Discover".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_nav_support"), title: "About us".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_nav_support"), title: "Contact us".localized),
                          CellContnet(image: #imageLiteral(resourceName: "privacy"), title: "Privacy&Policy".localized),
                          CellContnet(image: #imageLiteral(resourceName: "ic_nav_support"), title: "Log in".localized),
                          CellContnet(image: #imageLiteral(resourceName: "privacy"), title: "Register".localized)
                          ]
        }
        tableView.reloadData()
    }
    func setCustomerData(){
        let defaults = UserDefaults.standard
        
        var fullName:String = ""
        if let firtName =  defaults.object(forKey: "first_name".localized) as? String {
            print(fullName)
            fullName.append(firtName)
        }
        
        if let lastName = defaults.object(forKey: "last-name".localized) as? String {
            fullName.append(" ")
            fullName.append(lastName)
            print(lastName)
        }
        
        userName.text = fullName
        
        if let email = defaults.object(forKey: "email") as? String {
            userEmail.text = email
        }
     
        if let phone = defaults.object(forKey: "phone") as? String {
            userPhoneNumber.text = phone
        }
       

    }

}
extension SideMenu:UITableViewDelegate,UITableViewDataSource {
    
    func setupDelegates(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = dataSource?.count {
            return rows
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SideMenuCell
        cell.Label.text = dataSource?[indexPath.row].title
        if let image = dataSource?[indexPath.row].image{
            cell.titleImage.image = image
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object:Menu?

        if defaults.object(forKey: "token") != nil{
          object =  Menu(menuIndex: indexPath.row, isGuestMenu: false)
        }else{
          object =  Menu(menuIndex: indexPath.row, isGuestMenu: true)
        }
        NotificationCenter.default.post(name: .subMenu, object: object)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return 40
    }
    
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}



private class SideMenuCell: UITableViewCell {
    
    //MARK:- Properties
    
    lazy var Label:UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.anchor(height:25)
        return label
    }()
    
    lazy var titleImage: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.anchor(width:25, height:25)
        return iv
    }()
    
    lazy var stackView: UIStackView  = {
        let sv = UIStackView(arrangedSubviews: [titleImage,Label])
        sv.alignment = .trailing
        sv.spacing = 15
        sv.axis = .horizontal
        return sv
    }()
    
    
    //MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.backgroundColor = selected ? .white:.clear
        self.Label.textColor = selected ? .black:.white
        titleImage.image = titleImage.image?.withRenderingMode(.alwaysTemplate)
        titleImage.tintColor = selected ? .black:.white
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup(){
        self.backgroundColor = .clear
        self.layer.cornerRadius = 7
        self.selectionStyle = .none
        addSubview(stackView)
        stackView.anchor( left: self.leadingAnchor, right: self.trailingAnchor, paddingLeft: 10, paddingRight: 10,height: 25)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}



struct Menu{
    let menuIndex:Int
    let isGuestMenu:Bool
}
