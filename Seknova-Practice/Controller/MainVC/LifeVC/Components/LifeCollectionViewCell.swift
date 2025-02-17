//
//  LifeCollectionViewCell.swift
//  Seknova-Practice
//
//  Created by imac-1681 on 2024/11/22.
//

import UIKit

class LifeCollectionViewCell: UICollectionViewCell {

    @IBOutlet var lbLife: UILabel!
    @IBOutlet var imgLife: UIImageView!
    @IBOutlet var vLifeBackground: UIView!
    
    static let identifiler = "LifeCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if NSLocale.current.language.languageCode?.identifier == "en" {
            lbLife.font = UIFont.systemFont(ofSize: 14)
        } else {
            lbLife.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
}
