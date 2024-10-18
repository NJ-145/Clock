//
//  SoundTableViewCell.swift
//  Clock
//
//  Created by imac-2626 on 2024/10/15.
//

import UIKit

class SoundTableViewCell: UITableViewCell {

    @IBOutlet var lbSound: UILabel!
    static let identifire = "SoundTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
