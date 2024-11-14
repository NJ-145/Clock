//
//  SleepClockTableViewCell.swift
//  Clock
//
//  Created by imac-2626 on 2024/11/12.
//

import UIKit

class SleepClockTableViewCell: UITableViewCell {
    
    @IBOutlet var btnSet: UIButton!
    static let identifier = "SleepClockTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
