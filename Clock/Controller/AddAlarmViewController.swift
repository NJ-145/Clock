//
//  AddAlarmViewController.swift
//  Clock
//
//  Created by imac-2626 on 2024/9/26.
//

import UIKit
import RealmSwift
import UserNotifications

class AddAlarmViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet var tbvInformation: UITableView!
    @IBOutlet var dpkClockTime: UIDatePicker!
    
    @IBOutlet var btnDelete: UIButton!
    
    // MARK: - Property
    var selectedWeekText: String = "永不" // 初始顯示為""
    var wek: [String] = []
    var soundData : String = sound_value.shared.select
    var selectedSound: String = "放射"
    static var reminderLater: Bool = true
    var tagName: String = "鬧鐘"
    weak var delegate: AddAlarmViewControllerDelegate?
    var alarmTime: Date?
    // 用來判斷是否為編輯模式
    var isEditingMode: Bool = false
    // 編輯模式下的鬧鐘資料
    var editingAlarm: ClockTime?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        tbvInformation.reloadData()
        setNavigation()
        setUi()
        editMode()
    }
    
    // 收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - UI Settings
    func setUi() {
        dpkClockTime.datePickerMode = .time
        dpkClockTime.minuteInterval = 1
        dpkClockTime.date = Date()
        dpkClockTime.locale = Locale(identifier: "zh_TW")
        dpkClockTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        tbvInformation.register(UINib(nibName: "RepeatTableViewCell", bundle: nil),
                                forCellReuseIdentifier: RepeatTableViewCell.identifier)
        tbvInformation.register(UINib(nibName: "TagTableViewCell", bundle: nil),
                                forCellReuseIdentifier: TagTableViewCell.identifier)
        tbvInformation.register(UINib(nibName: "RemLatTableViewCell", bundle: nil),
                                forCellReuseIdentifier: RemLatTableViewCell.identifier)
        tbvInformation.delegate = self
        tbvInformation.dataSource = self
        
        tbvInformation.layer.cornerRadius = 10 // 設定圓角
        tbvInformation.layer.masksToBounds = true
        tbvInformation.backgroundColor = UIColor.lightGray
        
        // 設定刪除按鈕的圓角和背景色
        btnDelete.layer.cornerRadius = 10 // 設置圓角半徑
        btnDelete.layer.masksToBounds = true // 確保圓角有效果
        btnDelete.backgroundColor = UIColor.darkGray
    }
    
    
    // MARK: - IBAction
    
    @IBAction func datePicker(_ sender: Any) {
        
    }
    
    
    @IBAction func deletePressed(_ sender: Any) {
        guard isEditingMode, let alarmToDelete = editingAlarm else { return }
        
        let realm = try! Realm()
        try! realm.write {
            realm.delete(alarmToDelete) // 刪除指定的鬧鐘
        }
        
        delegate?.didSaveAlarm() // 通知主頁面更新
        dismiss(animated: true, completion: nil) // 關閉當前頁面
    }
    
    // MARK: - Function
    func setNavigation() {
        self.title = "加入鬧鐘"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1669761635, green: 0.1807887411, blue: 0.2008549854, alpha: 1)
        let btnCancel = UIBarButtonItem(title: "取消",
                                        style: .plain,
                                        target: self,
                                        action: #selector(backToMain))
        btnCancel.tintColor = .orange
        self.navigationItem.leftBarButtonItem = btnCancel
        
        let btnSave = UIBarButtonItem(title: "儲存",
                                      style: .plain,
                                      target: self,
                                      action: #selector(saveAlarm))
        btnSave.tintColor = .orange
        self.navigationItem.rightBarButtonItem = btnSave
    }
    
    @objc func saveAlarm() {
        let realm = try! Realm()
        let identifier: String
        
        // 使用 DatePicker 選擇的時間格式化為字串
        let selectedTimeString = formattedCurrentDate(from: dpkClockTime.date)
        
        if isEditingMode, let alarmToUpdate = editingAlarm {
            // 編輯模式：更新現有資料
            identifier = "\(alarmToUpdate.clockTime)-\(alarmToUpdate.clockTag)"// 假設 `id` 是鬧鐘的唯一標識符，例如 UUID
            
            try! realm.write {
                alarmToUpdate.clockPeriod = formatDate(dpkClockTime.date)
                alarmToUpdate.clockTime = selectedTimeString
                alarmToUpdate.clockRepeat = selectedWeekText
                alarmToUpdate.clockTag = tagName
                alarmToUpdate.clockSound = selectedSound
                alarmToUpdate.clockRemLat = AddAlarmViewController.reminderLater
            }
            
            // 移除舊的通知
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            
        } else {
            // 新增模式：創建新的鬧鐘物件
            identifier = UUID().uuidString // 為新鬧鐘生成唯一的 ID
            let newAlarm = ClockTime(clockPeriod: formatDate(dpkClockTime.date),
                                     clockTime: selectedTimeString,
                                     clockRepeat: selectedWeekText,
                                     clockTag: tagName,
                                     clockSound: selectedSound,
                                     clockRemLat: AddAlarmViewController.reminderLater)
            
            try! realm.write {
                realm.add(newAlarm)
            }
            selectedSound = "放射"
            sound_value.shared.select = selectedSound // 同步單例的預設值
            
            selectedWeekText = "永不"
            day_value.shared.select = []
            
        }
        
        // 通知主頁面更新鬧鐘列表
        delegate?.didSaveAlarm()
        dismiss(animated: true, completion: nil)
        
        // 僅為當前鬧鐘創建通知
        createNotification(for: identifier, time: dpkClockTime.date)
    }

    
    // dismiss關閉,返回到之前的畫面
    @objc func backToMain() {
        selectedWeekText = "永不"
        day_value.shared.select = []
        dismiss(animated: true, completion: nil)
    }
    
    func formattedCurrentDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm" // 設定所需的時間格式
        return dateFormatter.string(from: date)
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_TW")
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: date)
    }
    
    func editMode() {
        // 根據編輯模式設定刪除按鈕的顯示狀態和標題文字
        btnDelete.isHidden = !isEditingMode // 若非編輯模式，隱藏刪除按鈕
        self.title = isEditingMode ? "編輯鬧鐘" : "加入鬧鐘" // 編輯模式顯示「編輯鬧鐘」
        
        // 編輯模式使用 alarmTime 更新時間
        if isEditingMode, let alarm = editingAlarm {
            // 編輯模式：將當前鬧鐘的資訊顯示在表格中
            tagName = alarm.clockTag
            selectedWeekText = alarm.clockRepeat
            selectedSound = alarm.clockSound // 設定為當前鬧鐘的提示聲
            tbvInformation.reloadData()
            
            // 設置鬧鐘的時間
            if let alarmTime = alarmTime {
                dpkClockTime.date = alarmTime // 使用編輯鬧鐘的時間
            }
        } else {
            // 新增模式：使用初始化的值
            selectedSound = "放射" // 預設值
            
            // 新增模式：設置為「永不」並清空 day_value.shared.select
            selectedWeekText = "永不"
            //day_value.shared.select.removeAll()
            
            dpkClockTime.date = Date() // 新增模式下設置為當前時間
        }
    }

    
    // 通知
    func createNotification(for identifier: String, time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "現在時間"
        content.subtitle = "\(formattedCurrentDate(from: time))"
        content.body = ""
        content.badge = 1
        content.sound = .default

        // 從 time 取得小時與分鐘的 DateComponents
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        print(components)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("無法建立通知: \(error)")
            } else {
                print("通知成功排程：\(self.formattedCurrentDate(from: time))")
                
                // 發送通知更新主畫面
                NotificationCenter.default.post(name: NSNotification.Name("SwitchStateUpdate"), object: nil)
            }
        }
    }
}

// MARK: - Extensions
extension AddAlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let repeatCell = tableView.dequeueReusableCell(withIdentifier: RepeatTableViewCell.identifier, for: indexPath) as! RepeatTableViewCell
            repeatCell.textLabel?.text = "重複"
            repeatCell.textLabel?.textColor = .white
            repeatCell.lbData.textColor = .lightGray
            // 顯示選擇的星期文字
            repeatCell.lbData.text = selectedWeekText
            repeatCell.lbData.adjustsFontSizeToFitWidth = true
            // 顯示箭頭
            repeatCell.accessoryType = .disclosureIndicator
            repeatCell.backgroundColor = UIColor.darkGray
            return repeatCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TagTableViewCell.identifier,for: indexPath) as! TagTableViewCell
            cell.textLabel?.text = "標籤"
            cell.textLabel?.textColor = .white
            cell.txfTag.delegate = self
            cell.txfTag.text = tagName
            cell.txfTag.textColor = .lightGray
            print(tagName)
            cell.backgroundColor = UIColor.darkGray
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: RepeatTableViewCell.identifier,for: indexPath) as! RepeatTableViewCell
            cell.textLabel?.text = "提示聲"
            cell.textLabel?.textColor = .white
            cell.lbData.textColor = .lightGray
            cell.lbData.text = selectedSound
            // 從單例讀取選中的聲音
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.darkGray
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: RemLatTableViewCell.identifier, for: indexPath) as! RemLatTableViewCell
            cell.textLabel?.text = "稍後提醒"
            cell.textLabel?.textColor = .white
            cell.updateSwitchState(isOn: AddAlarmViewController.reminderLater)
            cell.backgroundColor = UIColor.darkGray
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("www")
        if indexPath.row == 0 {
            // 跳轉到 WeekViewController
            let weekVC = WeekViewController()
            weekVC.updateDelegate = self // 設置代理
            weekVC.selectWeek = self.wek
            self.navigationController?.pushViewController(weekVC, animated: true)
        }
        if indexPath.row == 2 {
            let soundVC = SoundViewController()
            soundVC.check = selectedSound
            soundVC.delegate = self
            self.navigationController?.pushViewController(soundVC, animated: true)
        }
    }
}

extension AddAlarmViewController: Updatedelegate, SoundSelectionDelegate {
    func didSelectSound(sound: String) {
        soundData = sound
        selectedSound = sound
        tbvInformation.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
    }
    
    func updateWeek(week: [String]) {
        wek = week
        let weekdays = ["星期一", "星期二", "星期三", "星期四", "星期五"]
        let weekends = ["星期六", "星期日"]
        
        // 判斷是否選中所有星期
        if week.count == 7 {
            selectedWeekText = "每天"
        }
        // 判斷選中平日
        else if Set(week).isSubset(of: weekdays) && week.count == weekdays.count {
            selectedWeekText = "平日"
        }
        // 判斷選中週末
        else if Set(week).isSubset(of: weekends) && week.count == weekends.count {
            selectedWeekText = "週末"
        }
        // 判斷是否未選中任何星期
        else if week.isEmpty {
            selectedWeekText = "永不"
        }
        else {
            selectedWeekText = week.joined(separator: " ")
        }
        // 更新 tableView 的顯示
        tbvInformation.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        //wek = week
    }
    
}

class reminderLater_switch {
    var reminderLater_select = true
    static let shared = reminderLater_switch()
    private init() {}
}

// MARK: - Protocol
protocol AddAlarmViewControllerDelegate: AnyObject {
    func didSaveAlarm()
}

extension AddAlarmViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        tagName = textField.text!
        print(tagName)
    }
}
