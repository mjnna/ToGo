//
//  TableViewCell.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 08/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class OrderProductCell: UITableViewCell {

    //MARK:- compnent
    
    lazy var productImageView: UIImageView = {
       let iv = UIImageView()
        iv.anchor(width:110 )
       return iv
    }()
    
    lazy var nameLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .black
//        let relativeFontConstant:CGFloat = 0.04
//        let fontSize = self.superview.frame.width * relativeFontConstant
//        print("Fontsize : \(fontSize)")
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.anchor(height:20)

        return lb
    }()
    
    lazy var weightLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .gray
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.anchor(height:15)

        return lb
    }()
    
    lazy var quantityLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = .black
        lb.anchor(height:15)

        return lb

    }()
    
    lazy var priceLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1)
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.anchor(height:20)
        return lb
    }()

    
    lazy var infoView: UIView = {
        let v = UIView()

        v.addSubview(nameLabel)
        nameLabel.anchor(top: v.topAnchor, left: v.leadingAnchor, paddingTop: 15, paddingLeft: 5,height: 20)

        v.addSubview(weightLabel)
        weightLabel.anchor(top: nameLabel.bottomAnchor, left: v.leadingAnchor, paddingTop: 10, paddingLeft: 5,height: 15)

        v.addSubview(quantityLabel)
        quantityLabel.anchor(top: (weightLabel).bottomAnchor, left: v.leadingAnchor, paddingTop: 10, paddingLeft: 5,height: 15)
        
        v.addSubview(priceLabel)
        priceLabel.anchor(top: v.topAnchor, right: v.trailingAnchor, paddingTop: 15,paddingRight: 5, height: 20)
        
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
    
    addSubview(mainView)
    mainView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 20, paddingRight: 20)
    
    borderLayer.strokeColor = UIColor.gray.cgColor
    borderLayer.lineWidth = 0.5
    borderLayer.lineDashPattern = [6, 6]
    borderLayer.fillColor = nil
    mainView.layer.addSublayer(borderLayer)

    }
    
    func configure(image:[String],name:String,whight:String,quantity:Int,price:String){
        productImageView.loadImageFrom(url: image[0])
        let weightWord = "Weight: ".localized
        let quantityWord = "Quantity: ".localized
        nameLabel.text = name
        weightLabel.text = weightWord + whight
        let fullString = "\(quantityWord)\(quantity)"
        quantityLabel.attributedText = boldSpacificWrod(fullString: fullString, boldWord: "\(quantity)", fontSize: 13)
        priceLabel.text = price 
    }
    
}
