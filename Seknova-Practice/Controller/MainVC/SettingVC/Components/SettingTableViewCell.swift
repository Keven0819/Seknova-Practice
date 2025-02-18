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
    @IBOutlet weak var txfInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if NSLocale.current.languageCode == "zh" {
            lbTitle.font = UIFont(name: "PingFangTC-Medium", size: 17)
        } else {
            lbTitle.font = UIFont(name: "PingFangSC-Medium", size: 14)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchState(_ sender: Any) {
        if lbTitle.text == "\(NSLocalizedString("Unit Change", comment: ""))(mmol/L)" {
            Switch.shared.swUnitChangeState = swOnOff.isOn
        } else if lbTitle.text == NSLocalizedString("Exceeding high and low blood sugar warning", comment: "") {
            Switch.shared.swOverHighLowAlertState = swOnOff.isOn
        } else if lbTitle.text == NSLocalizedString("Display Value Information", comment: "") {
            Switch.shared.swDisplayValueInfo = swOnOff.isOn
        } else if lbTitle.text == NSLocalizedString("Display RSSI", comment: "") {
            Switch.shared.swDisplayRSSI = swOnOff.isOn
        } else if lbTitle.text == NSLocalizedString("Upload to the cloud", comment: "") {
            Switch.shared.swUploadCloud = swOnOff.isOn
        }
    }
    
}
