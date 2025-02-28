//
//  LoginViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/9/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txfUserName: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFacebookLogin: UIButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    @IBOutlet weak var btnGoogleLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForgetPassword: UIButton!
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UI Settings
    func setupUI() {
        setupNavigationBar()
        setupTextFields()
    }
    
    // 設定我的navigationBar為黑底白字
    func setupNavigationBar() {
        // 設置導航欄標題
        navigationItem.title = "Login"
        
        // 檢查 iOS 版本是否是 iOS 15.0 或更新版本
        if #available(iOS 15.0, *) {
            // 創建導航欄外觀的配置對象
            let appearance = UINavigationBarAppearance()
            
            // 配置外觀為不透明背景
            appearance.configureWithOpaqueBackground()
            
            // 設置導航欄的背景顏色
            appearance.backgroundColor = #colorLiteral(red: 0.7579411864, green: 0.05860135704, blue: 0.1392720342, alpha: 1) // 深紅色
            
            // 設置導航欄按鈕的顏色
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1) // 白色
            
            // 設置導航欄標題文字的顏色
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1) // 白色
            ]
            
            // 將配置應用於標準狀態下的導航欄外觀
            self.navigationController?.navigationBar.standardAppearance = appearance
            
            // 將配置應用於導航欄的滾動邊緣外觀，使其與標準外觀一致
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        } else {
            // 如果設備的 iOS 版本低於 15.0，則使用舊的方法設置導航欄外觀
            
            // 設置導航欄背景顏色
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7579411864, green: 0.05860135704, blue: 0.1392720342, alpha: 1) // 深紅色
            
            // 設置導航欄按鈕的顏色
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1) // 白色
            
            // 設置導航欄標題文字的顏色
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1) // 白色
            ]
        }
    }

    
    // 設定TextField前面的圖檔
    func setupTextFields() {
        txfUserName.delegate = self
        txfPassword.delegate = self
        setupLeftView(for: txfUserName, imageName: "mail")
        setupLeftView(for: txfPassword, imageName: "password")
    }
    
    // textfield前顯示圖片
    func setupLeftView(for textField: UITextField, imageName: String) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: textField.frame.height))
        if imageName == "mail" {
            let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 25, height: 20))
            imageView.image = UIImage(named: imageName)
            imageView.tintColor = .gray
            leftView.addSubview(imageView)
        } else {
            let imageView = UIImageView(frame: CGRect(x: 22, y: 15, width: 20, height: 24))
            imageView.image = UIImage(named: imageName)
            //imageView.tintColor = .gray
            leftView.addSubview(imageView)
        }
        
        textField.leftView = leftView
        textField.leftViewMode = .always
    }

    // MARK: - IBAction
    
    // 跳轉頁面
    @IBAction func pushToRegisterVC(_ sender: Any) {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    // 跳轉頁面
    @IBAction func pushToForgetPassword(_ sender: Any) {
        let forgetVC = ForgetPasswordViewController()
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    @IBAction func btnLoginTapped(_ sender: Any) {
        
        let email = UserPreferences.shared.mail
        let password = UserPreferences.shared.password
        let loginCount = UserPreferences.shared.loginCount
        let alert = Alert()

        // 创建转圈圈的动画
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

        if txfUserName.text?.isEmpty == false && txfPassword.text?.isEmpty == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // 模擬1.5秒的處理時間
                activityIndicator.stopAnimating() // 停止動畫
                activityIndicator.removeFromSuperview()

                if self.txfUserName.text != email {
                    alert.showAlert(title: "錯誤", message: "帳號輸入錯誤", vc: self, action: {})
                } else if self.txfPassword.text != password {
                    alert.showAlert(title: "錯誤", message: "密碼輸入錯誤", vc: self, action: {})
                } else {
                    if loginCount == 0 {
                        // 第一次登入跳至條款畫面
                        let termsVC = TermsViewController()
                        self.navigationController?.pushViewController(termsVC, animated: true)
                        UserPreferences.shared.loginCount! += 1
                    } else {
                        // 非第一次登入跳至首頁
                        let bodyVC = MainViewController()
                        self.navigationController?.pushViewController(bodyVC, animated: true)
                    }
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // 模擬延遲
                activityIndicator.stopAnimating() // 停止動畫
                activityIndicator.removeFromSuperview()
                alert.showAlert(title: "錯誤", message: "請輸入帳號密碼", vc: self, action: {})
            }
        }
    }
    // MARK: - Function
}

// MARK: - Extensions
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
