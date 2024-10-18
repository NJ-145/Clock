//
//  AddAlarmViewController.swift
//  Clock
//
//  Created by imac-2626 on 2024/9/26.
//

import UIKit
import RealmSwift

class AddAlarmViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet var tbvInformation: UITableView!
    @IBOutlet var dpkClockTime: UIDatePicker!
    
    
    // MARK: - Property
    var selectedWeekText: String = "永不" // 初始顯示為 "永不"
    var wek: [String] = []
    var soundData : String = sound_value.shared.select
    var selectedSound: String = "放射(預設值)"
    static var reminderLater: Bool = true
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        tbvInformation.reloadData()
        setNavigation()
        setUi()
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
        
        tbvInformation.layer.cornerRadius = 15 // 設定圓角
        tbvInformation.layer.masksToBounds = true
        tbvInformation.backgroundColor = UIColor.lightGray
    }
    
    
    // MARK: - IBAction
    
    @IBAction func datePicker(_ sender: Any) {
        
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
        
    }
    
    // dismiss關閉,返回到之前的畫面
    @objc func backToMain() {
        dismiss(animated: true, completion: nil)
    }
    
    func formattedCurrentDate() -> String {
        let currentData = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: currentData)
    }
}

// MARK: - Extensions
extension AddAlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch indexPath.row {
        case 0:
            let repeatCell = tableView.dequeueReusableCell(withIdentifier: RepeatTableViewCell.identifier, for: indexPath) as! RepeatTableViewCell
            repeatCell.textLabel?.text = "重複"
            // 顯示選擇的星期文字
            repeatCell.lbData.text = selectedWeekText
            repeatCell.lbData.adjustsFontSizeToFitWidth = true
            // 顯示箭頭
            repeatCell.accessoryType = .disclosureIndicator
            return repeatCell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: TagTableViewCell.identifier,
                                                 for: indexPath) as! TagTableViewCell
            cell?.textLabel?.text = "標籤"
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: RepeatTableViewCell.identifier,
                                                     for: indexPath) as! RepeatTableViewCell
            cell.textLabel?.text = "提示聲"
            cell.lbData.text = soundData
            // 從單例讀取選中的聲音
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: RemLatTableViewCell.identifier,
                                                 for: indexPath) as! RemLatTableViewCell
            cell.textLabel?.text = "稍後提醒"
            if AddAlarmViewController.reminderLater {
                cell.swReminderLater.isOn = true
            } else {
                cell.swReminderLater.isOn = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 跳轉到 WeekViewController
            let weekVC = WeekViewController()
            weekVC.updateDelegate = self // 設置代理
            weekVC.selectWeek = self.wek
            self.navigationController?.pushViewController(weekVC, animated: true)
        }
        if indexPath.row == 2 {
            let soundVC = SoundViewController()
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
