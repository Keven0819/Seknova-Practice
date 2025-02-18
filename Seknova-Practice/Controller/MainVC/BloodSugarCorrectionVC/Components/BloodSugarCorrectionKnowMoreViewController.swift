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
        lbDescriptionContent.text = NSLocalizedString("CalibrateUnderstandMore", comment: "")
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
