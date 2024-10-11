//
//  ResetPasswordViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/7.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txfEmail: UITextField!
    @IBOutlet weak var txfOldPassword: UITextField!
    @IBOutlet weak var txfNewPassword: UITextField!
    @IBOutlet weak var txfAgainNewPassword: UITextField!
    @IBOutlet weak var btnSent: UIButton!
    // MARK: - Property
    
    let userDefault = UserDefaults() // 實例化UserDefaults
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    // MARK: - UI Settings
    func setupTextField() {
        setupLeftView(for: txfEmail, imageName: "mail")
        setupLeftView(for: txfOldPassword, imageName: "password")
        setupLeftView(for: txfNewPassword, imageName: "password")
        setupLeftView(for: txfAgainNewPassword, imageName: "password")
    }
    // MARK: - IBAction
    @IBAction func btnSentTapped(_ sender: Any) {
        
        let email = userDefault.string(forKey: "email")
        let password = userDefault.string(forKey: "password")
        
        if txfEmail.text != email {
            showAlert(title: "錯誤", message: "Email輸入錯誤")
        } else if txfOldPassword.text != password {
            showAlert(title: "錯誤", message: "舊密碼輸入錯誤")
        } else if txfNewPassword.text!.count < 8 || txfNewPassword.text!.count > 16 {
            showAlert(title: "錯誤", message: "密碼需為8~16字元")
        } else if !txfNewPassword.text!.containsNumber {
            showAlert(title: "錯誤", message: "密碼需含數字")
        } else if !txfNewPassword.text!.containsLowercase {
            showAlert(title: "錯誤", message: "密碼需含小寫字母")
        } else if !txfNewPassword.text!.containsUppercase {
            showAlert(title: "錯誤", message: "密碼需含大寫字母")
        } else if txfNewPassword.text != txfAgainNewPassword.text {
            showAlert(title: "錯誤", message: "新密碼輸入不一致")
        } else {
            showAlert(title: "提示", message: "密碼修改成功")
        }
    }
    
    // MARK: - Function
    func setupLeftView(for textField: UITextField, imageName: String) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height))
        
        // 根據textField來設定圖片
        switch textField {
            
        case txfEmail:
            let imageView = UIImageView(frame: CGRect(x: 5, y: 7, width: 25, height: 20))
            imageView.image = UIImage(named: imageName)
            leftView.addSubview(imageView)
            textField.leftView = leftView
            textField.leftViewMode = .always
            
        case txfOldPassword:
            let imageView = UIImageView(frame: CGRect(x: 7, y: 5, width: 20, height: 24))
            imageView.image = UIImage(named: imageName)
            leftView.addSubview(imageView)
            textField.leftView = leftView
            textField.leftViewMode = .always
            
        case txfNewPassword:
            let imageView = UIImageView(frame: CGRect(x: 7, y: 5, width: 20, height: 24))
            imageView.image = UIImage(named: imageName)
            leftView.addSubview(imageView)
            textField.leftView = leftView
            textField.leftViewMode = .always
            
        case txfAgainNewPassword:
            let imageView = UIImageView(frame: CGRect(x: 7, y: 5, width: 20, height: 24))
            imageView.image = UIImage(named: imageName)
            leftView.addSubview(imageView)
            textField.leftView = leftView
            textField.leftViewMode = .always
            
        default:
            break
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensions
