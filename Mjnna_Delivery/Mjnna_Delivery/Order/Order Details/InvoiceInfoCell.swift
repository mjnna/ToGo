//
//  InvoiceInfoCell.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 09/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation

class InvoiceInfoCell: UITableViewCell {
    
    //MARK:- Cell componnet

    lazy var invoiceImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_invoice")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    lazy var invoiceNumberLabel:UILabel = {
       let lb = UILabel()
        lb.textColor = .black
        lb.textAlignment = .center
       return lb
    }()
    
    lazy var trackOrderButton: ShadowButton = {
       let btn = ShadowButton()
        btn.backgroundColor =  UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        btn.layer.cornerRadius = 15
        let title = "Track order".localized
        btn.addTitle(title: title, fontSize: 15)
        return btn
    }()
    lazy var totalLabel:UILabel = {
       let lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1)
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textAlignment = .center
       return lb
    }()
    
    //MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setup()
    }
    
     required init?(coder: NSCoder) {
         
         fatalError("init(coder:) has not been implemented")
     }

   private func setup(){
    self.selectionStyle = .none
    self.contentView.isUserInteractionEnabled = true
    self.addSubview(invoiceImageView)
    let imageheight:CGFloat = self.frame.width/4
    invoiceImageView.anchor(top: self.topAnchor, paddingTop: 30,width: imageheight, height:imageheight)
    NSLayoutConstraint.activate([
        invoiceImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    self.addSubview(invoiceNumberLabel)
    invoiceNumberLabel.anchor(top: invoiceImageView.bottomAnchor, paddingTop: 15, height:20)
    NSLayoutConstraint.activate([
        invoiceNumberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    
    self.addSubview(trackOrderButton)
    trackOrderButton.anchor(top: invoiceNumberLabel.bottomAnchor, paddingTop: 15,width: 120, height:30)
    NSLayoutConstraint.activate([
        trackOrderButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    
    self.addSubview(totalLabel)
    totalLabel.anchor(top:trackOrderButton.bottomAnchor,bottom:self.bottomAnchor,paddingTop: 15,paddingBottom: 10, height:20)
    NSLayoutConstraint.activate([
        totalLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])

    }
    
    func configure(InoviceNo:Int,total:String){
        let inoviceWord = "Invoice No.".localized
        let fullString = inoviceWord + "\(InoviceNo)"
       
        self.invoiceNumberLabel.attributedText = boldSpacificWrod(fullString: fullString, boldWord: inoviceWord, fontSize: 20)
        let currencyWord = " SAR".localized
        self.totalLabel.text = total + currencyWord
    }
}
