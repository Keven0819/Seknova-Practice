//
//  BloodSugarCorrectionKnowMoreViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/6.
//

import UIKit

protocol BloodSugarCorrectionKnowMoreViewControllerDelegate: AnyObject {
    func didKowMore()
}

class BloodSugarCorrectionKnowMoreViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lbDescriptionContent: UILabel!
    
    // MARK: - Property
    
    weak var delegate: BloodSugarCorrectionKnowMoreViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbDescriptionContent.text = "系統暖機完後須進行第一次血糖校正，請透過任證的血糖機量測血糖值，並將量測的血糖值輸入在血糖校正的欄位。"
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
