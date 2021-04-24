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
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
       return lb
    }()
    
    lazy var deleteButton: UIButton = {
       let btn = UIButton()
        let image = #imageLiteral(resourceName: "remove_circle_black_20pt_2x")
        btn.setImage(image, for: .normal)
       return btn
    }()
    
    lazy var priceLabel: UILabel = {
        let lb = UILabel()
        lb.textColor =  #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1)
        lb.font = UIFont.boldSystemFont(ofSize: 12)
       return lb
    }()
 
    lazy var quantityTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.text = NetworkManager.sharedInstance.language(key: "Quantity:")
        lb.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
       return lb
    }()
 
    lazy var quantityValueTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.anchor(width:30,height: 20)
        tf.font = UIFont.systemFont(ofSize: 12)
        tf.textAlignment = .center
       return tf
    }()
    
    lazy var quantityStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [quantityTitleLabel,quantityValueTextField])
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 2
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var quantityIndcator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.anchor(width: 15, height:15)
        return av
    }()
    
    lazy var viewIndcator: UIView = {
       let v = UIView()
        v.anchor(width:15,height:15)
        v.addSubview(quantityIndcator)
        NSLayoutConstraint.activate([
            quantityIndcator.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            quantityIndcator.centerXAnchor.constraint(equalTo: v.centerXAnchor)
        ])
        return v
    }()
    
    lazy var quantityStepper: UIStepper = {
        var s =  UIStepper ()
//        if let language = sharedPrefrence.object(forKey: "language") as? String{
//            switch language {
//            case "ar":
//                let x = (self.frame.width/2) - 10
//                s =  UIStepper(frame: CGRect(x: x, y: 72
//                                               , width: 0, height: 0))
//            case "en":
//                s =  UIStepper(frame: CGRect(x: 10, y: 72
//                                           , width: 0, height: 0))
//            default:
//                break
//            }
//        }
        s.wraps = true
        s.autorepeat = true
        s.maximumValue = 30
        s.addTarget(self, action: #selector(stepperClicked(_:)), for: .valueChanged)
        s.tintColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        return s
    }()
    
    lazy var quantityIndcatorStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [quantityStackView,viewIndcator])
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 6
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var stepperView: UIView = {
        let v = UIView()
        v.backgroundColor = .cyan
        v.addSubview(quantityStepper)
        quantityStepper.anchor(top: v.bottomAnchor,bottom: v.bottomAnchor, left: v.leadingAnchor, right: v.trailingAnchor, paddingTop: 5,paddingBottom: 5, paddingLeft: 0)
        return v
    }()
    
    lazy var subTotalLabel: UILabel = {
       let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)

       return lb
    }()

    lazy var productImageView: UIImageView = {
       let iv = UIImageView()
        iv.anchor(width: 100, height:100)
       return iv
    }()
    
    lazy var infoView: UIView = {
        let v = UIView()
        v.addSubview(deleteButton)
        deleteButton.anchor(top: v.topAnchor, right: v.trailingAnchor, paddingTop: 0, paddingRight: 0, width: 20, height: 20)
        
        v.addSubview(productName)
        productName.anchor(top: v.topAnchor, left: v.leadingAnchor,  paddingTop: 7, paddingLeft: 10,height: 20)
        
        v.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: productName.bottomAnchor, left: v.leadingAnchor, paddingTop: 7, paddingLeft: 10,height: 30)

        v.addSubview(quantityIndcatorStackView)
        quantityIndcatorStackView.anchor( top:descriptionLabel.bottomAnchor,left: v.leadingAnchor,paddingTop: 7, paddingLeft: 10,width:105, height: 15)

        v.addSubview(subTotalLabel)
        subTotalLabel.anchor(top:quantityIndcatorStackView.bottomAnchor,bottom: v.bottomAnchor, left: v.leadingAnchor,paddingTop: 7,paddingBottom: 7, paddingLeft: 10, width: 140,height: 15)
        
        v.addSubview(priceLabel)
        priceLabel.anchor(bottom: v.bottomAnchor, right: v.trailingAnchor, paddingBottom: 7, paddingRight: 10, height: 15)
        
//        v.addSubview(quantityStepper)
//        NSLayoutConstraint.activate([
//            quantityStepper.centerYAnchor.constraint(equalTo: v.centerYAnchor),
//            quantityStepper.centerXAnchor.constraint(equalTo: v.centerXAnchor)
//        ])
        
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
                let x = (self.frame.width/2) - 10
                quantityStepper =  UIStepper(frame: CGRect(x: x, y: 72
                                               , width: 0, height: 0))
                priceLabel.textAlignment = .right
                subTotalLabel.textAlignment = .right
            case "en":
                quantityStepper =  UIStepper(frame: CGRect(x: 10, y: 72
                                           , width: 0, height: 0))
                priceLabel.textAlignment = .left
                subTotalLabel.textAlignment = .left
            default:
                break
            }
        }
    }
    
    @objc
    func stepperClicked(_ sender: UIStepper) {
        let value =   String(format:"%d",Int(sender.value));
        quantityValueTextField.text = value
        myCartViewModel.setDataToCartModel(data: value, pos: sender.tag)
        quantityIndcator.startAnimating()
        delegate.updateAPICall(index: quantityStepper.tag)
        NetworkManager.sharedInstance.showInfoSnackBar(msg: "updatecartplease".localized);
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
