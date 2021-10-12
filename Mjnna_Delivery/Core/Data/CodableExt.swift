//
//  CodableExt.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation

extension Encodable {
    func encode() -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try? encoder.encode(self)
    }
    
    func toString() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
                
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        return nil
    }
    
}

extension Sequence {
    func getData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
    func getObject<T: Decodable>() -> T? {
        guard
            let data = self.getData() else { return nil }
        return data.getObject()
    }
}

extension UserDefaults {
    func saveObject<T: Codable>(rawData: T, forKey key: String) {
        do {
            let encoded = try JSONEncoder().encode(rawData)
            UserDefaults.standard.set(encoded, forKey: key)
        }
        catch {
            print(error)
        }
    }
    
    func getObject<T: Decodable>(key: String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return data.getObject()
    }
}

extension Data {
    func getObject<T: Decodable>() -> T? {
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let parsedData = try decoder.decode(T.self, from: self)
            return parsedData
        }
        catch {
            print(error)
        }
        return nil
    }
}


extension String {
    func toObject<T: Decodable>() -> T? {
        do {
            let decoder = JSONDecoder()
            let jsonData = self.data(using: .utf8)!
            let parsedData = try decoder.decode(T.self, from: jsonData)
            return parsedData
        }
        catch {
            print(error)
        }
        return nil
    }
    
    func toDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print(error)
            }
        }
        return nil
    }
    
}
