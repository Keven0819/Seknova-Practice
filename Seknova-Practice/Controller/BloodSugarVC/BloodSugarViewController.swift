//
//  BloodSugarViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/21.
//

import UIKit

class BloodSugarViewController: UIViewController, TipsViewControllerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var pkvLowSugar: UIPickerView!
    @IBOutlet weak var pkvHighSugar: UIPickerView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnKnowMore: UIButton!
    
    // MARK: - Property
    let lowSugar = [Int](65...75)
    let highSugar = [Int](150...250)
    var lowValue: Int = 70
    var highValue: Int = 200
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerView()
        pickerViewinit()
    }
    
    // MARK: - UI Settings
    func setPickerView() {
        pkvLowSugar.delegate = self
        pkvLowSugar.dataSource = self
        pkvHighSugar.delegate = self
        pkvHighSugar.dataSource = self
    }
    func pickerViewinit() {
        pkvLowSugar.selectRow(5, inComponent: 0, animated: true)
        pkvHighSugar.selectRow(50, inComponent: 0, animated: true)
    }
    // MARK: - IBAction
    @IBAction func btnSaveTapped(_ sender: Any) {
        UserPreferences.shared.lowSugarValue = lowValue
        UserPreferences.shared.highSugarValue = highValue
        print(UserPreferences.shared.lowSugarValue ?? 0)
        print(UserPreferences.shared.highSugarValue ?? 0)
        
        let TransmitterVC = TransmitterViewController()
        navigationController?.pushViewController(TransmitterVC, animated: true)
    }
    @IBAction func btnKnowMoreTapped(_ sender: Any) {
        let tipsVC = TipsViewController()
        tipsVC.modalPresentationStyle = .popover
        tipsVC.delegate = self
        if let popover = tipsVC.popoverPresentationController {
            popover.sourceView = self.btnKnowMore
            popover.sourceRect = self.btnKnowMore.bounds
            popover.delegate = self
            popover.permittedArrowDirections = .down
        }
        
        tipsVC.preferredContentSize = CGSize(width: 280, height: 140)
        self.present(tipsVC, animated: true, completion: nil)
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension BloodSugarViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pkvLowSugar {
            return lowSugar.count
        } else {
            return highSugar.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pkvLowSugar {
            return String(lowSugar[row])
        } else {
            return String(highSugar[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pkvLowSugar {
            lowValue = lowSugar[row]
        } else {
            highValue = highSugar[row]
        }
    }
}

extension BloodSugarViewController: UIPopoverPresentationControllerDelegate {
    
    // 這個方法會在iPhone上將popover改成全螢幕的方式
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // 保持Popover的樣式
    }
}
