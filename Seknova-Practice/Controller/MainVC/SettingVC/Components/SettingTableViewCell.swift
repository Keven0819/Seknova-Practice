//
//  SettingTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/6.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var imgvArrowRight: UIImageView!
    @IBOutlet weak var swOnOff: UISwitch!
    @IBOutlet weak var imgvReload: UIImageView!
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
