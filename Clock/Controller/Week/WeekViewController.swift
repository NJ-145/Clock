//
//  WeekViewController.swift
//  Clock
//
//  Created by imac-2626 on 2024/10/7.
//

import UIKit

class WeekViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var tbvWeek: UITableView!
    
    // MARK: - Property
    let week: [String] = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    /// selectedWeeks
    var selectedWeeks: [Bool] = Array(repeating: false, count: 7)
    weak var updateDelegate: Updatedelegate?
    var selectWeek: [String] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setUi()
        
        // 初始化 selectedWeeks 根據 day_value.shared.select 的內容
        for index in day_value.shared.select {
            selectedWeeks[index] = true
        }
    }
    
    // MARK: - UI Settings
    func setUi() {
        tbvWeek.register(UINib(nibName: "WeekTableViewCell", bundle: nil),
                         forCellReuseIdentifier: WeekTableViewCell.identifier)
        tbvWeek.delegate = self
        tbvWeek.dataSource = self
        
        tbvWeek.layer.cornerRadius = 15 // 設定圓角
        tbvWeek.layer.masksToBounds = true
        tbvWeek.backgroundColor = UIColor.lightGray
    }
    
    // MARK: - Function
    func setNavigation() {
        self.title = "重複"
        let btnBack = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(backToAdd))
        btnBack.tintColor = .orange
        self.navigationItem.leftBarButtonItem = btnBack
    }
    
    @objc func backToAdd() {
        navigationController?.popViewController(animated: true)
        updateDelegate?.updateWeek(week: selectWeek)
        
    }
}

// MARK: - Extensions
extension WeekViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeekTableViewCell.identifier, for: indexPath) as! WeekTableViewCell
        let week = week[indexPath.row] // 根據索引取得對應的星期
        cell.lbWeek.text = week // 顯示星期的名稱
        
        // 根據 day_value.shared.select 這個陣列的內容來判斷是否在該列（indexPath.row）顯示打勾
        if day_value.shared.select.contains(indexPath.row) {
            cell.accessoryType = .checkmark // 已選中
        } else {
            cell.accessoryType = .none // 未選中
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if day_value.shared.select.contains(indexPath.row) {
            day_value.shared.select = day_value.shared.select.filter{$0 != indexPath.row}
        } else {
            day_value.shared.select.append(indexPath.row)
        }
        day_value.shared.select.sort(by: <)
        //tableView.reloadRows(at: [indexPath], with: .automatic)
        
        // 更新選中的星期
        selectWeek = day_value.shared.select.compactMap { index in
            return week[index]
        }
        print(selectWeek)
        tableView.reloadRows(at: [indexPath], with: .automatic) // 重新載入被選中的 cell
    }
}

// MARK: - Protocol
protocol Updatedelegate: AnyObject{
    func updateWeek(week: [String])
}


