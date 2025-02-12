//
//  SettingViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/5.
//

import UIKit

class Switch {
    static let shared = Switch()
    
    // 單位切換(mmol/L)
    var swUnitChangeState: Bool = false
    
    // 超出高低血糖警示
    var swOverHighLowAlertState: Bool = false
    
    // 顯示數值資訊
    var swDisplayValueInfo: Bool = false
    
    // 顯示 RSSI
    var swDisplayRSSI: Bool = false
    
    // 上傳雲端
    var swUploadCloud: Bool = false
}

class SettingViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    var developmentMode: String = "0000"
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTextFieldText()
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupTableView()
        whatMode()
        setupNavigationBar()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    func whatMode() {
        developmentMode = UserPreferences.shared.developmentModeKey ?? "0000"
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "設定"
    }
    
    func saveTextFieldText() {
        if developmentMode == "8888" {
            let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SettingTableViewCell
            UserPreferences.shared.adcInitialValue = cell.txfInput.text
            
            let cell1 = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! SettingTableViewCell
            UserPreferences.shared.timeIntervalValue = cell1.txfInput.text
            
            let cell2 = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! SettingTableViewCell
            UserPreferences.shared.yAxisLimitsValue = cell2.txfInput.text
        }
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if developmentMode == "0000" {
            return 8
        } else if developmentMode == "8888" {
            return 15
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        // 隱藏不必要的元件
        cell.imgvArrowRight.isHidden = true
        cell.swOnOff.isHidden = true
        cell.imgvReload.isHidden = true
        cell.lbContent.isHidden = true
        cell.txfInput.isHidden = true
        
        if developmentMode == "0000" {
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = "警示設定"
                cell.imgvArrowRight.isHidden = false
            case 1:
                cell.lbTitle.text = "單位切換(mmol/L)"
                cell.swOnOff.isHidden = false
                cell.swOnOff.isOn = Switch.shared.swUnitChangeState
            case 2:
                cell.lbTitle.text = "超出高低血糖警示"
                cell.swOnOff.isHidden = false
                cell.swOnOff.isOn = Switch.shared.swOverHighLowAlertState
            case 3:
                cell.lbTitle.text = "資料同步"
                cell.imgvReload.isHidden = false
            case 4:
                cell.lbTitle.text = "暖機狀態"
                cell.lbContent.isHidden = false
                cell.lbContent.text = "Off"
            case 5:
                cell.lbTitle.text = "上傳事件日誌"
                cell.lbContent.isHidden = false
                cell.lbContent.text = "09/05 02:16:35"
            case 6:
                cell.lbTitle.text = "韌體版本"
                cell.lbContent.isHidden = false
                cell.lbContent.text = "1.24.9"
            case 7:
                cell.lbTitle.text = "App 版本"
                cell.lbContent.isHidden = false
                cell.lbContent.text = "00.00.61"
            default:
                break
            }
            return cell
        } else if developmentMode == "8888" {
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = "警示設定"
                cell.imgvArrowRight.isHidden = false
            case 1:
                cell.lbTitle.text = "校正模式"
                cell.imgvArrowRight.isHidden = false
            case 2:
                cell.lbTitle.text = "設定ADC初始值"
                cell.txfInput.isHidden = false
                if UserPreferences.shared.adcInitialValue == "" {
                    cell.txfInput.text = "0"
                } else {
                    cell.txfInput.text = UserPreferences.shared.adcInitialValue
                }
                cell.txfInput.keyboardType = .numberPad
            case 3:
                cell.lbTitle.text = "設定X軸時間間距 (per/s)"
                cell.txfInput.isHidden = false
                if UserPreferences.shared.timeIntervalValue == "" {
                    cell.txfInput.text = "3600.0 per/s"
                } else {
                    cell.txfInput.text = UserPreferences.shared.timeIntervalValue
                    if cell.txfInput.text?.contains("per/s") == false {
                        cell.txfInput.text = cell.txfInput.text! + " per/s"
                    }
                }
                cell.txfInput.keyboardType = .numberPad
            case 4:
                cell.lbTitle.text = "設定y軸上下限"
                cell.txfInput.isHidden = false
                if UserPreferences.shared.yAxisLimitsValue == "" {
                    cell.txfInput.text = "400,0"
                } else {
                    cell.txfInput.text = UserPreferences.shared.yAxisLimitsValue
                }
                cell.txfInput.keyboardType = .numberPad
            case 5:
                cell.lbTitle.text = "單位切換(mmol/L)"
                cell.swOnOff.isHidden = false
                cell.swOnOff.isOn = Switch.shared.swUnitChangeState
            case 6:
                cell.lbTitle.text = "顯示數值資訊"
                cell.swOnOff.isHidden = false
                cell.swOnOff.isOn = Switch.shared.swDisplayValueInfo
            case 7:
                cell.lbTitle.text = "顯示 RSSI"
                cell.swOnOff.isHidden = false
                cell.swOnOff.isOn = Switch.shared.swDisplayRSSI
            case 8:
                cell.lbTitle.text = "上傳雲端"
                cell.swOnOff.isHidden = false
                cell.swOnOff.isOn = Switch.shared.swUploadCloud
            case 9:
                cell.lbTitle.text = "超出高低血糖警示"
                cell.swOnOff.isHidden = false
                cell.swOnOff.isOn = Switch.shared.swOverHighLowAlertState
            case 10:
                cell.lbTitle.text = "資料同步"
                cell.imgvReload.isHidden = false
            case 11:
                cell.lbTitle.text = "暖機狀態"
                cell.lbContent.isHidden = false
                cell.lbContent.text = "Off"
            case 12:
                cell.lbTitle.text = "上傳事件日誌"
                cell.lbContent.isHidden = false
                cell.lbContent.text = "09/05 02:16:35"
            case 13:
                cell.lbTitle.text = "韌體版本"
                cell.lbContent.isHidden = false
                cell.lbContent.text = "1.24.9"
            case 14:
                cell.lbTitle.text = "App 版本"
                cell.lbContent.isHidden = false
                cell.lbContent.text = "00.00.61"
            default:
                break
            }
            return cell
        } else {
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if developmentMode == "0000" {
            switch indexPath.row {
            case 0:
                let warningSettingVC = WarningSettingViewController()
                self.navigationItem.backButtonTitle = "設定"
                navigationController?.pushViewController(warningSettingVC, animated: true)
            case 4:
                // 能輸入文字的 AlertController
                let alertController = UIAlertController(title: "請輸入對應字串！",
                                                        message: "如果輸入 0000 會切換暖機狀態\n如果輸入 8888 則開啟開發模式",
                                                        preferredStyle: .alert)
                alertController.addTextField { (textField) in
                    textField.placeholder = ""
                }
                let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
                let okAction = UIAlertAction(title: "確認", style: .default) { (action) in
                    self.developmentMode = alertController.textFields?[0].text ?? ""
                    print("輸入的字串：\(self.developmentMode)")
                    UserPreferences.shared.developmentModeKey = self.developmentMode
                    self.tableView.reloadData()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            default:
                break
            }
        } else if developmentMode == "8888" {
            switch indexPath.row {
            case 0:
                let vc = WarningSettingViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = CalibrationModeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 11:
                // 能輸入文字的 AlertController
                let alertController = UIAlertController(title: "請輸入對應字串！",
                                                        message: "如果輸入 0000 會切換暖機狀態\n如果輸入 8888 則開啟開發模式",
                                                        preferredStyle: .alert)
                alertController.addTextField { (textField) in
                    textField.placeholder = ""
                }
                let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
                let okAction = UIAlertAction(title: "確認", style: .default) { (action) in
                    self.developmentMode = alertController.textFields?[0].text ?? ""
                    print("輸入的字串：\(self.developmentMode)")
                    UserPreferences.shared.developmentModeKey = self.developmentMode
                    self.tableView.reloadData()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            default:
                break
            }
        }
    }
}
