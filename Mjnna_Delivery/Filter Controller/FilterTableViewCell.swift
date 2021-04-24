//
//  FilterTableViewCell.swift
//  Abdullah
//
//  Created by kunal on 23/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet var mainView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
    
}
