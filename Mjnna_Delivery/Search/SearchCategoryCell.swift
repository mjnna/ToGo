//
//  SearchCategoryCell.swift
//  Opencart
//
//  Created by kunal on 30/07/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SearchCategoryCell: UITableViewCell {

   
@IBOutlet var collectionView: UICollectionView!
var featureCategoryCollectionModel = [Categories]()
var delegate:CategoryViewControllerHandlerDelegate!
@IBOutlet var flowLayout: UICollectionViewFlowLayout!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "NameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NameCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    
}

extension SearchCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureCategoryCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameCollectionViewCell", for: indexPath) as! NameCollectionViewCell
        cell.labelName.text = featureCategoryCollectionModel[indexPath.row].name
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width =   (featureCategoryCollectionModel[indexPath.row].name.width(withConstraintedHeight:30, font: UIFont.boldSystemFont(ofSize: 14)))
        return CGSize(width: width + 30 , height: 40)
    }
    
  
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*delegate.categoryProductClick(name:featureCategoryCollectionModel[indexPath.row].name , ID: featureCategoryCollectionModel[indexPath.row].id, isChild: featureCategoryCollectionModel[indexPath.row].isChild, thumbnail: featureCategoryCollectionModel[indexPath.row].thumbnail)*/
        
    }
    
    
    
    
}
