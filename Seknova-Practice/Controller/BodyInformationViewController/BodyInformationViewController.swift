//
//  BodyInformationViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/14.
//

import UIKit

class BodyInformationViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - UI Settings
    func setUI() {
        setNavigationBar()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "Persional Information"
        self.navigationItem.hidesBackButton = true
        
    }
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
