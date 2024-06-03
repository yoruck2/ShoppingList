//
//  ViewController.swift
//  ShoppingList
//
//  Created by dopamint on 5/25/24.
//

import UIKit

final class ShoppingListViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    var shoppingList: [Product] = [] {
        didSet {
            saveShoppingList(shoppingList)
        }
    }

    @IBOutlet var addProductTextField: UITextField!
    @IBOutlet var addProductButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderTopPadding = 0
        validateFirstLaunching()
        setUpAddProductTextField()
        setUpAddProductButton()
        shoppingList = readShoppingList()
        
    }
    
    // 첫 실행 판별
    func validateFirstLaunching() {
        let launchedBefore = userDefaults.bool(forKey: "launchedBefore")
        if launchedBefore == false {
            shoppingList.append(Product(name: "살 것을 추가해 주세요!", isChecked: true, isGetStar: false))
            userDefaults.set(true, forKey: "launchedBefore")
        }
    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        // TODO: 왜안되는거야!!!!
//        saveShoppingList(shoppingList)
//        print("하잇")
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print(#function)
//    }
    // MARK: - 상품 추가 버튼 로직
    @IBAction func addProductButtonTapped(_ sender: UIButton) {
        guard let text = addProductTextField.text, text != "" else {
            return
        }
        shoppingList.append(Product(name: text))
        addProductTextField.text = ""
        
        self.tableView.insertRows(at: [IndexPath.init(row: shoppingList.count-1, section: 0)], with: .automatic)
    }
    
    // MARK: - 초기화 버튼 로직
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        let resetAlert = UIAlertController(title: "⚠️",
                                           message: "\n리스트를 초기화 할래요?",
                                           preferredStyle: .alert)
        let confirm = UIAlertAction(title: "네",
                                    style: .destructive) { [self] action in
            shoppingList.removeAll()
            removeAllShoppingList()
            tableView.reloadData()
        }
        let deny = UIAlertAction(title: "아니요",style: .cancel)
        
        resetAlert.addAction(confirm)
        resetAlert.addAction(deny)
        present(resetAlert, animated: true)
    }
    
    // MARK: - 공백등록 방지 / 키보드 dimiss
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
    
    // MARK: - 셀 버튼 로직
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
    
    // MARK: - 레이아웃
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
}

// MARK: - 테이블뷰 메서드
extension ShoppingListViewController {
    
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
        let delete = UIContextualAction(style: .normal, title: "삭제") { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            shoppingList.remove(at: indexPath.row)
            success(true)
            
            // deleteRows만 하면 tag 업데이트가 안되서 삭제 이후의 셀들과 shoppingList의 인덱스가 불일치됨..
            // reloadData만 하면 애니메이션이 없다
            
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
            tableView.reloadData()
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions:[delete])
    }
}

// MARK: - 리스트 저장 기능
extension ShoppingListViewController: UserDefaultsStorable {
    
    func removeAllShoppingList() {
        UserDefaults.standard.removeObject(forKey: "shoppingList")
    }
    
    func saveShoppingList(_ data: [Product]) {
        let encoder: JSONEncoder = JSONEncoder()
    
        if let shoppingList = try? encoder.encode(data) {
            userDefaults.set(shoppingList, forKey: "shoppingList")
            print("Saved")
        }
    }
    
    func readShoppingList() -> [Product] {
        let decoder: JSONDecoder = JSONDecoder()
        if let result = userDefaults.object(forKey: "shoppingList") as? Data,
           let shoppingList = try? decoder.decode([Product].self, from: result) {
            return shoppingList
        }
        return []
    }
}
