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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UI Settings
    func setupTextField() {
        txfEmail.delegate = self
        txfOldPassword.delegate = self
        txfNewPassword.delegate = self
        txfAgainNewPassword.delegate = self
        setupLeftView(for: txfEmail, imageName: "mail")
        setupLeftView(for: txfOldPassword, imageName: "password")
        setupLeftView(for: txfNewPassword, imageName: "password")
        setupLeftView(for: txfAgainNewPassword, imageName: "password")
    }
    // MARK: - IBAction
    @IBAction func btnSentTapped(_ sender: Any) {
        
        let email = UserPreferences.shared.mail
        var password = UserPreferences.shared.password
        let newPassword = UserPreferences.shared.newPassword
        
        let alert = Alert()
        
        if txfEmail.text != email {
            
            alert.showAlert(title: "錯誤", message: "Email輸入錯誤", vc: self, action: {})
            
        } else if txfOldPassword.text != password {
            
            alert.showAlert(title: "錯誤", message: "舊密碼輸入錯誤", vc: self, action: {})
            
        } else if txfNewPassword.text!.count < 8 || txfNewPassword.text!.count > 16 {
            
            alert.showAlert(title: "錯誤", message: "密碼需為8~16字元", vc: self, action: {})
            
        } else if !txfNewPassword.text!.containsNumber {
            
            alert.showAlert(title: "錯誤", message: "密碼需含數字", vc: self, action: {})
            
        } else if !txfNewPassword.text!.containsLowercase {
            
            alert.showAlert(title: "錯誤", message: "密碼需含小寫字母", vc: self, action: {})
            
        } else if !txfNewPassword.text!.containsUppercase {
            
            alert.showAlert(title: "錯誤", message: "密碼需含大寫字母", vc: self, action: {})
            
        } else if txfNewPassword.text != txfAgainNewPassword.text {
            
            alert.showAlert(title: "錯誤", message: "新密碼輸入不一致", vc: self, action: {})
            
        } else {
            
            alert.showAlert(title: "提示", message: "密碼修改成功", vc: self, action: {
                
                // 將新密碼存進userDefault
                password = newPassword
                
                // 回到 "登入頁面"
                self.navigationController?.popToRootViewController(animated: true)
            })
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
}

// MARK: - Extensions
extension ResetPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
