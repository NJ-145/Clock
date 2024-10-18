//
//  MainViewController.swift
//  Clock
//
//  Created by imac-2626 on 2024/9/23.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet var tbvTime: UITableView!
    // MARK: - Property
    //    var a = 1
    //    var str : String?
    var clockArray: [ClockTime] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setUi()
    }
    
    // MARK: - UI Settings
    func setUi() {
        view.backgroundColor = UIColor.black
        tbvTime.backgroundColor = UIColor.black
        
//        let realm = try! Realm()
//        let clock_Time = realm.objects(ClockTime.self)
//        for clock in clock_Time {
//            clockArray.append(clock)
//        }
//        print("file: \(realm.configuration.fileURL!)")
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
        
    }
    
    // present畫面下往上跳出來
    // 將「vc」這個畫面從下往上跳出來,並且要有動畫,跳出來後不執行任何動作
    @objc func addAlarm() {
        let vc = AddAlarmViewController()
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true, completion: nil)
    }
    
    
}
// MARK: - Extensions
//extension MainViewController: SecondViewDelegate{
//    func sentReturn(data: String) {
//        str = data
//        print("str:值\(str)")
//    }
//}

