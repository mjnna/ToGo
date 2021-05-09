//
//  ListCollectionViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 09/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell{
    //MARK:- compnent
    
    lazy var productImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.anchor(width:110 )
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
       return iv
    }()
    
    lazy var nameLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .black
        let fontSize = screenWidth * 0.04
        lb.font = UIFont.boldSystemFont(ofSize: fontSize)
        lb.anchor(height:20)

        return lb
    }()
    
    lazy var describtionLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .gray
        let fontSize = screenWidth * 0.032
        print(fontSize)
        lb.font = UIFont.boldSystemFont(ofSize: fontSize)
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        lb.anchor(height:15)

        return lb
    }()
    
    lazy var featuredLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .white
        let fontSize = screenWidth * 0.03
        lb.font = UIFont.systemFont(ofSize: fontSize)
        lb.anchor(height:15)
        lb.text = "Featured product".localized
        return lb

    }()
    
    lazy var featuredView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        v.layer.cornerRadius = 4
        v.addSubview(featuredLabel)
        featuredLabel.anchor(top: v.topAnchor, bottom: v.bottomAnchor, left: v.leadingAnchor, right: v.trailingAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 5)
        
        return v
    }()

    lazy var priceLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1)
        let fontSize = screenWidth * 0.032
        lb.font = UIFont.boldSystemFont(ofSize: fontSize)
        lb.anchor(height:20)
        return lb
    }()
    lazy var cartButton:UIButton = {
       let btn = UIButton()
        btn.addTarget(self, action: #selector(addToCartPressed(_:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "Cart"), for: .normal)
        return btn
    }()
    
    lazy var infoView: UIView = {
        let v = UIView()

        v.addSubview(nameLabel)
        nameLabel.anchor(top: v.topAnchor, left: v.leadingAnchor, paddingTop: 15, paddingLeft: 5,height: 20)

        v.addSubview(describtionLabel)
        describtionLabel.anchor(top: nameLabel.bottomAnchor,left: v.leadingAnchor, right: v.trailingAnchor, paddingTop: 10, paddingLeft: 5,paddingRight: 5,height: 15)


        v.addSubview(featuredView)
        featuredView.anchor(top: (describtionLabel).bottomAnchor, left: v.leadingAnchor, paddingTop: 10, paddingLeft: 5,height: 20)
        featuredView.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        v.addSubview(priceLabel)
        priceLabel.anchor(top: v.topAnchor, right: v.trailingAnchor, paddingTop: 15,paddingRight: 5, height: 20)
        
        v.addSubview(cartButton)
        cartButton.anchor(top: describtionLabel.bottomAnchor, right: v.trailingAnchor,paddingTop: 10, width: 25,height: 25)
        return v
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [productImageView,infoView])
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 10
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var mainView:UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.addSubview(mainStackView)
        
        mainStackView.anchor(top: v.topAnchor, bottom: v.bottomAnchor, left: v.leadingAnchor, right: v.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft:10, paddingRight: 10)
        return v
    }()
  
 
    let borderLayer = CAShapeLayer()
    
    var screen:CGRect = CGRect()
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0

    var productId:String = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setup()
    }
    
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setup()
         fatalError("init(coder:) has not been implemented")
     }
     override func layoutSublayers(of layer: CALayer) {
             super.layoutSublayers(of: layer)
             borderLayer.frame = mainView.bounds
             borderLayer.path = UIBezierPath(roundedRect: mainView.bounds, cornerRadius: 10).cgPath
     }

   private func setup(){
    
    self.selectionStyle = .none
    self.contentView.isUserInteractionEnabled = true
    
    screen = UIScreen.main.bounds
    screenWidth = screen.width
    screenHeight = screen.height
    
    addSubview(mainView)
    mainView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 20, paddingRight: 20)
    
    borderLayer.strokeColor = UIColor.gray.cgColor
    borderLayer.lineWidth = 0.5
    borderLayer.lineDashPattern = [6, 6]
    borderLayer.fillColor = nil
    mainView.layer.addSublayer(borderLayer)

    }
    
    func configure(image:String,name:String,describtion:String,price:String,isFeatured:Int,id:String){
        productImageView.loadImage(stringURL: image)
        nameLabel.text = name
        describtionLabel.text = describtion
        let currencyWord = " SAR".localized
        priceLabel.text = price + currencyWord
        productId = id
        if isFeatured == 0 {
            featuredView.isHidden = true
        }else if isFeatured == 1 {
            featuredView.isHidden = false
        }else{
            
        }
        
    }

    @objc func addToCartPressed(_ sender: UIButton) {
        self.addToCart(productId: productId)
    }
    
    func addToCart(productId: String) {
            NetworkManager.sharedInstance.showLoader()
            let sessionId = UserDefaults.standard.object(forKey:"token");
            
                var requstParams = [String:String]()
                print(productId)
                requstParams["product_id"] = productId
                requstParams["token"] = sessionId as? String
                requstParams["quantity"] = "1"
                requstParams["options"] = "{}"
                
                NetworkManager.sharedInstance.callingNewHttpRequest(params:requstParams, apiname:"cart/add", cuurentView: self.parentContainerViewController()!){success,responseObject in
                    if success == 1{
                        let dict = responseObject as! NSDictionary;
                        NetworkManager.sharedInstance.dismissLoader()
                        if dict.object(forKey: "error") != nil{
                            if (dict.object(forKey: "error") as? String == "authentication required"){
                                //self.loginRequest()
                            }
                            else{
                                NetworkManager.sharedInstance.showErrorSnackBar(msg: "You Can't order from more than one store at once".localized)
                            }
                            
                        }else{
                            let dict1 = responseObject as! NSDictionary
                            let dict = JSON(dict1)
                            let data = dict["cart"]["quantity"].stringValue
                            NotificationCenter.default.post(name: .cartBadge, object: data)
                            NetworkManager.sharedInstance.showSuccessSnackBar(msg: "product added to cart successfully".localized)
                        }
                    }else if success == 2{
                        NotificationCenter.default.post(name: .cartBadge, object: "")
                        NetworkManager.sharedInstance.dismissLoader()
                    }
                }
    }
    
}
