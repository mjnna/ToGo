//
/**
* Webkul Software.
* @package  MobikulOpencartMp
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: OurLocationController.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import UIKit

class OurLocationController: UIViewController {
        
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var storeImageViewWidht: NSLayoutConstraint!
    @IBOutlet weak var yourStore: UILabel!
    @IBOutlet weak var yourStoreData: UILabel!
    @IBOutlet weak var storeLocation: UIButton!
    @IBOutlet weak var telePhoneLbl: UILabel!
    @IBOutlet weak var telePhoneData: UILabel!
    @IBOutlet weak var faxLbl: UILabel!
    @IBOutlet weak var faxData: UILabel!
    @IBOutlet weak var openingTimeLbl: UILabel!
    @IBOutlet weak var openingTimeData: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var commentData: UILabel!
    
    @IBOutlet weak var storeLocationHeight: NSLayoutConstraint!
    var data: ContactUsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Our Location".localized
        if data!.image == "" {
            storeImageViewHeight.constant = 0
        } else {
            storeImageView.loadImageFrom(url: data!.image)
            storeImageViewHeight.constant = CGFloat(integerLiteral: min(Int(data!.image_height)!, Int(self.view.bounds.height) - 16))
            storeImageViewWidht.constant = CGFloat(integerLiteral: min(Int(data!.image_width)!, Int(self.view.bounds.width) - 16))
        }
        if data!.geolocation == "" {
            storeLocationHeight.constant = 0
        } else {
            storeLocation.setTitle("View Google Map".localized, for: .normal)
            storeLocation.layer.cornerRadius = 5
            storeLocation.layer.borderWidth = 0.8
            storeLocation.backgroundColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)//.red
            storeLocation.setTitleColor(.white, for: .normal)
        }
        
        if data!.address == "" {
            yourStore.isHidden = true
            yourStoreData.isHidden = true
        } else {
            yourStore.text = data?.store
            yourStoreData.text = data?.address
        }
        
        if data!.telephone == "" {
            telePhoneLbl.isHidden = true
            telePhoneData.isHidden = true
        } else {
            telePhoneLbl.text = "TelePhone".localized
            telePhoneData.text = data?.telephone
        }
         
        if data!.fax == "" {
            faxLbl.isHidden = true
            faxData.isHidden = true
        } else {
            faxLbl.text = "fax".localized
            faxData.text = data?.fax
        }
        
        if data!.open == "" {
            openingTimeLbl.isHidden = true
            openingTimeData.isHidden = true
        } else {
            openingTimeLbl.text = "Opening Times".localized
            openingTimeData.text = data?.open
        }
        
        if data!.comment == "" {
            commentLbl.isHidden = true
            commentData.isHidden = true
        } else {
            commentLbl.text = "Comments".localized
            commentData.text = data?.comment
        }

    }
    
    @IBAction func storeLocationOpen(_ sender: Any) {
        UIApplication.shared.open(
            URL(string: data!.geolocation)!,
            options: [:],
            completionHandler: nil )
    }
    
}
