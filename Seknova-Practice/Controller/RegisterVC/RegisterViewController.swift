//
//  RegisterViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/9/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txfMail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfirmPassword: UITextField!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    func setupUI() {
        setupNavigationBar()
        setupTextFields()
    }
    
    // 設定navigationbar標題
    func setupNavigationBar() {
        self.navigationItem.title = "Register"
    }
    
    // 設定TextField前面的圖檔
    func setupTextFields() {
        setupLeftView(for: txfMail, imageName: "mail")
        setupLeftView(for: txfPassword, imageName: "password")
        setupLeftView(for: txfConfirmPassword, imageName: "password")
    }
    
    // textfield前顯示圖片
    func setupLeftView(for textField: UITextField, imageName: String) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height))
        
        switch textField {
            case txfMail:
                let imageView = UIImageView(frame: CGRect(x: 8, y: 5, width: 25, height: 20))
                imageView.image = UIImage(named: imageName)
                leftView.addSubview(imageView)
                textField.leftView = leftView
                textField.leftViewMode = .always
            case txfPassword:
                let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 24))
                imageView.image = UIImage(named: imageName)
                leftView.addSubview(imageView)
                textField.leftView = leftView
                textField.leftViewMode = .always
            case txfConfirmPassword:
                let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 24))
                imageView.image = UIImage(named: imageName)
                leftView.addSubview(imageView)
                textField.leftView = leftView
                textField.leftViewMode = .always
            default:
                break
        }
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
