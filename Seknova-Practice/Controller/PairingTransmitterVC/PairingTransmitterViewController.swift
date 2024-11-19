//
//  PairingTransmitterViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/13.
//

import UIKit

class PairingTransmitterViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - UI Settings
    func setNavigationBar() {
        self.navigationItem.title = "Pair Bluetooth"
    }
    // MARK: - IBAction
    @IBAction func btnCancel(_ sender: Any) {
        UserPreferences.shared.deviceID = ""
        let transmitterVC = TransmitterViewController()
        navigationController?.pushViewController(transmitterVC, animated: true)
        print(UserPreferences.shared.deviceID ?? "nil")
    }
    @IBAction func btnPair(_ sender: Any) {
        let animateVC = PairAnimateViewController()
        navigationController?.pushViewController(animateVC, animated: true)
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
