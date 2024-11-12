//
//  TipsViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/12.
//

import UIKit

class TipsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: - Property
    weak var delegate: TipsViewControllerDelegate?
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTipsText()
    }
    
    // MARK: - UI Settings
    func setupTipsText() {
        let tipsText = "設定高低血糖值，系統會於血糖高於高血糖值或是血糖低於低血糖值時透過通知使用者須進一步處理。通知方式為訊息，鈴聲 (可關掉) 或電子郵件信箱"
        textView.text = tipsText
    }
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
protocol TipsViewControllerDelegate: AnyObject {
    
}
