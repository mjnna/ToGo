//
//  SellerCategoryTableViewCell.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 7/21/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit
import Cosmos
import TransitionButton




class SellerCategoryTableViewCell: UITableViewCell {

    //MARK:- Component

    lazy var sellerImage: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.anchor(height:180)
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 0.5
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var sellerName: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    lazy var rateView: CosmosView = {
       let v = CosmosView()
       return v
    }()
    lazy var nameAndRateStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [sellerName,rateView])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 10
       return sv
    }()
    lazy var descriptionn: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .gray
        lb.text = ".dskjvskdjvnkjn"
        return lb
    }()
 
    lazy var available: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.text = "Available".localized
        lb.textColor = .gray
        return lb
    }()
    
    lazy var fastDeliveryView: UIView = {
       let v = UIView()
        v.isHidden = true
        v.backgroundColor = #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1)
        v.layer.cornerRadius = 5
        v.addSubview(fastDelideryLabel)
        fastDelideryLabel.anchor(top: v.topAnchor, bottom: v.bottomAnchor, left: v.leadingAnchor, right: v.trailingAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 5)
       return v
    }()
    lazy var fastDelideryLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Fast delivery".localized
        lb.font = UIFont.boldSystemFont(ofSize: 10)
        lb.textColor =  .white
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var infoView: UIView = {
       let v = UIView()
        
        v.anchor(height:90)

        v.addSubview(nameAndRateStackView)
        nameAndRateStackView.anchor(top: v.topAnchor, left: v.leadingAnchor, paddingTop: 10, paddingLeft: 20, height: 20)

        v.addSubview(descriptionn)
        descriptionn.anchor(top: sellerName.bottomAnchor, left: v.leadingAnchor,right: v.trailingAnchor, paddingTop: 7, paddingLeft: 20,paddingRight: 20 , height: 15)

        v.addSubview(fastDeliveryView)
        fastDeliveryView.anchor(top: descriptionn.bottomAnchor, left: v.leadingAnchor, paddingTop: 7, paddingLeft: 20 ,width:80, height: 20)

        v.addSubview(available)
        available.anchor(bottom:v.bottomAnchor, right: v.trailingAnchor,paddingBottom: 12, paddingRight: 20, height: 15)

      
       return v
    }()
    
    lazy var mainStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [sellerImage,infoView])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 0
       return sv
    }()
 
    lazy var mainView: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.dropShadow(radius: 3, opacity: 0.4, color: .black)
        v.addSubview(mainStackView)
        mainStackView.anchor(top: v.topAnchor, bottom: v.bottomAnchor, left: v.leadingAnchor, right: v.trailingAnchor)
       return v
    }()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sellerImage.roundCorners(corners: [.topLeft,.topRight], radius: 10)
    }
    private func setup(){
        self.selectionStyle = .none
       
        self.addSubview(mainView)
        mainView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 20, paddingRight: 20)

        layer.cornerRadius = 15.0
        layer.masksToBounds = true

  }
    //MARK:- Handler

    public func configure(with title: String, url: String, rate: String , description: String,isFast:String){
        sellerName.text = title
        rateView.rating = Double(rate)!
        descriptionn.text = description
        sellerImage.loadImage(stringURL: url)
        isStoreSupportFastDelivery(isFast: isFast)
    }
    
    func isStoreSupportFastDelivery(isFast:String){
        if isFast == "0"{
            fastDeliveryView.isHidden = true
        }else{
            fastDeliveryView.isHidden = false
        }
    }
}
