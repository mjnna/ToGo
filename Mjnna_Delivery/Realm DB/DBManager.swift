//
//  DBManager.swift
//  RealmDatabase
//
//  Created by kunal on 22/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class DBManager {
    
    public var database:Realm?
    static let sharedInstance = DBManager()
    
    private init() {
         do{
            database = try Realm()
         }catch{
            print(error)
        }
    }
    
    func storeDataToDataBase(data:String,ApiName:String,dataBaseObject:AllDataCollection){
        
        let result =  DBManager.sharedInstance.database?.object(ofType: AllDataCollection.self, forPrimaryKey: ApiName)
        
        if let previousData = result{
            try? DBManager.sharedInstance.database?.write {
                previousData.data = data
            }
        }else{
            dataBaseObject.data = data;
            dataBaseObject.ApiName = ApiName
            try? DBManager.sharedInstance.database?.write {
                DBManager.sharedInstance.database?.add(dataBaseObject, update: .all)
            }
        }
        
    }
    
    
    
    func getJSONDatafromDatabase(ApiName:String , taskCallback: @escaping (Bool,
        JSON?) -> Void) {
        
        var resultData:JSON = []
        
        do{
            try DBManager.sharedInstance.database?.write {
                let result =  DBManager.sharedInstance.database?.object(ofType: AllDataCollection.self, forPrimaryKey: ApiName)
            if result?.data != nil{
                resultData = JSON(NetworkManager.sharedInstance.convertToDictionary(text: (result?.data)!) ?? [:])
                
            }
        }
        }catch{
            print(error)
        }
        
        if resultData.isEmpty{
            taskCallback(false,resultData)
        }else{
            taskCallback(true,resultData)
        }
        
        
        
        
        
    }
    
    func deleteAllFromDatabase()  {
        do{
            try DBManager.sharedInstance.database?.write {
                database?.deleteAll()
            }
        }catch let error as NSError {
            print("ss", error)
        }
    }
}
