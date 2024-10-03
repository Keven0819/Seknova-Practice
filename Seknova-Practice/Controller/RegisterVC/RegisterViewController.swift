//
//  RegisterViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/9/24.
//

import UIKit

class RegisterViewController: UIViewController, TermsViewControllerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var txfMail: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfirmPassword: UITextField!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var pkvCountry: UIPickerView!
    @IBOutlet weak var btnRegister: UIButton!
    
    // MARK: - Property
    
    let countries = [("Taiwan(台灣)"), ("America(美國)")]
    var isButtonTapped = false
    let userDefault = UserDefaults() // 實例化UserDefaults
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    func setupUI() {
        setupNavigationBar()
        setupTextFields()
        setupPickerView()
        useUserDefaults()
    }
    
    // 設定選擇國家的pickerView
    func setupPickerView() {
        pkvCountry.delegate = self
        pkvCountry.dataSource = self
        pkvCountry.isHidden = true
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
        
        // 根據textField來設定圖片
        switch textField {
            case txfMail:
                let imageView = UIImageView(frame: CGRect(x: 5, y: 7, width: 25, height: 20))
                imageView.image = UIImage(named: imageName)
                leftView.addSubview(imageView)
                textField.leftView = leftView
                textField.leftViewMode = .always
            case txfPassword:
                let imageView = UIImageView(frame: CGRect(x: 7, y: 5, width: 20, height: 24))
                imageView.image = UIImage(named: imageName)
                leftView.addSubview(imageView)
                textField.leftView = leftView
                textField.leftViewMode = .always
            case txfConfirmPassword:
                let imageView = UIImageView(frame: CGRect(x: 7, y: 5, width: 20, height: 24))
                imageView.image = UIImage(named: imageName)
                leftView.addSubview(imageView)
                textField.leftView = leftView
                textField.leftViewMode = .always
            default:
                break
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnArgeeTapped(_ sender: Any) {
        isButtonTapped.toggle() // 切換狀態
        if isButtonTapped {
            let buttonImage = UIImage(systemName: "checkmark.circle.fill")
            btnConfirm.setImage(buttonImage, for: .normal)
            btnConfirm.tintColor = .systemGreen
        } else {
            let buttonImage = UIImage()
            btnConfirm.setImage(buttonImage, for: .normal)
            btnConfirm.tintColor = .systemGreen
        }
    }
    // 跳轉頁面
    @IBAction func btnRegisterTapped(_ sender: Any) {
        let RCTVC = RecertificationViewController()
        
        // 確認資料都有填
        if txfMail.text == "" || txfPassword.text == "" || txfConfirmPassword.text == "" {
            showAlert(message: "請填寫完整資料")
        } else if txfPassword.text != txfConfirmPassword.text {
            showAlert(message: "密碼不一致")
        // 密碼(8~16字元，需含大小寫字母與數字)
        } else if txfPassword.text!.count < 8 || txfPassword.text!.count > 16 {
            showAlert(message: "密碼需為8~16字元")
        } else if !txfPassword.text!.containsNumber {
            showAlert(message: "密碼需含數字")
        } else if !txfPassword.text!.containsLowercase {
            showAlert(message: "密碼需含小寫字母")
        } else if !txfPassword.text!.containsUppercase {
            showAlert(message: "密碼需含大寫字母")
        } else if !isButtonTapped {
            showAlert(message: "請同意條款")
        } else {
            // 都有填寫完畢才存進UserDefaults
            saveUserDefaults()
            navigationController?.pushViewController(RCTVC, animated: true)
        }
        
   }
    
    @IBAction func btnTermsTapped(_ sender: Any) {
        let termsVC = TermsViewController(nibName: "TermsViewController", bundle: nil)

        // 設置呈現方式為Popover
        termsVC.modalPresentationStyle = .popover
        termsVC.delegate = self
        if let popover = termsVC.popoverPresentationController {
        // 設置Popover的源
        popover.sourceView = self.navigationController?.navigationBar // 將來源設為navigationBar
        popover.sourceRect = self.navigationController?.navigationBar.bounds ?? CGRect.zero // 設置來源的位置
        popover.delegate = self
        popover.permittedArrowDirections = .any // 可選的箭頭方向
        }

        // 設置popover的大小
        termsVC.preferredContentSize = CGSize(width: 500, height: 800)

        // 顯示Popover
        self.present(termsVC, animated: true, completion: nil)
    }
    
    @IBAction func btnCountryTapped(_ sender: Any) {
        // pickerView顯示時有動畫效果
        UIView.transition(with: pkvCountry, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        pkvCountry.isHidden.toggle() // 切換顯示狀態
        
        // btnRegister顯示時有動畫效果
        UIView.transition(with: btnRegister, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        btnRegister.isHidden = !pkvCountry.isHidden // 依照pickerView的狀態來決定是否啟用註冊按鈕
    }
    
    
    // MARK: - Function
    func didConfirmTerms() {
        isButtonTapped = true
        // 當使用者確認條款時，執行的動作
        let checkmarkImage = UIImage(systemName: "checkmark.circle.fill") // 使用SFSymbols的打勾圖示
        btnConfirm.setImage(checkmarkImage, for: .normal)
        btnConfirm.tintColor = .systemGreen  // 改變顏色
    }
    
    // saveUserDefaults
    func saveUserDefaults() {
        userDefault.setValue(txfMail.text, forKey: "Mail")
        userDefault.setValue(txfPassword.text, forKey: "Password")
        userDefault.setValue(txfConfirmPassword.text, forKey: "ConfirmPassword")
        userDefault.setValue(btnCountry.currentTitle, forKey: "Country")
    }
    
    func useUserDefaults() {
        txfMail.text = userDefault.string(forKey: "Mail")
        txfPassword.text = userDefault.string(forKey: "Password")
        txfConfirmPassword.text = userDefault.string(forKey: "ConfirmPassword")
        btnCountry.setTitle(userDefault.string(forKey: "Country"), for: .normal)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension RegisterViewController: UIPopoverPresentationControllerDelegate {
    
    // 這個方法會在iPhone上將popover改成全螢幕的方式
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // 保持Popover的樣式
    }
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // 設定pickerView的列數
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 設定pickerView的行數
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    // 設定pickerView的每一行的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    // 設定選擇後的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        btnCountry.setTitle(countries[row], for: .normal)
        pkvCountry.isHidden.toggle() // 隱藏pickerView
    }
}

extension String {
    
    // 檢查是否有小寫字母
    var containsLowercase: Bool {
        return rangeOfCharacter(from: .lowercaseLetters) != nil
    }
    
    // 檢查是否有大寫字母
    var containsUppercase: Bool {
        return rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    // 檢查是否有數字
    var containsNumber: Bool {
        return rangeOfCharacter(from: .decimalDigits) != nil
    }
}
