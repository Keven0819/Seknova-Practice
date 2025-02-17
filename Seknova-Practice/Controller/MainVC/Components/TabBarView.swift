//
//  TabBarView.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit

protocol TabBarViewDelegate: AnyObject {
    func changePage(tag: Int, icon: UIImage, name: String)
}

class TabBarView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnChangePage: UIButton!
    @IBOutlet weak var imgvPageIcon: UIImageView!
    @IBOutlet weak var lbPageName: UILabel!
    
    // MARK: - Property
    
    weak var delegate: TabBarViewDelegate?
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addView()
        if NSLocale.current.language.languageCode?.identifier == "en" {
            lbPageName.font = UIFont.systemFont(ofSize: 10)
        } else {
            lbPageName.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    @IBAction func btnChangePageTapped(_ sender: Any) {
        delegate?.changePage(tag: btnChangePage.tag, icon: imgvPageIcon.image!, name: lbPageName.text!)
    }
    
    // MARK: - Function
    func setinit(tag: Int, icon: UIImage, name: String) {
        btnChangePage.tag = tag
        imgvPageIcon.image = icon
        lbPageName.text = name
    }
}

// MARK: - Extensions
fileprivate extension TabBarView {
    
    // 加上畫面
    func addView() {
        guard let loadView = Bundle(for: TabBarView.self).loadNibNamed("TabBarView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        addSubview(loadView)
        loadView.frame = bounds
    }
}
