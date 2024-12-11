//
//  BloodSugarCorrectionViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit

class BloodSugarCorrectionViewController: UIViewController , BloodSugarCorrectionKnowMoreViewControllerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnKnowMore: UIButton!
    @IBOutlet weak var lbBloodSugarValue: UILabel!
    @IBOutlet weak var btnSetup: UIButton!
    @IBOutlet weak var btnSetdown: UIButton!
    
    // MARK: - Property
    
    var bloodSugarNum = [Int](0...400)
    var timer: Timer?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addLongPressGestures()
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupNavigationBar()
        let bloodSuagrValue = UserPreferences.shared.bloodsugarCorrectionValue
        lbBloodSugarValue.text = bloodSuagrValue
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "血糖校正"
        self.navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    // MARK: - IBAction
    @IBAction func btnKnowMoreTapped(_ sender: Any) {
        print("btnKnowMoreTapped")
        let knowMoreVC = BloodSugarCorrectionKnowMoreViewController()
        knowMoreVC.delegate = self
        knowMoreVC.modalPresentationStyle = .popover
        if let popover = knowMoreVC.popoverPresentationController {
            
            popover.sourceView = self.btnKnowMore
            popover.sourceRect = self.btnKnowMore?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
            popover.delegate = self
            popover.permittedArrowDirections = .down
        }
        
        knowMoreVC.preferredContentSize = CGSize(width: 300, height: 150)
        
        present(knowMoreVC, animated: true)
        
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        // 如果低於55或400以上，跳出警告視窗
        // 抓到目前的lbBloodSugarValue.text
        let currentBloodSugarValue = lbBloodSugarValue.text
        // 判斷他在bloddSugarNum的位置
        let index = bloodSugarNum.firstIndex(of: Int(currentBloodSugarValue!)!)
        
        if bloodSugarNum[index!] < 55 || bloodSugarNum[index!] > 400 {
            let alert = UIAlertController(title: "請輸入正確的指數", message: "輸入的指數必須在55~400之間", preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            // 儲存進UserPreferences
            UserPreferences.shared.bloodsugarCorrectionValue = lbBloodSugarValue.text!
            print(UserPreferences.shared.bloodsugarCorrectionValue!)
            let bloodSugarCorrectionSureVC = BloodSugarCorrectionSureViewController()
            self.navigationController?.pushViewController(bloodSugarCorrectionSureVC, animated: true)
        }
    }
    
    @IBAction func btnSetupTapped(_ sender: Any) {
        // 抓到目前的lbBloodSugarValue.text
        let currentBloodSugarValue = lbBloodSugarValue.text
        // 判斷他在bloddSugarNum的位置
        let index = bloodSugarNum.firstIndex(of: Int(currentBloodSugarValue!)!)
        // 設定下一個值
        lbBloodSugarValue.text = String(bloodSugarNum[index! + 1])
    }
    
    @IBAction func btnSetdownTapped(_ sender: Any) {
        // 抓到目前的lbBloodSugarValue.text
        let currentBloodSugarValue = lbBloodSugarValue.text
        // 判斷他在bloddSugarNum的位置
        let index = bloodSugarNum.firstIndex(of: Int(currentBloodSugarValue!)!)
        // 設定前一個值
        lbBloodSugarValue.text = String(bloodSugarNum[index! - 1])
    }
    
    @objc func handleLongPressSetup(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            incrementBloodSugarValue()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(incrementBloodSugarValue), userInfo: nil, repeats: true)
        } else if gesture.state == .ended {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func handleLongPressSetdown(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            decrementBloodSugarValue()
            timer = Timer.scheduledTimer(timeInterval: 0.1, 
                                         target: self,
                                         selector: #selector(decrementBloodSugarValue),
                                         userInfo: nil,
                                         repeats: true)
            
        } else if gesture.state == .ended {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func incrementBloodSugarValue() {
        guard let currentBloodSugarValue = lbBloodSugarValue.text,
              let currentValue = Int(currentBloodSugarValue),
              let index = bloodSugarNum.firstIndex(of: currentValue), index < bloodSugarNum.count - 1 else {
            return
        }
        
        lbBloodSugarValue.text = String(bloodSugarNum[index + 1])
    }
    
    @objc func decrementBloodSugarValue() {
        guard let currentBloodSugarValue = lbBloodSugarValue.text, let currentValue = Int(currentBloodSugarValue),
              let index = bloodSugarNum.firstIndex(of: currentValue), index > 0 else {
            return
        }
        lbBloodSugarValue.text = String(bloodSugarNum[index - 1])
    }
    // MARK: - Function
    func didKowMore() {
        print("didKowMore")
    }
    
    func addLongPressGestures() {
        let longPressSetup = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressSetup(_:)))
        btnSetup.addGestureRecognizer(longPressSetup)

        let longPressSetdown = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressSetdown(_:)))
        btnSetdown.addGestureRecognizer(longPressSetdown)
    }
}

// MARK: - Extensions
extension BloodSugarCorrectionViewController: UIPopoverPresentationControllerDelegate {
    
    // 這個方法會在iPhone上將popover改成全螢幕的方式
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // 保持Popover的樣式
    }
}
