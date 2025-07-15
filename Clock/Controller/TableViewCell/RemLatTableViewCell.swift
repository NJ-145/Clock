//
//  RemLatTableViewCell.swift
//  Clock
//
//  Created by imac-2626 on 2024/9/30.
//

import UIKit

class RemLatTableViewCell: UITableViewCell {

    
    @IBOutlet var swReminderLater: UISwitch!
    static let identifier = "RemLatTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateSwitchState(isOn: Bool) {
            swReminderLater.isOn = isOn
    }
}
