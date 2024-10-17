//
//  PersonalInfoTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/15.
//

import UIKit

class PersonalInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbFieldName: UILabel!
    
    @IBOutlet weak var txfEdit: UITextField!
    
    @IBOutlet weak var imgvArrowDown: UIImageView!
    
    static let identifier = "PersonalInfoTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
