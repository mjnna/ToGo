//
//  SearchBarView.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 24/08/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import UIKit

class SearchBarView : UIView{
    
    
    
    lazy var searchTextFeild: UITextField = {
       let tf = UITextField()
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tf.layer.cornerRadius = 10
        tf.textColor = .gray
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.placeholder = "Search for stors".localized
        tf.leftViewMode = .always
        let leftSideView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        leftSideView.image = #imageLiteral(resourceName: "ic_search_fill")
        leftSideView.image = leftSideView.image?.withRenderingMode(.alwaysTemplate)
        leftSideView.tintColor = #colorLiteral(red: 0.7886764407, green: 0.7839893103, blue: 0.7922801375, alpha: 1)
        tf.leftView = leftSideView
       return tf
    }()
    lazy var fastDeleviryButton: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.9142650962, green: 0.7360221744, blue: 0, alpha: 1)
        btn.layer.cornerRadius = 10
        var image = #imageLiteral(resourceName: "fast.png")
        btn.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        image = image.withRenderingMode(.alwaysTemplate)
        btn.tintColor = #colorLiteral(red: 0.1725490196, green: 0.2509803922, blue: 0.4352941176, alpha: 1)
        btn.setImage(image, for: .normal)
        btn.anchor(width:40)
        return btn
    }()
    lazy var searchStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [searchTextFeild,fastDeleviryButton])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fill
        return sv
    }()
    //MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.roundCorners(corners: [.topRight,.bottomRight], radius: 30)

    }
    
    //MARK:- Handler
    func setup(){
        
        self.backgroundColor = .white
        self.anchor(height:60)
        self.addSubview(searchStackView)
        searchStackView.anchor(left:self.leadingAnchor,right:self.trailingAnchor,paddingLeft: 20,paddingRight: 20,height: 40)
        NSLayoutConstraint.activate([
            searchTextFeild.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
}
