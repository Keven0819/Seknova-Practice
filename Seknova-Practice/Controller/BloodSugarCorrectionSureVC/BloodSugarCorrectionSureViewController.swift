//
//  BloodSugarCorrectionSureViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit

class BloodSugarCorrectionSureViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lbBloodSugarValue: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCorrect: UIButton!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - UI Settings
    func setUI() {
        loadingBloodSugarValue()
        catchTime()
    }
    // MARK: - IBAction
    @IBAction func btnConfirmTapped(_ sender: Any) {
        // 跳轉回即時血糖畫面MainviewController的即時血糖畫面
        let mainVC = MainViewController()
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    @IBAction func btnCorrectTapped(_ sender: Any) {
        // 回到血糖校正畫面
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Function
    func loadingBloodSugarValue() {
        let value = UserPreferences.shared.bloodsugarCorrectionValue
        lbBloodSugarValue.text = value
    }
    
    func catchTime() {
        // 抓取目前的時間然後做成 2:14 上午的格式，讓label顯示
        let date = Date()
        let formatter = DateFormatter()
        
        // am pm 要中文顯示
        formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: date)
        lbTime.text = time
    }
}

// MARK: - Extensions
