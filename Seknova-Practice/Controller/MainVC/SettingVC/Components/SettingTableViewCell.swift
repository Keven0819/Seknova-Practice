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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func switchState(_ sender: Any) {
        if lbTitle.text == "單位切換(mmol/L)" {
            Switch.shared.swUnitChangeState = swOnOff.isOn
        } else if lbTitle.text == "超出高低血糖警示" {
            Switch.shared.swOverHighLowAlertState = swOnOff.isOn
        } else if lbTitle.text == "顯示數值資訊" {
            Switch.shared.swDisplayValueInfo = swOnOff.isOn
        } else if lbTitle.text == "顯示 RSSI" {
            Switch.shared.swDisplayRSSI = swOnOff.isOn
        } else if lbTitle.text == "上傳雲端" {
            Switch.shared.swUploadCloud = swOnOff.isOn
        }
    }
    
}
