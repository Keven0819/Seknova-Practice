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
    
    // MARK: - UI Settings
    func setupUI() {
        setupNavigationBar()
        setupTextFields()
        setupButtons()
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
            // 如果設備的 iOS 版本低於 17.0，則使用舊的方法設置導航欄外觀
            
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
        setupLeftView(for: txfUserName, imageName: "mail")
        setupLeftView(for: txfPassword, imageName: "password")
    }
    
    // button按鈕前顯示圖片
    func setupLeftView(for textField: UITextField, imageName: String) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: textField.frame.height))
        if imageName == "mail" {
            let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 15))
            imageView.image = UIImage(named: imageName)
            imageView.tintColor = .gray
            leftView.addSubview(imageView)
        } else {
            let imageView = UIImageView(frame: CGRect(x: 22, y: 20, width: 15, height: 18))
            imageView.image = UIImage(named: imageName)
            imageView.tintColor = .gray
            leftView.addSubview(imageView)
        }
        
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    
    // 呼叫設定button圖片的funciton
    func setupButtons() {
        setupButtonView(myButton: btnFacebookLogin, imageName: "facebook")
        setupButtonView(myButton: btnAppleLogin, imageName: "apple")
        setupButtonView(myButton: btnGoogleLogin, imageName: "google")
    }
    
    // 設定圖片
    func setupButtonView(myButton: UIButton, imageName: String) {
        // 設定圖片size
        let image = UIImage(named: imageName)
        let imageSize = CGSize(width: 30, height: 30)
        let resizedImage = image?.resized(to: imageSize)

        // 配置按钮
        var configuration = UIButton.Configuration.filled()
        configuration.image = resizedImage
        
        // 設定button顏色
        if imageName == "facebook" {
            configuration.title = "Facebook 登入"
            configuration.baseBackgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
            configuration.imagePadding = 20
        } else if imageName == "apple" {
            configuration.title = "使用 Apple 登入"
            configuration.baseBackgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
            configuration.imagePadding = 10
        } else {
            configuration.title = "Google 登入"
            configuration.baseBackgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            configuration.baseForegroundColor = .black
            configuration.background.strokeColor = .black
            configuration.imagePadding = 10
        }
        
        // 設定buuton邊框樣式
        configuration.cornerStyle = .capsule

        // 設定圖片和文字的位置
        configuration.imagePlacement = .leading // 圖片放在文字的前面
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
        
        // 置中
        myButton.contentHorizontalAlignment = .center
        
        // 將設定套用至button
        myButton.configuration = configuration
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
    
    // MARK: - Function
    
}

// MARK: - Extensions
// 重新設定圖片大小擴充功能
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
