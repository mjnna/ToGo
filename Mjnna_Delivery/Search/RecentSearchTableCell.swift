//
//  RecentSearchTableCell.swift
//  Opencart
//
//  Created by kunal on 30/07/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit


protocol RecentSearchDataDelegate {
    func recentTextClick(data:String)
}



class RecentSearchTableCell: UITableViewCell {
    
    @IBOutlet var recentSearchLabel: UILabel!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    var recentSearchData:NSArray = []
var delegate: RecentSearchDataDelegate!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recentSearchLabel.text = "recentsearch".localized
        clearButton.setTitle("clear".localized, for: .normal)
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "categorycell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
}
extension RecentSearchTableCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorycell", for: indexPath) as! CategoryCell
        cell.backgroundColor = UIColor.white
        cell.labelName.text = recentSearchData[indexPath.row] as? String
        cell.imageView.image = UIImage(named: "ic_search")
        cell.imageView.backgroundColor = UIColor().HexToColor(hexString: "F0F0F0")
        cell.imageView.contentMode = .scaleAspectFit
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50 , height: 90)
    }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate.recentTextClick(data:(recentSearchData[indexPath.row] as? String)!)
    
    }
    
}
