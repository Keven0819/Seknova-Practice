//
//  TxfGTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-1681 on 2024/12/4.
//

import UIKit

class TxfGTableViewCell: UITableViewCell {

    @IBOutlet var lbDose: UILabel!
    @IBOutlet var lbG: UILabel!
    @IBOutlet var txfDose: UITextField!
    
    static let identifiler = "TxfGTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
