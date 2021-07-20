//
//  CartTableViewCell.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 29/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

protocol UpdateCartHandlerDelegate {
    func updateAPICall(index: Int)
}

import UIKit

class CartTableViewCell: UITableViewCell {

    
    lazy var productName: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 17)
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = .lightGray
        
       return lb
    }()
    
    lazy var deleteButton: UIButton = {
       let btn = UIButton()
        var image = #imageLiteral(resourceName: "remove_circle_black_20pt_2x")
        image = image.withRenderingMode(.alwaysTemplate)
        btn.tintColor = UIColor.gray
        btn.setImage(image, for: .normal)
       return btn
    }()
    
    lazy var priceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor =  #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1)
        lb.font = UIFont.boldSystemFont(ofSize: 17)
       return lb
    }()

    lazy var stepperView :StepperView = {
        let st = StepperView()
        st.minuseButton.addTarget(self, action: #selector(minusePressed(_:)), for: .touchUpInside)
        st.plusButton.addTarget(self, action: #selector(plusPressed(_:)), for: .touchUpInside)
        return st
    }()
    
    lazy var productImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.anchor(width: 100, height:100)
       return iv
    }()
    
    
    
    lazy var infoView: UIView = {
        let v = UIView()
        v.addSubview(deleteButton)
        deleteButton.anchor(top: v.topAnchor, right: v.trailingAnchor, paddingTop: 0, paddingRight: 0, width: 20, height: 20)
        
        v.addSubview(productName)
        productName.anchor(top: v.topAnchor, left: v.leadingAnchor,  paddingTop: 0, paddingLeft: 10,height: 20)
        
        v.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: productName.bottomAnchor, left: v.leadingAnchor,right: v.trailingAnchor, paddingTop: 7,paddingLeft: 10, paddingRight: 10,height: 40)
      
        
        v.addSubview(stepperView)
        stepperView.anchor(bottom: v.bottomAnchor, left: v.leadingAnchor,paddingBottom: 7, paddingLeft: 10,width: 70,height: 15)
        
        v.addSubview(priceLabel)
        priceLabel.anchor(bottom: v.bottomAnchor, right: v.trailingAnchor, paddingBottom: 7, paddingRight: 10, height: 15)
        
        return v
    }()
    
    lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [productImageView,infoView])
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var mainView:UIView = {
       let v = UIView()
        v.addSubview(mainStackView)
        mainStackView.anchor(top: v.topAnchor, bottom: v.bottomAnchor, left: v.leadingAnchor, right: v.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft:10, paddingRight: 10)
       return v
    }()
    
    var myCartViewModel:CartViewModel!
    var delegate:UpdateCartHandlerDelegate!
    let borderLayer = CAShapeLayer()
    var cartProducts: [CartModel]!
    var cartView = MyCart()

    //MARK:- init
    
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
   
    //MARK:- Actions
    @objc func minusePressed(_ sender:UIButton){
        stepperButtons(isEnabled: false)
        if let stringQuantity = stepperView.QuantityLabel.text{
            guard  var quantity = Int(stringQuantity)  else {
                return
            }
                if quantity == 1 {
                    CartApis.shared.updateCartProducts(viewController: cartView, productId: getProductId(index: sender.tag), quantity: "0")
                    stepperButtons(isEnabled: true)
                
                }else{
                    quantity -= 1
                    stepperView.QuantityLabel.text = "\(quantity)"
                    myCartViewModel.setDataToCartModel(data: "\(quantity)", pos: sender.tag)
                    delegate.updateAPICall(index: sender.tag)
                    stepperButtons(isEnabled: true)
                }

        }
    }
    @objc func plusPressed(_ sender:UIButton){
        stepperButtons(isEnabled: false)
        let maxQuantity:Int = 19
        if let stringQuantity = stepperView.QuantityLabel.text{
            guard  var quantity = Int(stringQuantity)  else {
                return
            }
                if quantity < maxQuantity || quantity == maxQuantity {
                    quantity += 1
                    stepperView.QuantityLabel.text = "\(quantity)"
                    myCartViewModel.setDataToCartModel(data: "\(quantity)", pos: sender.tag)
                    delegate.updateAPICall(index: sender.tag)
                    stepperButtons(isEnabled: true)

                }else{
                    //TODO: show user message that he crossed the limit of allawed quatity for item
                    stepperButtons(isEnabled: true)
                }
        
        }
    }
    //MARK:- Handler
    func setup(){
        contentView.isUserInteractionEnabled = true

        self.selectionStyle = .none
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
        borderLayer.strokeColor = UIColor.gray.cgColor
        borderLayer.lineWidth = 0.5
        borderLayer.lineDashPattern = [6, 6]
        borderLayer.fillColor = nil
        mainView.layer.addSublayer(borderLayer)
        
        self.addSubview(mainView)
        self.mainView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 20, paddingRight: 20)
        updateViewsAfterLoclization()

    }
    func updateViewsAfterLoclization(){
        if let language = sharedPrefrence.object(forKey: "language") as? String{
            switch language {
            case "ar":
                priceLabel.textAlignment = .right
                descriptionLabel.textAlignment = .right
            case "en":
                priceLabel.textAlignment = .left
                descriptionLabel.textAlignment = .left

            default:
                break
            }
        }
    }
    func stepperButtons(isEnabled:Bool){
        stepperView.minuseButton.isEnabled = isEnabled
        stepperView.plusButton.isEnabled = isEnabled
    }
    func getProductId(index:Int) -> String{
        let productId:String = cartProducts[index].cartProductId
        return productId
    }


    
    
}
extension UIView {

  func addDashedBorder() {
    let Border = CAShapeLayer()
    Border.strokeColor = UIColor.gray.cgColor
    Border.lineDashPattern = [6, 6]
    Border.fillColor = nil
    Border.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [ .topLeft, .topRight, .bottomRight, .bottomLeft ], cornerRadii: CGSize(width: 10, height: 10)).cgPath
    Border.frame = self.bounds
    self.layer.addSublayer(Border)
    }
    
}
