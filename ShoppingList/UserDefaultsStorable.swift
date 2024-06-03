//
//  JSONParser.swift
//  ShoppingList
//
//  Created by dopamint on 5/26/24.
//

import Foundation

protocol UserDefaultsStorable<T> {
    
    associatedtype T
    
    func saveShoppingList(_ data: T)
    func readShoppingList() -> T
    func removeAllShoppingList()
}

//extension UserDefaults: Asd {
//    
//    static func saveUserDefaults(_ data: [Product]) {
//        let encoder: JSONEncoder = JSONEncoder()
//    
//        if let shoppingList = try? encoder.encode(data) {
//            UserDefaults.standard.set(shoppingList, forKey: "shoppingList")
//            print("Saved")
//        }
//    }
//    
//    static func readUserDefaults() -> [Product] {
//        let decoder: JSONDecoder = JSONDecoder()
//        if let result = UserDefaults.standard.object(forKey: "shoppingList") as? Data,
//           let shoppingList = try? decoder.decode([Product].self, from: result) {
//            return shoppingList
//        }
//        return []
//    }
//}
