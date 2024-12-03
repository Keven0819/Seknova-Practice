//
//  CustomTabBar.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit

enum BottomItems: Int, CaseIterable {
    case InstantBloodSugarViewController = 0,
         BloodSugarCorrectionViewController = 1,
         LifeViewController = 2,
         HistoryViewController = 3,
         PersonInformationViewController = 4
    
    var title: String {
        switch self {
        case .InstantBloodSugarViewController:
            return "InstantBloodSugarViewController"
        case .BloodSugarCorrectionViewController:
            return "BloodSugarCorrectionViewController"
        case .LifeViewController:
            return "LifeViewController"
        case .HistoryViewController:
            return "HistoryViewController"
        case .PersonInformationViewController:
            return "PersonInformationViewController"
        }
    }
}

class CustomTabBar: UIView {
    @IBOutlet weak var oneView: TabBarView! // 即時血糖頁面
    @IBOutlet weak var twoView: TabBarView! // 血糖校正頁面
    @IBOutlet weak var threeView: TabBarView! // 生活作息頁面
    @IBOutlet weak var fourView: TabBarView! // 歷史紀錄頁面
    @IBOutlet weak var fiveView: TabBarView! // 個人資訊頁面
    
    var buttonTappen: ((Int) -> ())? = nil
    
    let item = BottomItems.allCases
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addView()
    }
}

fileprivate extension CustomTabBar {
    
    // 加上畫面
    func addView() {
        if let loadView = Bundle(for: CustomTabBar.self).loadNibNamed("CustomTabBar",
                                                                      owner: self,
                                                                      options: nil)?.first as? UIView {
            addSubview(loadView)
            loadView.frame = bounds
        }
        oneView.delegate = self
        twoView.delegate = self
        threeView.delegate = self
        fourView.delegate = self
        fiveView.delegate = self
        oneView.setinit(tag: 0, icon: UIImage(named: "trend")!, name: "即時血糖")
        twoView.setinit(tag: 1, icon: UIImage(named: "blood-1")!, name: "血糖校正")
        threeView.setinit(tag: 2, icon: UIImage(named: "calendar-1")!, name: "生活作息")
        fourView.setinit(tag: 3, icon: UIImage(named: "history")!, name: "歷史紀錄")
        fiveView.setinit(tag: 4, icon: UIImage(named: "user")!, name: "個人資訊")
    }
}

extension CustomTabBar: TabBarViewDelegate {
    func changePage(tag: Int, icon: UIImage, name: String) {
        buttonTappen?(item[tag].rawValue)
    }
}
