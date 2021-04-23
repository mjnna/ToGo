//
//  SortCollectionViewCell.swift
//  Mjnna_Delivery
//
//  Created by mjnna.com on 8/18/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit

protocol SortDelegate {
    func didTapSort()
    func didTapFilter()
}

class SortCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var FilterView: UIView!
    @IBOutlet weak var SortView: UIView!
    @IBOutlet weak var FilterLabel: UILabel!
    @IBOutlet weak var SortLabel: UILabel!
    var delegate : SortDelegate?
    
    @objc func Filter(_ sender:UITapGestureRecognizer){
        delegate?.didTapFilter()
    }
    
    @objc func Sort(_ sender:UITapGestureRecognizer){
        delegate?.didTapSort()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        FilterLabel.text = "filter".localized
        SortLabel.text = "sort".localized
        FilterView.layer.cornerRadius = 10
        SortView.layer.cornerRadius = 10
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (Filter (_:)))
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (Sort (_:)))
        self.FilterView.addGestureRecognizer(gesture)
        self.SortView.addGestureRecognizer(gesture2)
        // Initialization code
    }

}
