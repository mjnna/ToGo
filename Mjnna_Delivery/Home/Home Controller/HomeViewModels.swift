//
/**
 * @author amr obaid
 */


import Foundation

class HomeViewModel: NSObject {
    var items = [HomeViewModelItem]()
    var typesCollectionModel = [StoreTypes]()
   
  //  var currencyData  = [Currency]()
  //  var languageData = [Languages]()
    
    var homeViewController:ViewController!
    /*!
    var cartCount:Int = 0
    var locationData: String = ""
    var longitude = 0.0
    var latitude = 0.0*/
    var defaultLanguage: String = "en"
    
    func getData(data : JSON   , completion:(_ data: Bool) -> Void) {
        guard let data = HomeModal(data: data) else {
            return
        }
        
        items.removeAll()
        
        for item in data.home_sequence {
            if item == .banner && !data.bannerCollectionModel.isEmpty {
                items.append(
                    HomeViewModelBannerItem(categories: data.bannerCollectionModel)
                )
            } else if item == .type && !data.typesCollectionModel.isEmpty {
                typesCollectionModel = data.typesCollectionModel
                items.append(
                    HomeViewModelTypeItem(categories: data.typesCollectionModel)
                )
            }
        }
        
        /*if !data.currencyData.isEmpty{
            currencyData = data.currencyData
        }
        if !data.languageData.isEmpty{
            languageData = data.languageData
        }*/
        
        /*self.locationData = data.locationData
        self.longitude = data.longitude
        self.latitude = data.latitude
        cartCount = data.cartCount
        self.defaultLanguage = data.defaultLanguage*/
        
        completion(true)
    }
}

//MARK:- TableView Methods

extension HomeViewModel : UITableViewDelegate , UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.section]
        switch item.type {
        case .banner:
            let cell:BannerTableCell = tableView.dequeueReusableCell(withIdentifier: "bannercell") as! BannerTableCell
            cell.delegate = homeViewController
            cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
            cell.bannerView.reloadData()
            return cell;
          //ToDo: change it to type cells
        case .type:
            let cell:StoresCategoryCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StoresCategoryCell
            cell.storeCollectionModel = ((item as? HomeViewModelTypeItem)?.typesCollectionModel)!
            cell.delegate = homeViewController
            cell.categoryCollectionView.reloadData()
            return cell;
        default:
            return UITableViewCell()
        }
    }
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        switch item.type {
        case .banner:
            return 280
        case .type:
            return 430
        default:
            return 0
        }
    }
}
