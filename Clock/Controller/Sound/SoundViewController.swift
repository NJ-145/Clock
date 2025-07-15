//
//  SoundViewController.swift
//  Clock
//
//  Created by imac-2626 on 2024/10/15.
//

import UIKit

class SoundViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var tbvSound: UITableView!
    
    // MARK: - Property
    let sound: [String] = ["放射(預設值)","小木屋","山谷","水銀","四方","幼苗","庇護"]
    var check: String = sound_value.shared.select
    weak var delegate: SoundSelectionDelegate?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
        setNavigation()
        
        // 檢查 check 是否有值，如果沒有，將其初始化為「放射(預設值)」
        if check.isEmpty {
            check = "放射(預設值)"
            sound_value.shared.select = check // 同步更新單例
        }
    }
    
    // MARK: - UI Settings
    func setUi() {
        tbvSound.register(UINib(nibName: "SoundTableViewCell", bundle: nil), forCellReuseIdentifier: SoundTableViewCell.identifire)
        tbvSound.delegate = self
        tbvSound.dataSource = self
        
        tbvSound.layer.cornerRadius = 15
        tbvSound.layer.masksToBounds = true
    }
    // MARK: - IBAction
    
    // MARK: - Function
    func setNavigation() {
        self.title = "提示聲"
        let btnBack = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(backToAdd))
        btnBack.tintColor = .orange
        self.navigationItem.leftBarButtonItem = btnBack
    }
    @objc func backToAdd() {
        delegate?.didSelectSound(sound: check)
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Extensions
extension SoundViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sound.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SoundTableViewCell.identifire, for: indexPath) as! SoundTableViewCell
        cell.lbSound.text = sound[indexPath.row]
        
        if check == sound[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        check = sound[indexPath.row]
        sound_value.shared.select = sound[indexPath.row]
        print(check)
        tableView.reloadData()
        
//        delegate?.didSelectSound(sound: sound[indexPath.row])
//        navigationController?.popViewController(animated: true)
    }
}



// MARK: - Protocol
protocol SoundSelectionDelegate: AnyObject {
    func didSelectSound(sound: String) 
}

