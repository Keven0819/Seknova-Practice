//
//  TransmitterViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/12.
//

import UIKit

class TransmitterViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - UI Settings
    func setNavigationBar() {
        self.navigationItem.title = "Scanning Transmitter"
        self.navigationItem.hidesBackButton = true
    }
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
