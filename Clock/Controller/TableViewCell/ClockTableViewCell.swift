//
//  ClockTableViewCell.swift
//  Clock
//
//  Created by imac-2626 on 2024/10/18.
//

import UIKit

class ClockTableViewCell: UITableViewCell {

    
    @IBOutlet var lbPeriod: UILabel!
    
    @IBOutlet var lbTime: UILabel!
    
    @IBOutlet var lbRemark: UILabel!
    
    @IBOutlet var swNotify: UISwitch!
    
    
    static let identifier = "ClockTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // 新增更新 UISwitch 狀態的方法
    func updateSwitchState(isOn: Bool) {
        swNotify.isOn = isOn
    }
    
}
