//
//  ForgetPasswordViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/9/24.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnSent: UIButton!
    @IBOutlet weak var txfEmail: UITextField!
    
    // MARK: - Property
    
    let userDefaut = UserDefaults()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - UI Settings
    
    // 設定navigationbar標題
    func setupNavigationBar() {
        self.navigationItem.title = "Forgot Password"
    }
    
    // MARK: - IBAction
    @IBAction func pushToResetVC(_ sender: Any) {
        let email = userDefaut.string(forKey: "email")
        if txfEmail.text == email {
            let resetVC = ResetPasswordViewController()
            self.navigationController?.pushViewController(resetVC, animated: true)
        } else {
            let alert = UIAlertController(title: "錯誤", message: "Email輸入錯誤", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
