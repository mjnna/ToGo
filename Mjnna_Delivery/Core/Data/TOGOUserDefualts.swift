//
//  TOGOUserDefualts.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 11/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//
import SQLite

class TOGOUserDefualts {
    
    static let shared = TOGOUserDefualts()
    private let db: Connection?
    private let settingsTable = Table("settings")
    private let Key = Expression<String>("key")
    private let Value = Expression<String?>("value")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/TOGOAPP.sqlite3")
            createSettingsTable()
        } catch {
            db = nil
            print("Unable to open database")
        }
    }
    
    func createSettingsTable() {
        do {
            try db?.run(settingsTable.create(temporary: false, ifNotExists: true, withoutRowid: true, block: { (table) in
                table.column(Key, primaryKey: true)
                table.column(Value)
            }))
        } catch let error{
            print(error)
        }
    }
    
    func insert(value: String?, forKey key: String){
        let insert = settingsTable.insert(Key <- key, Value <- value)
        do{
            try db?.run(insert)
        } catch let error{
            print(error)
        }
    }
    
    func update(value: String?, forKey key: String){
        let obj = settingsTable.filter(Key == key)
        let update = obj.update(Value <- value)
        do{
            try db?.run(update)
        } catch let error{
            print(error)
        }
    }
    
    func save(value: String?, forKey key: String) {
        if self.getValueBy(key: key) ==  "" {
            let insert = settingsTable.insert(Key <- key, Value <- value)
            do{
                try db?.run(insert)
            } catch let error{
                print(error)
            }
        } else {
            let obj = settingsTable.filter(Key == key)
            let update = obj.update(Value <- value)
            do{
                try db?.run(update)
            } catch let error{
                print(error)
            }
        }
    }
    
    func deleteValueFor(key: String){
        let obj = settingsTable.filter(Key == key)
        do{
            try db?.run(obj.delete())
        } catch let error{
            print(error)
        }
    }
    
    func deleteAll(){
        do{
            try db?.run(settingsTable.delete())
        } catch let error{
            print(error)
        }
    }
    
    func getValueBy(key: String) -> String{
        let obj = settingsTable.filter(Key == key)
        do{
            for objRow in try db!.prepare(obj) {
                return objRow[Value] ?? ""
            }
        }catch let error{
            print(error)
        }
        return ""
    }
}

