//
//  FilterController.swift
//  Abdullah
//
//  Created by kunal on 19/01/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit


@objc protocol FilterControllerHandlerDelegate: class {
    func selectedFilterData(categories:NSMutableArray)
    
}


/*
class FilterController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    }
    
    
    
    var productCollectionViewModel:ProductCollectionViewModel!
    
    @IBOutlet weak var filterTableView: UITableView!
    var delegate:FilterControllerHandlerDelegate!
    @IBOutlet var dismissButton: UIButton!
    
    
    @IBOutlet weak var filterheading: UILabel!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    var selectedFilterIDs:NSMutableArray = []
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        self.filterTableView.separatorStyle = .none
        filterTableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterTableViewCell")
        
        clearButton.setTitle(NetworkManager.sharedInstance.language(key: "reset"), for: .normal)
        clearButton.setTitleColor(UIColor.white, for: .normal)
        clearButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        
        applyButton.setTitle(NetworkManager.sharedInstance.language(key: "apply"), for: .normal)
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.backgroundColor = UIColor().HexToColor(hexString: GlobalData.BUTTON_COLOR)
        
        
        dismissButton.layer.cornerRadius = 15
        dismissButton.layer.masksToBounds = true
        
        filterheading.text = NetworkManager.sharedInstance.language(key: "filter")
        
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        self.filterTableView.reloadData()
        
    }
    
    
    @IBAction func dismissController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func clearClick(_ sender: UIButton) {
        selectedFilterIDs.removeAllObjects()
        self.filterTableView.reloadData()
    }
    
    
    @IBAction func applyClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate.selectedFilterData(categories: selectedFilterIDs)
    }
    
    /*func numberOfSections(in tableView: UITableView) -> Int {
        return self.productCollectionViewModel.filterData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.productCollectionViewModel.filterData[section].filterAttriData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as! FilterTableViewCell
        cell.name.text = self.productCollectionViewModel.filterData[indexPath.section].filterAttriData[indexPath.row].name
        cell.mainView.tag = indexPath.section
        cell.switchButton.tag = indexPath.row
        
        let id = self.productCollectionViewModel.filterData[indexPath.section].filterAttriData[indexPath.row].filter_ID
        
        if selectedFilterIDs.contains(id){
            cell.switchButton.isOn = true
        }else{
            cell.switchButton.isOn = false
        }
        cell.switchButton.addTarget(self, action:#selector(self.switchButtonClick), for: .valueChanged)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.productCollectionViewModel.filterData[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    @objc func switchButtonClick(_ sender: UISwitch) {
        let id =  self.productCollectionViewModel.filterData[(sender.superview?.tag)!].filterAttriData[sender.tag].filter_ID
        if sender.isOn{
            if selectedFilterIDs.contains(id) == false{
                selectedFilterIDs.add(id)
            }
        }else{
            if selectedFilterIDs.contains(id) == true{
                selectedFilterIDs.remove(id)
            }
        }
        
    }*/
}
*/
