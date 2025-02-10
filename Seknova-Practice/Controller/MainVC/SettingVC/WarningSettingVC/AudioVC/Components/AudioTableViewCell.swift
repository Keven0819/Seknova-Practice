//
//  AudioTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/10.
//

import UIKit

class AudioTableViewCell: UITableViewCell {
    
    static let identifier = "AudioTableViewCell"

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var swOnOff: UISwitch!
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
