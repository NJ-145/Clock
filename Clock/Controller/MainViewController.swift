//
//  MainViewController.swift
//  Clock
//
//  Created by imac-2626 on 2024/9/23.
//

import UIKit
import RealmSwift
import UserNotifications

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet var tbvTime: UITableView!
    // MARK: - Property
    var clockArray: [ClockTime] = []
    var selectedAlarm: ClockTime?
    // 假設 clockTime 是 Date? 型別
    var clockTime: Date?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setUi()
        //createNotification()
        
        self.title = "鬧鐘"
        // 啟用大型標題
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        // 建立 UINavigationBarAppearance 來自定義標題顏色
        let appearance = UINavigationBarAppearance()
        //appearance.configureWithOpaqueBackground() // 設定背景為不透明
        appearance.backgroundColor = UIColor.black // 設定背景顏色
        // 設定小標題的顏色與字體
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white, // 設定小標題文字顏色為紅色
            .font: UIFont.systemFont(ofSize: 17)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white, // 設定大型標題文字顏色為藍色
            .font: UIFont.boldSystemFont(ofSize: 34)
        ]
        // 套用設定
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        // 設定為自動模式，允許往上滑動時縮小標題
        //self.navigationItem.largeTitleDisplayMode = .automatic
        
    }
    
    // MARK: - UI Settings
    func setUi() {
        view.backgroundColor = UIColor.black
        tbvTime.backgroundColor = UIColor.black
        tbvTime.separatorColor = .gray
        tbvTime.register(UINib(nibName: "ClockTableViewCell", bundle: nil), forCellReuseIdentifier: ClockTableViewCell.identifier)
        tbvTime.register(UINib(nibName: "SleepTableViewCell", bundle: nil), forCellReuseIdentifier: SleepTableViewCell.identifier)
        tbvTime.register(UINib(nibName: "SleepClockTableViewCell", bundle: nil), forCellReuseIdentifier: SleepClockTableViewCell.identifier)
        tbvTime.register(UINib(nibName: "OtherTableViewCell", bundle: nil), forCellReuseIdentifier: OtherTableViewCell.identifier)
        tbvTime.delegate = self
        tbvTime.dataSource = self
        
        
        let realm = try! Realm()
        let clock_Time = realm.objects(ClockTime.self)
        for clock in clock_Time {
            clockArray.append(clock)
        }
        // 將 DateFormatter 放在排序內
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm" // 設定格式包含上午下午
        dateFormatter.locale = Locale(identifier: "zh_TW") // 設定繁體中文地區
        clockArray.sort {
            guard let time1 = dateFormatter.date(from: $0.clockPeriod + " " + $0.clockTime),
                  let time2 = dateFormatter.date(from: $1.clockPeriod + " " + $1.clockTime) else {
                return false
            }
            return time1 < time2
        }
        print("file: \(realm.configuration.fileURL!)")
    }
    
    // MARK: - IBAction
    
    //    @IBAction func jumpToSecond(_ sender: Any) {
    //        let nextVC = SecondViewController()
    //        nextVC.delegate = self
    //        nextVC.b = a
    //        self.present(nextVC, animated: true, completion: nil)
    //    }
    
    // MARK: - Function
    func setNavigation() {
        let btnEdit = UIBarButtonItem(title: "編輯",
                                      style: .plain,
                                      target: self,
                                      action: #selector(editAlarm))
        btnEdit.tintColor = .orange
        self.navigationItem.leftBarButtonItem = btnEdit
        let btnAdd = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(addAlarm))
        btnAdd.tintColor = .orange
        self.navigationItem.rightBarButtonItem = btnAdd
    }
    
    @objc func editAlarm() {
        isEditing.toggle()
        tbvTime.setEditing(isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title = isEditing ? "完成" : "編輯"
    }
    
    // present畫面下往上跳出來
    // 將「vc」這個畫面從下往上跳出來,並且要有動畫,跳出來後不執行任何動作
    @objc func addAlarm() {
        let vc = AddAlarmViewController()
        let nv = UINavigationController(rootViewController: vc)
        // 設置 delegate
        vc.delegate = self
        present(nv, animated: true, completion: nil)
    }
    
    }

// MARK: - Extensions

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 設定哪些 cell 可以進行編輯
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // 僅允許編輯第四個 cell 以後的行（即 index >= 3 的行）
        return indexPath.row >= 3
    }
    
    // 設定每個 cell 的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 55 // 第一個 cell 設定高度為 100
        case 1:
            return 55 // 第二個 cell 設定高度為 80
        case 2:
            return 55 // 第三個 cell 設定高度為 60
        default:
            return 100 // 其餘的鬧鐘 cell 設定高度為 70
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + clockArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SleepTableViewCell.identifier, for: indexPath) as! SleepTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SleepClockTableViewCell.identifier, for: indexPath) as! SleepClockTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: OtherTableViewCell.identifier, for: indexPath) as! OtherTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ClockTableViewCell.identifier, for: indexPath) as! ClockTableViewCell
            let clockIndex = indexPath.row - 3 // 確保扣除前三行
            
            if clockIndex < clockArray.count {
                cell.lbPeriod.text = clockArray[clockIndex].clockPeriod
                cell.lbTime.text = clockArray[clockIndex].clockTime
                let clockTag = clockArray[clockIndex].clockTag
                // let clockRepeat = clockArray[clockIndex].clockRepeat
                // 判斷 clockRepeat 是否為「永不」，僅在非「永不」的情況下顯示 clockRepeat
                let clockRepeat = clockArray[clockIndex].clockRepeat == "永不" ? "" : clockArray[clockIndex].clockRepeat
                cell.lbRemark.text = "\(clockTag)\(clockRepeat.isEmpty ? "" : ", \(clockRepeat)")"
                
                // 將這兩個數值轉換成字串並用逗號隔開
                // cell.lbRemark.text = "\(clockTag), \(clockRepeat)"
                cell.backgroundColor = UIColor.black
                cell.lbPeriod.textColor = UIColor.white
                cell.lbTime.textColor = UIColor.white
                cell.lbRemark.textColor = UIColor.white
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row >= 3 else { return } // 前三個 cell 不執行以下代碼
        let clockIndex = indexPath.row - 3 // 扣除前三行
        guard clockIndex < clockArray.count else { return }
        
        let vc = AddAlarmViewController()
        let alarm = clockArray[clockIndex]
        vc.tagName = alarm.clockTag
        vc.selectedWeekText = alarm.clockRepeat
        vc.selectedSound = alarm.clockSound
        
        
        // 使用 DateFormatter 將 String 轉成 Date 型別
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        if let alarmDate = dateFormatter.date(from: alarm.clockTime) {
            vc.alarmTime = alarmDate
        }
        
        // 分析 clockRepeat 並設定選擇的日期
        switch alarm.clockRepeat {
        case "每天":
            day_value.shared.select = [0, 1, 2, 3, 4, 5, 6] // 每天
        case "平日":
            day_value.shared.select = [1, 2, 3, 4, 5] // 星期一到五
        case "週末":
            day_value.shared.select = [0, 6] // 星期日和星期六
        case let repeatDays where repeatDays.contains("星期"):
            // 根據 clockRepeat 解析出包含的星期
            let weekMapping = ["星期日": 0, "星期一": 1, "星期二": 2, "星期三": 3, "星期四": 4, "星期五": 5, "星期六": 6]
            day_value.shared.select = repeatDays
                .split(separator: " ")
                .compactMap { weekMapping[String($0)] }
        default:
            day_value.shared.select = [] // 默認清空選擇
        }
        
        vc.isEditingMode = true // 標記為編輯模式
        vc.editingAlarm = alarm // 傳遞編輯的鬧鐘物件
        vc.delegate = self
        
        
        
        let vcroot = UINavigationController(rootViewController: vc)
        navigationController?.present(vcroot, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            // 取得要刪除的鬧鐘物件
            let realm = try! Realm()
            let alarmToDelete = self.clockArray[indexPath.row - 3]
            
            // 在 Realm 中刪除該鬧鐘物件
            try! realm.write {
                realm.delete(alarmToDelete)
            }
            
            // 更新資料來源 array 並從畫面上刪除
            self.clockArray.remove(at: indexPath.row - 3)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MainViewController: AddAlarmViewControllerDelegate {
    func didSaveAlarm() {
        // 重新讀取 Realm 資料
        let realm = try! Realm()
        let clock_Time = realm.objects(ClockTime.self)
        
        // 將資料轉換為 array 並進行排序
        clockArray = Array(clock_Time)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.locale = Locale(identifier: "zh_TW")
        
        clockArray.sort {
            guard let time1 = dateFormatter.date(from: $0.clockPeriod + " " + $0.clockTime),
                  let time2 = dateFormatter.date(from: $1.clockPeriod + " " + $1.clockTime) else {
                return false
            }
            return time1 < time2
        }
        
        // 重新載入 tableView
        tbvTime.reloadData()
    }
}


