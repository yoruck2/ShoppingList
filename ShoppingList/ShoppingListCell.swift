//
//  ShoppingListCell.swift
//  ShoppingList
//
//  Created by dopamint on 5/25/24.
//

import UIKit

final class ShoppingListCell: UITableViewCell {
    
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var starButton: UIButton!
    @IBOutlet var shoppingListCellLabel: UILabel!
    @IBOutlet var shoppingListCellView: UIView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setUpCell() {
        self.shoppingListCellView.layer.cornerRadius = 10
        self.shoppingListCellView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.selectionStyle = .none
        setUpCheckButton()
        setUpStarButton()
    }
    
    func setUpCheckButton() {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 8
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkButton.tintColor = .black
        checkButton.configuration = buttonConfiguration
    }
    
    func setUpStarButton() {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 8
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        starButton.tintColor = .black
        starButton.configuration = buttonConfiguration
    }
}
