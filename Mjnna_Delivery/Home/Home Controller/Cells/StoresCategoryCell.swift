//
//  TopCategoryTableViewCell.swift
//  WooCommerce
//
//  Created by Kunal Parsad on 01/11/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

@objc protocol CategoryViewControllerHandlerDelegate: class {
    func typeClick(name:String,ID:String,thumbnail:String)
}

class StoresCategoryCell : UITableViewCell {
    
    //MARK: - Component
    lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(StoreCategoryCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return cv
    }()
    
    var delegate:CategoryViewControllerHandlerDelegate!
    var storeCollectionModel = [StoreTypes]()
    
    //MARK:- Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        contentView.isUserInteractionEnabled = true

        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.reloadData()
        
        self.selectionStyle = .none
        
        self.addSubview(categoryCollectionView)
        categoryCollectionView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
    }
}

extension StoresCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StoreCategoryCell
        let imageUrl = storeCollectionModel[indexPath.row].thumbnail
        cell.typeImageView.loadImage(stringURL: imageUrl)
        cell.typeTitleLabel.text = storeCollectionModel[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = storeCollectionModel[indexPath.row].name
        let id = storeCollectionModel[indexPath.row].id
        let thumbnil = storeCollectionModel[indexPath.row].image
        delegate.typeClick(name: name, ID: id, thumbnail: thumbnil)
    }
   
    
   
}
extension StoresCategoryCell :UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth:CGFloat = self.frame.width
        let cellWidth:CGFloat = viewWidth/4 + 10
        return CGSize(width: cellWidth , height: cellWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
  
    
}
class StoreCategoryCell: UICollectionViewCell {
    
    lazy var typeImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFit
        iv.anchor(width:55,height:55)
        return iv
    }()

    lazy var typeTitleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textAlignment = .center
        lb.anchor(height:15)
        return lb
    }()
    lazy var stackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [typeImageView,typeTitleLabel])
        sv.alignment = .center
        sv.spacing = 10
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }()
    override init(frame: CGRect) {
      super.init(frame: frame)
       self.setup()
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
   private func setup(){
    self.addDashedBorder()
    addSubview(stackView)
    stackView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leadingAnchor, right: self.trailingAnchor,paddingTop: 10,paddingBottom: 10,paddingLeft: 10,paddingRight: 10)
     
   }
}
