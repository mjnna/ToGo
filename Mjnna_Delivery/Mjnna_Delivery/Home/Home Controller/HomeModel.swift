//
/**
 * @author amr obaid
 */

import Foundation

class HomeModal {
    var bannerCollectionModel = [BannerData]()
    var typesCollectionModel = [StoreTypes]()
    //var currencyData  = [Currency]()
    //var languageData = [Languages]()
    //var locationData: String = ""
    //var cartCount: Int = 0
    //var latitude: Double
    //var longitude: Double
    var defaultLanguage: String = "en"
    var home_sequence = [HomeModelSequence.banner , HomeModelSequence.type]
    
    init?(data : JSON) {
        if let arrayData = data["banners"].array{
            bannerCollectionModel =  arrayData.map({(value) -> BannerData in
                return  BannerData(data:value)
            })
        }
        
        if let arrayData1 = data["store_types"].array{
            typesCollectionModel =  arrayData1.map({(value) -> StoreTypes in
                return  StoreTypes(data:value)
            })
        }
        
       /* if let arrayData5 = data["currencies"]["currencies"].array{
            currencyData =  arrayData5.map({(value) -> Currency in
                return  Currency(data:value)
            })
        }
        
        if let arrayData6 = data["languages"]["languages"].array{
            languageData =  arrayData6.map({(value) -> Languages in
                return  Languages(data:value)
            })
        }*/
        
        /*sharedPrefrence.set(data["languages"]["code"].stringValue, forKey: "language")
        sharedPrefrence.set(data["currencies"]["code"].stringValue, forKey: "currency")
        sharedPrefrence.synchronize()
        cartCount = data["cart"].intValue
        self.defaultLanguage = data["languages"]["code"].stringValue
        self.locationData = data["location"]["location"].stringValue
        longitude = data["location"]["longitude"].doubleValue
        latitude = data["location"]["latitude"].doubleValue*/
       
//        let array = [HomeModelSequence.banner , HomeModelSequence.type]
    }
    enum HomeModelSequence {
        case banner, type, none
    }
}



struct BannerData{
    var bannerType: String
    var imageUrl: String
    var bannerLink: String
    var bannerName: String
    var dominant_color: String
    
    init(data:JSON){
        bannerType = data["type"].stringValue
        imageUrl  = data["image"].stringValue
        bannerLink = data["link"].stringValue
        bannerName = data["title"].stringValue
        self.dominant_color = data["dominant_color"].stringValue
    }
}

struct StoreTypes{
    var id: String
    var name: String
    var image: String
    var thumbnail: String
    
    init(data:JSON){
        name  = data["name"].stringValue.html2String
        id = data["id"].stringValue
        image = data["image"].stringValue
        self.thumbnail = data["image"].stringValue
    }
}
struct Categories{
    var id: String
    var name: String
    var image: String
    var thumbnail: String
    var dominant_color: String
    var dominant_color_icon: String
    var isChild: Bool
    
    init(data:JSON){
        name  = data["name"].stringValue.html2String
        id = data["path"].stringValue
        image = data["icon"].stringValue
        self.thumbnail = data["image"].stringValue
        self.dominant_color = data["dominant_color"].stringValue
        self.dominant_color_icon = data["dominant_color_icon"].stringValue
        isChild = data["child_status"].boolValue
    }
}


class Products{
    var hasOption: Int
    var name: String
    var price: String
    var productID: String
    var rating: String
    var ratingValue: Double
    var specialPrice: Float
    var image: String
    var formatted_special: String
    var isInWishList: Int = 0
    var dominant_color: String
    var is_ar: Bool = false
    var quantity: String
    var description: String
    
    init(data:JSON) {
        self.hasOption = data["hasOption"].intValue
        self.name = data["name"].stringValue
        self.price = data["price"].stringValue
        self.productID = data["product_id"].stringValue
        self.rating = data["rating"].stringValue
        self.ratingValue = data["rating"].doubleValue
        self.specialPrice = data["special"].floatValue
        self.image = data["thumb"].stringValue
        self.formatted_special = data["formatted_special"].stringValue
        self.isInWishList = data["wishlist_status"].intValue
        self.dominant_color = data["dominant_color"].stringValue
        quantity = data["quantity"].stringValue
        if data["is_ar"].intValue == 1{
            self.is_ar = true
        }
        description = data["description"].stringValue
    }
}

struct BrandProducts{
    var image: String
    var  link: String
    var title: String
    var dominant_color: String
    
    init(data:JSON) {
        self.image = data["image"].stringValue
        self.link = data["link"].stringValue
        self.title = data["title"].stringValue
        self.dominant_color = data["dominant_color"].stringValue
    }
}

struct Currency {
    var code: String
    var title: String
    
    init(data:JSON) {
        self.code = data["code"].stringValue
        self.title = data["title"].stringValue
    }
}

struct Languages {
    var code: String
    var title: String
    init(){
        code = ""
        title = ""
    }
    init(data:JSON){
        self.code = data["code"].stringValue
        self.title = data["name"].stringValue
    }
}
//MARK:- HomeViewModelIten

protocol HomeViewModelItem {
    var type: HomeModal.HomeModelSequence { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class HomeViewModelBannerItem: HomeViewModelItem {
    var type: HomeModal.HomeModelSequence {
        return .banner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return bannerCollectionModel.count
    }
    
    var bannerCollectionModel = [BannerData]()
    
    init(categories: [BannerData]) {
        self.bannerCollectionModel = categories
    }
    
}

class HomeViewModelTypeItem: HomeViewModelItem {
    var type: HomeModal.HomeModelSequence {
        return .type
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return typesCollectionModel.count
    }
    
    var typesCollectionModel = [StoreTypes]()
    
    init(categories: [StoreTypes]) {
        self.typesCollectionModel = categories
    }
}

