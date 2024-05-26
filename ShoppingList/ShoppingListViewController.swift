//
//  ViewController.swift
//  ShoppingList
//
//  Created by dopamint on 5/25/24.
//

import UIKit

class ShoppingListViewController: UITableViewController {
    
    let jsonParser = JSONParser()
    let userDefaults = UserDefaults.standard
    var shoppingList: [Product] = []

    @IBOutlet var addProductTextField: UITextField!
    @IBOutlet var addProductButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderTopPadding = 0
        setUpAddProductTextField()
        setUpAddProductButton()
        shoppingList = jsonParser.readUserDefaults()
        
        // 첫 실행 판별
        let launchedBefore = userDefaults.bool(forKey: "launchedBefore")
        if launchedBefore == false {
            shoppingList.append(Product(name: "살 것을 추가해 주세요!", isChecked: true, isGetStar: false))
            jsonParser.saveUserDefaults(shoppingList)
            userDefaults.set(true, forKey: "launchedBefore")
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: 왜안되는거야!!!!
        jsonParser.saveUserDefaults(shoppingList)
        print("하잇")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    @IBAction func addProductButtonTapped(_ sender: UIButton) {
        guard let text = addProductTextField.text, text != "" else {
            return
        }
        shoppingList.append(Product(name: text))
        addProductTextField.text = ""
        jsonParser.saveUserDefaults(shoppingList)
        
        print(userDefaults.object(forKey: "shoppingList")!)
        print(jsonParser.readUserDefaults())
        
        self.tableView.insertRows(at: [IndexPath.init(row: shoppingList.count-1, section: 0)], with: .automatic)
    }
    
    @IBAction func preventEmptyName(_ sender: UITextField) {
        if sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            sender.text = ""
        }
    }
    @IBAction func cellTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func returnKeyTapped(_ sender: UITextField) {
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        let resetAlert = UIAlertController(title: "⚠️",
                                           message: "\n리스트를 초기화 할래요?",
                                           preferredStyle: .alert)
        let confirm = UIAlertAction(title: "네",
                                    style: .destructive) { [self] action in
            shoppingList.removeAll()
            userDefaults.removeObject(forKey: "shoppingList")
            tableView.reloadData()
        }
        let deny = UIAlertAction(title: "아니요",style: .cancel)
        
        resetAlert.addAction(confirm)
        resetAlert.addAction(deny)
        present(resetAlert, animated: true)
    }
    
    
    
    func setUpAddProductTextField() {
        addProductTextField.layer.cornerRadius = 13
        addProductTextField.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1.00)
        addProductTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        addProductTextField.leftViewMode = .always
    }
    
    func setUpAddProductButton() {
        addProductButton.layer.cornerRadius = 10
        addProductButton.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.914, alpha: 1.00)
        addProductButton.setTitleColor(.red, for: .highlighted)
    }
    
    @objc
    func checkButtonTapped(sender: UIButton) {
        shoppingList[sender.tag].isChecked.toggle()
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }
    @objc
    func starButtonTapped(sender: UIButton) {
        shoppingList[sender.tag].isGetStar.toggle()
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }

}

extension ShoppingListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListCell.identifier,
                                                       for: indexPath) as? ShoppingListCell
        else {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ShoppingListCell.identifier,
                                                                            for: indexPath)
            cell.textLabel?.text = "내용을 불러오는데 실패했습니다."
            return cell
        }
        cell.setUpCell()
        
        cell.checkButton.tag = indexPath.row
        cell.starButton.tag = indexPath.row
        
        cell.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        cell.starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
        cell.checkButton.isSelected = shoppingList[indexPath.row].isChecked
        cell.starButton.isSelected = shoppingList[indexPath.row].isGetStar
        
        cell.shoppingListCellLabel.text = self.shoppingList[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("삭제 클릭 됨")
            
            self.shoppingList.remove(at: indexPath.row)
            success(true)
            
            // deleteRows만 하면 tag 업데이트가 안되서 삭제 이후의 셀들과 shoppingList의 인덱스가 불일치됨..
            // reloadData만 하면 애니메이션이 없다
            
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            self.tableView.reloadData()
            
            self.jsonParser.saveUserDefaults(self.shoppingList)
        }
        delete.backgroundColor = .systemRed
        
        
        return UISwipeActionsConfiguration(actions:[delete])
    }
    
    
}

