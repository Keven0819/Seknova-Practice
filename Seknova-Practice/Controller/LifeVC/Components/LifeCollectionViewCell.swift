//
//  CollectionViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/1/17.
//

import UIKit

class LifeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    static let identifier = "LifeCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
