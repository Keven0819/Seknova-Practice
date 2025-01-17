//
//  LifeViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit

class LifeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var lbDate: UILabel!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbDate.text = currentDateTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    @IBAction func btnDatePicker(_ sender: Any) {
        datePicker.isHidden = false
        toolBar.isHidden = false
        vBackground.isHidden = false
    }
    
    @IBAction func btnCnacel(_ sender: Any) {
        datePicker.isHidden = true
        toolBar.isHidden = true
        vBackground.isHidden = true
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        datePicker.isHidden = true
        toolBar.isHidden = true
        vBackground.isHidden = true
        print(dateFormate())
        lbDate.text = dateFormate()
    }
    
    // MARK: - Function
    
    func dateFormate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = "yyyy/MM/dd EEEE aa hh:mm"
        return formatter.string(from: datePicker.date)
    }
    
    func currentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = "yyyy/MM/dd EEEE aa hh:mm"
        return formatter.string(from: Date())
    }
    
}

// MARK: - Extensions
