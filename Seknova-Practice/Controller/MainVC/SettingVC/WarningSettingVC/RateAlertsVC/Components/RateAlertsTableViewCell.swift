//
//  RateAlertsTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/10.
//

import UIKit

class RateAlertsTableViewCell: UITableViewCell {
    
    static let identifier = "RateAlertsTableViewCell"

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var swOnOff: UISwitch!
    
    // 新增回調
    var switchChanged: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        swOnOff.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 當 UISwitch 值變更時，呼叫回調
    @objc func switchValueChanged(_ sender: UISwitch) {
        switchChanged?(sender.isOn)
    }
    
}
