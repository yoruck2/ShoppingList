//
//  addButton.swift
//  ShoppingList
//
//  Created by dopamint on 5/26/24.
//

import UIKit

final class AddProductButton: UIButton {
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if self.isHighlighted == true {
                backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9137254902, alpha: 1)
                super.isHighlighted = newValue
            } else {
                backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7960784314, alpha: 1)
                super.isHighlighted = newValue
            }
        }
    }
}
