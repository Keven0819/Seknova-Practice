//
//  RecertificationViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/9/25.
//

import UIKit

class RecertificationViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnNextStep: UIButton!
    
    // MARK: - Property
    
    let userDefault = UserDefaults() // 實例化UserDefaults
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    @IBAction func btnNextStepTapped(_ sender: Any) {
        // 回到 "登入頁面"
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
        
        // 註冊畫面的帳號密碼儲存進userdefault
        let user = userDefault.string(forKey: "Mail")
        let password = userDefault.string(forKey: "Password")
        
        // 透過navigationController找到LoginViewController
        if let loginVC = navigationController?.viewControllers.first(where: { $0 is LoginViewController }) as? LoginViewController {
            print("LoginVC found.")
            DispatchQueue.main.async {
                loginVC.txfUserName.text = String(user ?? "")
                loginVC.txfPassword.text = String(password ?? "")
            }

        } else {
            print("LoginVC not found.")
        }
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
