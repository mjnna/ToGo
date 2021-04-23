//
//  MyOrderTableViewCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 18/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
    
    lazy var invoiceNo: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    lazy var priceLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    lazy var topStckView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [invoiceNo,priceLabel])
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    lazy var deliveryDate: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .gray
        return lb
    }()
    lazy var infoStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [topStckView,deliveryDate])
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()

    lazy var statusLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        lb.textAlignment = .center
        return lb
    }()
        
    lazy var statusView: UIView = {
        let iv = UIView()
        iv.layer.cornerRadius = 10
        
        iv.addSubview(statusLabel)
        statusLabel.anchor(top: iv.topAnchor, bottom: iv.bottomAnchor, left: iv.leadingAnchor, right: iv.trailingAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 5)
        
        return iv
    }()
    lazy var bottomView: UIView = {
        let iv = UIView()
        iv.addSubview(statusView)
        statusView.anchor( bottom: iv.bottomAnchor ,right: iv.trailingAnchor, paddingRight: 0,height: 30)
        
        return iv
    }()
    lazy var mainStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [infoStackView,bottomView])
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    
    lazy var mainView: UIView = {
        let iv = UIView()

        iv.addSubview(mainStackView)
        mainStackView.anchor(top: iv.topAnchor, bottom: iv.bottomAnchor, left: iv.leadingAnchor, right: iv.trailingAnchor,paddingTop: 10,paddingBottom: 10,paddingLeft:10, paddingRight: 10)

        
        return iv
    }()
    let borderLayer = CAShapeLayer()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setup()
    }
    override func layoutSublayers(of layer: CALayer) {
            super.layoutSublayers(of: layer)
            borderLayer.frame = mainView.bounds
            borderLayer.path = UIBezierPath(roundedRect: mainView.bounds, cornerRadius: 10).cgPath
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        self.selectionStyle = .none
       
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
        borderLayer.strokeColor = UIColor.gray.cgColor
        borderLayer.lineDashPattern = [6, 6]
        borderLayer.fillColor = nil
        mainView.layer.addSublayer(borderLayer)
        
        self.addSubview(mainView)
        mainView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 20, paddingRight: 20)
        mainView.addDashedBorder()
    }
    
    func configure(invoiceId:String , status:String ,statusId:Int , price:String , date:String){
        self.invoiceNo.text = "Invoice No:".localized + invoiceId
        self.priceLabel.text = price + " SAR".localized
        self.deliveryDate.text = date
        self.statusLabel.text = " " + status + " "
        switch statusId {
        case 1:
            statusView.backgroundColor = .gray
        case 2:
            statusView.backgroundColor = .orange
        case 3:
            statusView.backgroundColor =  .yellow
        case 4:
            statusView.backgroundColor = .cyan
        case 5:
            statusView.backgroundColor = .green
        default:
            statusView.backgroundColor = .red
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
