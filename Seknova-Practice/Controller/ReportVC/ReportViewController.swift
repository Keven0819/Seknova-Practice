//
//  ReportViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/5.
//

import UIKit

class ReportViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "報表"
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
