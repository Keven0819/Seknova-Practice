//
//  LifeTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-1681 on 2024/11/26.
//

import UIKit

class LifeTableViewCell: UITableViewCell {
    
    @IBOutlet var lbLifeEvent: UILabel!
    @IBOutlet var txfLifeEvent: UITextField!
    @IBOutlet var lbg: UILabel!
    var hasAdjustedFrame: Bool = false

    static let identifiler = "LifeTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        txfLifeEvent.text = ""
        txfLifeEvent.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        // 重置其他狀態（例如框架調整）
        hasAdjustedFrame = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
