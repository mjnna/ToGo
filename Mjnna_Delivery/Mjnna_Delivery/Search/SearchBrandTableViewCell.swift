//
//  SearchBrandTableViewCell.swift
//  Opencart
//
//  Created by kunal on 30/07/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SearchBrandTableViewCell: UITableViewCell {

@IBOutlet var collectionView: UICollectionView!
var brandCollectionModel = [BrandProducts]()
var delegate:BrandViewControllerHandlerDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "SearchBrandImageCell", bundle: nil), forCellWithReuseIdentifier: "SearchBrandImageCell")
        collectionView.register(UINib(nibName: "EmtyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmtyCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}


extension SearchBrandTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandCollectionModel.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmtyCollectionViewCell", for: indexPath) as! EmtyCollectionViewCell
            return cell
        }else{
            
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchBrandImageCell", for: indexPath) as! SearchBrandImageCell
         cell.productImage.loadImageFrom(url:brandCollectionModel[indexPath.row - 1].image , dominantColor: brandCollectionModel[indexPath.row - 1].dominant_color)
         cell.layoutIfNeeded()
         cell.layer.cornerRadius = 35
         cell.layer.masksToBounds = true
         return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.brandProductClick(name: brandCollectionModel[indexPath.row - 1].title, ID: brandCollectionModel[indexPath.row - 1].link)

    }

    
    
}
