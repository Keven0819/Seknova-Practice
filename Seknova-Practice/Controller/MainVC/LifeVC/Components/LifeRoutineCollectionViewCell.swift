//
//  LifeRoutineCollectionViewCell.swift
//  Seknova-Practice
//
//  Created by imac-1681 on 2024/11/27.
//

import UIKit

class LifeRoutineCollectionViewCell: UICollectionViewCell {
    @IBOutlet var lbLifeRoutine: UILabel!
    @IBOutlet var imgLifeRoutine: UIImageView!
    
    var separator: UIView?
    static let identifiler = "LifeRoutineCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 在 awakeFromNib 中，初始化分隔線，這樣只會添加一次
        separator = UIView(frame: CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1))
        separator?.backgroundColor = .lightGray  // 設置分隔線顏色
        if let separator = separator {
            self.addSubview(separator)
        }
    }

}
