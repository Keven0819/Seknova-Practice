//
//  CalibrationModeTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/12.
//

import UIKit

class CalibrationModeTableViewCell: UITableViewCell {
    
    static let identifier = "CalibrationModeTableViewCell"
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txfInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
