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
        if UserPreferences.shared.sensorDeviceID !=  "" {
            lbSensorStatus.text = NSLocalizedString("Sensor has been activated.", comment: "")
        } else {
            lbSensorStatus.text = NSLocalizedString("Sensor hasn't been activated.\nPlease activate it first before \ndisplaying data.", comment: "")
        }
        if NSLocale.current.language.languageCode?.identifier == "en" {
            lbSensorStatus.font = UIFont.systemFont(ofSize: 14)
        } else {
            lbSensorStatus.font = UIFont.systemFont(ofSize: 17)
        }
    }
}

// MARK: - Extensions
