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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchState(_ sender: Any) {
        
        if lbTitle.text == "Rise Alert" {
            RateAlertSwitch.shared.swRiseAlertState = swOnOff.isOn
        } else if lbTitle.text == "Fall Alert" {
            RateAlertSwitch.shared.swFallAlertState = swOnOff.isOn
        }
        
    }
    
}
