//
//  SuggestionProductCell.swift
//  Opencart
//
//  Created by kunal on 30/07/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit


protocol SuggestionProductClickHandlerDelegate {
    func productClick(name:String,image:String,id:String)
}


class SuggestionProductCell: UITableViewCell {

   
@IBOutlet var collectionView: UICollectionView!
var productCollectionModel = [Products]()
var delegate:SuggestionProductClickHandlerDelegate!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "SuggestedPrductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SuggestedPrductCollectionCell")
        collectionView.register(UINib(nibName: "EmtyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmtyCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
}


extension SuggestionProductCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return productCollectionModel.count + 1
     }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmtyCollectionViewCell", for: indexPath) as! EmtyCollectionViewCell
            return cell
        }else{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestedPrductCollectionCell", for: indexPath) as! SuggestedPrductCollectionCell
        cell.productImage.loadImageFrom(url:productCollectionModel[indexPath.row - 1].image , dominantColor: productCollectionModel[indexPath.row - 1].dominant_color)
        cell.name.text = productCollectionModel[indexPath.row-1].name
        cell.price.text = productCollectionModel[indexPath.row-1].price
        cell.specialPrice.text = ""
        if productCollectionModel[indexPath.row - 1].specialPrice != 0  && (productCollectionModel[indexPath.row - 1].specialPrice) > 0{
            cell.specialPrice.isHidden = false;
            cell.price.text =  productCollectionModel[indexPath.row - 1].formatted_special
            let attributeString = NSMutableAttributedString(string: productCollectionModel[indexPath.row - 1].price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            cell.specialPrice.attributedText = attributeString
        }
        
       cell.layer.cornerRadius = 10;
       cell.layer.masksToBounds = true
       cell.contentView.backgroundColor = UIColor.white
      return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSize(width: 100 , height: collectionView.frame.size.width/2 + 70)
        }else{
            return CGSize(width: collectionView.frame.size.width/2 - 16 , height: collectionView.frame.size.width/2 + 70)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row > 0{
         delegate.productClick(name: productCollectionModel[indexPath.row - 1].name, image: productCollectionModel[indexPath.row - 1].image, id: productCollectionModel[indexPath.row - 1].productID)
        }
    }
    
    
    
}
