//
//  ViewOrderInfoCell.swift
//  MobikulOpencartMp
//
//  Created by kunal on 02/06/18.
//  Copyright © 2018 yogesh. All rights reserved.
//

import UIKit

class ViewOrderInfoCell: UITableViewCell {
    
    @IBOutlet var returnDetailsLabel: UILabel!
    @IBOutlet var retiurnIdLabel: UILabel!
    @IBOutlet var orderIdLabel: UILabel!
    @IBOutlet var dateAddedLabel: UILabel!
    @IBOutlet var orderDateLabel: UILabel!
    @IBOutlet var productInformationLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productNameLabelValue: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var modelLabelValue: UILabel!
    @IBOutlet var qtyLabel: UILabel!
    @IBOutlet var qtyLabelValue: UILabel!
    @IBOutlet var reasonforReturnLabel: UILabel!
    @IBOutlet var reasonLabel: UILabel!
    @IBOutlet var reasonLabelValue: UILabel!
    @IBOutlet var openedLabel: UILabel!
    @IBOutlet var openedLabelValue: UILabel!
    @IBOutlet var actionLabel: UILabel!
    @IBOutlet var actionLabelValue: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var commentLAbelValue: UILabel!
    
    var data: ViewReturnRequestModel!{
        didSet {
            orderIdLabel.text = "orderid".localized + " :" + data.order_id
            retiurnIdLabel.text = "returnid".localized + " :" + data.return_id
            dateAddedLabel.text = "dateadded".localized + " :" + data.date_added
            orderDateLabel.text = "orderdate".localized + " :" + data.date_ordered
            productNameLabelValue.text = data.product
            modelLabelValue.text = data.model
            qtyLabelValue.text = data.quantity
            reasonLabelValue.text = data.reason
            openedLabelValue.text = data.opened
            actionLabelValue .text = data.action
            commentLAbelValue.text = data.comment
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        returnDetailsLabel.text = "returndetails".localized
        productInformationLabel.text = "productinfo".localized
        productNameLabel.text = "product".localized + " " + ":"
        modelLabel.text = "model".localized + " " + ":"
        qtyLabel.text = "qty".localized
        reasonforReturnLabel.text = "reasonforreturn".localized
        reasonLabel.text = "reason".localized + " " + ":"
        openedLabel.text = "opened".localized + " " + ":"
        actionLabel.text = "action".localized + " " + ":"
        commentLabel.text = "comment".localised
        mainView.layer.cornerRadius = 2
        mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOpacity = 0.5
        
        productNameLabel.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
        modelLabel.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
        qtyLabel.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
        reasonLabel.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
        openedLabel.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
        actionLabel.textColor = UIColor().HexToColor(hexString: GlobalData.LIGHTGREY)
    }
}
