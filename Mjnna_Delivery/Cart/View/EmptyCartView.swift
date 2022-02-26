//
//  EmptyCartView.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 14/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit


class EmptyCartView: UIView{
    
    lazy var imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "02_Shopping_Bag-512(1)")
        return iv
    }()
    
    lazy var messageLabel: UILabel = {
       let lb = UILabel()
        lb.text = NetworkManager.sharedInstance.language(key: "cartempty")
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var browsButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setTitle("Borowse categories".localized, for: .normal)
        btn.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
        return btn
    }()
    
    let screenSize = UIScreen.main.bounds
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        
        self.addSubview(imageView)
        let height = screenSize.width/2
        
        imageView.anchor(top: self.topAnchor, paddingTop: 10, width: height, height: height)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        self.addSubview(messageLabel)
        self.messageLabel.anchor(top: imageView.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 30,paddingLeft: 20,paddingRight: 20, height: 35)
        
        self.addSubview(browsButton)
        browsButton.anchor(top: messageLabel.bottomAnchor,bottom: self.bottomAnchor, paddingTop: 15, width: 200, height: 40)
        NSLayoutConstraint.activate([
            browsButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
    }
    
    func animate(isAmimted:Bool){
        self.isHidden = !isAmimted
        if isAmimted {
            UIView.animate(withDuration: 1, animations: {() -> Void in
                self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 1, animations: {() -> Void in
                    self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            })
        }
    }
}
