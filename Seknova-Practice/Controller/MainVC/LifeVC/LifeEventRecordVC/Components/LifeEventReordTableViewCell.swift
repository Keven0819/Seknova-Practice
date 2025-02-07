//
//  LifeEventReordTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-1681 on 2024/12/11.
//

import UIKit

class LifeEventReordTableViewCell: UITableViewCell {

    @IBOutlet var lbLifeEvent: UILabel!
    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var imgEdit: UIImageView!
    @IBOutlet var lbLift0: UILabel!
    @IBOutlet var lbLift1: UILabel!
    @IBOutlet var lbLift2: UILabel!
    @IBOutlet var lbRight0: UILabel!
    @IBOutlet var lbRight1: UILabel!
    @IBOutlet var lbRight2: UILabel!
    @IBOutlet var vLifeDetail: UIView!
    
    @IBOutlet weak var detailViewHeightConstraint: NSLayoutConstraint! // 高度约束
    
    static let identifiler = "LifeEventReordTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 展开或收起视图的方法
    func setExpanded(_ expanded: Bool) {
        vLifeDetail.isHidden = !expanded  // 控制视图的显示/隐藏
        
        // 更新高度约束
       // detailViewHeightConstraint.constant = expanded ? 140 : 0
        // 140 是展开时的高度，0 是收起时的高度
    }
}
