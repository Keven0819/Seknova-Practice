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
        navigationItem.title = "Login"
        if #available(iOS 17.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = #colorLiteral(red: 0.7579411864, green: 0.05860135704, blue: 0.1392720342, alpha: 1)
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1)
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1)]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        } else {
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7579411864, green: 0.05860135704, blue: 0.1392720342, alpha: 1)
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1)]
        }
    }
    
    // 設定TextField前面的圖檔
    func setupTextFields() {
        setupLeftView(for: txfUserName, imageName: "mail")
        setupLeftView(for: txfPassword, imageName: "password")
    }
    
    func setupLeftView(for textField: UITextField, imageName: String) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: textField.frame.height))
        if imageName == "mail" {
            let imageView = UIImageView(frame: CGRect(x: 10, y: 20, width: 30, height: 20))
            imageView.image = UIImage(named: imageName)
            imageView.tintColor = .gray
            leftView.addSubview(imageView)
        } else {
            let imageView = UIImageView(frame: CGRect(x: 13, y: 16, width: 25, height: 25))
            imageView.image = UIImage(named: imageName)
            imageView.tintColor = .gray
            leftView.addSubview(imageView)
        }
        
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    func setupButtons() {
        setupButtonView(myButton: btnFacebookLogin, imageName: "facebook")
        setupButtonView(myButton: btnAppleLogin, imageName: "apple")
        setupButtonView(myButton: btnGoogleLogin, imageName: "google")
    }
    
    func setupButtonView(myButton: UIButton, imageName: String) {
        // 設定圖片size
        let image = UIImage(named: imageName)
        let imageSize = CGSize(width: 30, height: 30)
        let resizedImage = image?.resized(to: imageSize)

        // 配置按钮
        var configuration = UIButton.Configuration.filled()
        configuration.image = resizedImage
        if imageName == "facebook" {
            configuration.title = "Facebook登入"
            configuration.baseBackgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        } else if imageName == "apple" {
            configuration.title = "Apple登入"
            configuration.baseBackgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        } else {
            configuration.title = "Google登入"
            configuration.baseBackgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            configuration.baseForegroundColor = .black
            configuration.background.strokeColor = .black
        }
        configuration.cornerStyle = .capsule

        // 設定圖片和文字的位置
        configuration.imagePlacement = .leading // 圖片放在文字的前面
        configuration.imagePadding = 10 // 圖片和文字的間鉅
        myButton.configuration = configuration
    }

    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
