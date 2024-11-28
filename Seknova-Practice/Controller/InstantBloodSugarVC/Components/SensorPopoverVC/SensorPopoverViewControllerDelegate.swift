//
//  SensorPopoverViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/26.
//

import UIKit

protocol SensorPopoverViewControllerDelegate: AnyObject {
    func didConfirmSensor()
}

class SensorPopoverViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lbSensorStatus: UILabel!
    
    // MARK: - Property
    
    weak var delegate: SensorPopoverViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSensorStatus()
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    
    // MARK: - Function
    func checkSensorStatus() {
        if UserPreferences.shared.sesorDeviceID !=  "" {
            lbSensorStatus.text = "感測器已啟用"
        } else {
            lbSensorStatus.text = "感測器未啟用"
        }
    }
}

// MARK: - Extensions
