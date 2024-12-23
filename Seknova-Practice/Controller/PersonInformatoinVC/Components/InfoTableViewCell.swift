//
//  InfoTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/13.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var txfEdit: UITextField!
    @IBOutlet weak var imgvPhoneStatus: UIImageView!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var lbPhonenumber: UILabel!
    
    
    static let identifier = "InfoTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
