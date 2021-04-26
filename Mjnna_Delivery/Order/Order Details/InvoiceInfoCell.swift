//
//  InvoiceInfoCell.swift
//  Mjnna_Delivery
//
//  Created by Khaled Kutbi on 09/09/1442 AH.
//  Copyright © 1442 Webkul. All rights reserved.
//

import Foundation
import StepIndicator

class InvoiceInfoCell: UITableViewCell {
    
    //MARK:- Cell componnet

    lazy var invoiceImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ic_invoice")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    lazy var invoiceNumberLabel:UILabel = {
       let lb = UILabel()
        lb.textColor = .black
        lb.textAlignment = .center
       return lb
    }()
    lazy var storeNameLabel:UILabel = {
       let lb = UILabel()
        lb.textColor = .gray
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textAlignment = .center
        return lb
    }()
    
    let stepIndicatorView = StepIndicatorView()
    
    lazy var totalLabel:UILabel = {
       let lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.7414126992, green: 0, blue: 0.09025795013, alpha: 1)
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textAlignment = .center
       return lb
    }()
   
    lazy var statusLabelStackView: UIStackView = {
        
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 8
        return sv
    }()
   
    var orderStatuses:OrderStatusData?
    var arrengedSubViews:[UILabel]!
    //MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setup()
    }
    
     required init?(coder: NSCoder) {
         
         fatalError("init(coder:) has not been implemented")
     }

   private func setup(){
    self.selectionStyle = .none
    self.contentView.isUserInteractionEnabled = true
    self.addSubview(invoiceImageView)
    let imageheight:CGFloat = self.frame.width/4
    invoiceImageView.anchor(top: self.topAnchor, paddingTop: 15,width: imageheight, height:imageheight)
    NSLayoutConstraint.activate([
        invoiceImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    self.addSubview(invoiceNumberLabel)
    invoiceNumberLabel.anchor(top: invoiceImageView.bottomAnchor, paddingTop: 10, height:20)
    NSLayoutConstraint.activate([
        invoiceNumberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    
    self.addSubview(storeNameLabel)
    storeNameLabel.anchor(top: invoiceNumberLabel.bottomAnchor, paddingTop: 10, height:20)
    NSLayoutConstraint.activate([
        storeNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    
   
    self.addSubview(totalLabel)
    totalLabel.anchor(top:storeNameLabel.bottomAnchor,paddingTop: 10, height:20)
    NSLayoutConstraint.activate([
        totalLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
    
    setupStepperView()
    self.addSubview(stepIndicatorView)
    stepIndicatorView.anchor(top: totalLabel.bottomAnchor,left: self.leadingAnchor,right: self.trailingAnchor, paddingTop: 15,paddingLeft: 40,paddingRight: 40, height:25)
    
    arrengedSubViews = generateLabels(numberOflabel: 5)
    statusLabelStackView = UIStackView(arrangedSubviews: arrengedSubViews)
    
    self.addSubview(statusLabelStackView)
    statusLabelStackView.anchor(top: stepIndicatorView.bottomAnchor,bottom:self.bottomAnchor,left: self.leadingAnchor,right: self.trailingAnchor, paddingTop: 5,paddingBottom: 10,paddingLeft: 20,paddingRight: 20, height:35)
    
   

    
    }
    
    func setupStepperView(){
        let grayCircle =  UIColor(red: 179.0/255.0, green: 189.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        self.stepIndicatorView.circleColor = grayCircle
        self.stepIndicatorView.numberOfSteps = 5
        self.stepIndicatorView.circleStrokeWidth = 3.0
        self.stepIndicatorView.circleRadius = 10.0
        self.stepIndicatorView.lineColor = self.stepIndicatorView.circleColor
        self.stepIndicatorView.lineMargin = 4.0
        self.stepIndicatorView.lineStrokeWidth = 2.0
        self.stepIndicatorView.displayNumbers = false //indicates if it displays numbers at the center instead of the core circle
        
        if let language = sharedPrefrence.object(forKey: "language") as? String{
            switch language {
            case "ar":
                self.stepIndicatorView.direction = .rightToLeft //four directions
            case "en":
                self.stepIndicatorView.direction = .leftToRight //four directions
            default:
                break
            }
        }
    }

    func generateLabels(numberOflabel:Int) -> [UILabel]{
        var labels = [UILabel]()
        for _ in 1...numberOflabel {
            let newLabel = UILabel()
            newLabel.textColor = .black
            newLabel.font = UIFont.systemFont(ofSize: 12)
            newLabel.textAlignment = .center
            newLabel.numberOfLines = 0
            newLabel.lineBreakMode = .byWordWrapping
            labels.append(newLabel)
        }
        return labels
    }
    
    func configure(storeName:String,InoviceNo:Int,statusId:Int,total:String){
        let inoviceWord = "Invoice No.".localized
        let fullString = inoviceWord + "\(InoviceNo)"
       
        self.invoiceNumberLabel.attributedText = boldSpacificWrod(fullString: fullString, boldWord: inoviceWord, fontSize: 20)
        self.storeNameLabel.text = storeName
        let currencyWord = " SAR".localized
        self.totalLabel.text = total + currencyWord
        self.stepIndicatorView.currentStep = statusId
        
        if statusId == 5{
        let greenTintColor = UIColor(red: 0.0/255.0, green: 180.0/255.0, blue: 124.0/255.0, alpha: 1.0)
            self.stepIndicatorView.circleTintColor = greenTintColor
            self.stepIndicatorView.lineTintColor = .black

        }else if statusId == 6 {
            //goto rejected screen
        }else{
            let goldTintColor:UIColor = UIColor().HexToColor(hexString: GlobalData.GOLDCOLOR)
            self.stepIndicatorView.circleTintColor = goldTintColor
            self.stepIndicatorView.lineTintColor = self.stepIndicatorView.circleTintColor

        }

    }
    func getStatus(viewController:UIViewController){
        var requstParams = [String:String]()

        if let lang = sharedPrefrence.object(forKey: "language") as? String{
            requstParams["lang"] = lang
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, apiname:"order/statuses",cuurentView: viewController){val,responseObject in
               if val == 1 {
                   let dict = JSON(responseObject as! [NSDictionary])

                   if dict["error"] != nil{
                      //display the error to the customer
                        print("somthing went wrong")
                   }
                   else{
                    self.orderStatuses = OrderStatusData(data: dict)
                    if let statuses = self.orderStatuses?.orderStatuses{
                        for n in 0..<(statuses.count-1){
                            if requstParams["lang"] == "ar"{
                                self.arrengedSubViews[n].text = statuses[n].ar_name
                            }else{
                                print("ffffff: \(statuses[n].en_name)")
                                self.arrengedSubViews[n].text = statuses[n].en_name
                            }
                        }
                   }
                   }
                   
               }
               else{
                   NetworkManager.sharedInstance.dismissLoader()
                self.getStatus(viewController: viewController)
               }
        }
    }
   
}

class OrderStatusData
{
    var orderStatuses = [OrderStatus]()
    init(data: JSON) {
        if let arrayData1 = data.array{
            orderStatuses =  arrayData1.map({(value) -> OrderStatus in
                return  OrderStatus(data:value)
            })
        }
    }
}
struct OrderStatus {
    
    var id:Int = 0
    var ar_name:String = ""
    var en_name:String = ""
    
    init(data:JSON) {
        self.id = data["id"].intValue
        self.ar_name = data["ar_name"].stringValue
        self.en_name = data["en_name"].stringValue
    }
    
}
