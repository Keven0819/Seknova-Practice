//
//  ScanningSensorViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/19.
//

import UIKit

class ScanningSensorViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    // MARK: - Property
    var sensorDeviceID = ""
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - UI Settings
    func setNavigationBar() {
        self.navigationItem.title = "Scanning Sensor"
        self.navigationItem.hidesBackButton = true
    }
    // MARK: - IBAction
    @IBAction func btnTextInputTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "文字輸入", message: "請輸入裝置 ID", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "輸入裝置 ID 後六碼"
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "確認", style: .default) { [weak self] _ in
            guard let deviceID = alertController.textFields?.first?.text, deviceID.count == 6 else {
                self?.showInvalidIDAlert()
                return
            }
            
            // 顯示驗證成功訊息
            self?.showSuccessAlert()
            UserPreferences.shared.sesorDeviceID = deviceID
            print("UserPreferences.shared.sesorDeviceID: \(UserPreferences.shared.sesorDeviceID ?? "")")
        }

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func btnSkipTapped(_ sender: Any) {
        let instantBloodSugarVC = InstantBloodSugarViewController()
        navigationController?.pushViewController(instantBloodSugarVC, animated: true)
    }
    
    // MARK: - Function
    private func showSuccessAlert() {
        let successAlert = UIAlertController(title: "驗證成功", message: "裝置 ID 驗證成功", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { [weak self] _ in
            self?.navigateToMainPage()
            
        }
        successAlert.addAction(okAction)
        present(successAlert, animated: true, completion: nil)
    }

    private func showInvalidIDAlert() {
        let invalidAlert = UIAlertController(title: "無效的 ID", message: "請輸入正確的裝置 ID", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        invalidAlert.addAction(okAction)
        present(invalidAlert, animated: true, completion: nil)
    }
    
    private func navigateToMainPage() {
        let instantBloodSugarVC = InstantBloodSugarViewController()
        navigationController?.pushViewController(instantBloodSugarVC, animated: true)
    }
}

// MARK: - Extensions
