//
//  WeekTableViewCell.swift
//  Clock
//
//  Created by imac-2626 on 2024/10/7.
//

import UIKit

class WeekTableViewCell: UITableViewCell {

    
    @IBOutlet var lbWeek: UILabel!
    static let identifier = "WeekTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
