//
//  TagTableViewCell.swift
//  Clock
//
//  Created by imac-2626 on 2024/9/30.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    
    @IBOutlet var txfTag: UITextField!
    static let identifier = "TagTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
