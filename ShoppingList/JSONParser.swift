//
//  JSONParser.swift
//  ShoppingList
//
//  Created by dopamint on 5/26/24.
//

import Foundation

struct JSONParser {
    
    func saveUserDefaults(_ sender: [Product]) {
        let encoder: JSONEncoder = JSONEncoder()
    
        if let shoppingList = try? encoder.encode(sender) {
            UserDefaults.standard.set(shoppingList, forKey: "shoppingList")
            print("Save")
        }
    }
    
    func readUserDefaults() -> [Product] {
        let decoder: JSONDecoder = JSONDecoder()
        if let result = UserDefaults.standard.object(forKey: "shoppingList") as? Data,
           let shoppingList = try? decoder.decode([Product].self, from: result) {
            return shoppingList
        }
        return []
    }
}
