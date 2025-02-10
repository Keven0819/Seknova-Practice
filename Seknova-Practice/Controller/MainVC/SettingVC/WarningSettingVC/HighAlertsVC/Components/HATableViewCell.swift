//
//  HATableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/7.
//

import UIKit

class HATableViewCell: UITableViewCell {
    
    static let identifier = "HATableViewCell"
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var swOnOff: UISwitch!
    @IBOutlet weak var lbContent: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
