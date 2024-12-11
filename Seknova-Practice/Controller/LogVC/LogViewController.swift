//
//  LogViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/5.
//

import UIKit

class LogViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - UI Settings
    func setNavigationBar() {
        self.navigationItem.title = "Logs"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(btnAll))
    }
    // MARK: - IBAction
    @objc func btnAll() {
        print("btnAll")
    }
    // MARK: - Function
    
}

// MARK: - Extensions
