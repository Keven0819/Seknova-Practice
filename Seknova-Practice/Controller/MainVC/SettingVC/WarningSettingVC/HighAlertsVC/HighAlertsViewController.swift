//
//  HighAlertsViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/7.
//

import UIKit

class HighAlertsViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    private var selectedValue: String = "-"
    private var switchState: Bool = false
    var whatVC = HighOrLow.shared.highOrLow
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 驗證是從「高血糖警示」還是「低血糖警示」進入的 Debug 語句
        print("HighOrLow: \(whatVC)")
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupNavigationBar()
        setupTableView()
        setupNavigationRightButton()
    }
    
    func setupNavigationBar() {
        if whatVC {
            self.navigationItem.title = "高血糖警示"
        } else {
            self.navigationItem.title = "低血糖警示"
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: HATableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HATableViewCell.identifier)
        tableView.register(UINib(nibName: HApkvTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HApkvTableViewCell.identifier)
    }
    
    func setupNavigationRightButton() {
        let rightButton = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // MARK: - IBAction
    
    @objc func saveTapped() {
        
        // 儲存開關狀態
        switchState = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! HATableViewCell).swOnOff.isOn
        print("switchState: \(switchState)")
        
        
        // 判斷高血糖或低血糖，並且利用開關狀態儲存值
        if whatVC {
            if switchState {
                UserPreferences.shared.highAlertsValue = selectedValue
                print("highAlertsState: \(String(describing: UserPreferences.shared.highAlertsValue))")
            } else {
                UserPreferences.shared.highAlertsValue = "none"
                print("highAlertsState: \(String(describing: UserPreferences.shared.highAlertsValue))")
            }
        } else {
            if switchState {
                UserPreferences.shared.lowAlertsValue = selectedValue
                print("lowAlertsState: \(String(describing: UserPreferences.shared.lowAlertsValue))")
            } else {
                UserPreferences.shared.lowAlertsValue = "none"
                print("lowAlertsState: \(String(describing: UserPreferences.shared.lowAlertsValue))")
            }
        }
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension HighAlertsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    // 設定 Section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return " "
        case 1:
            if whatVC {
                return "高血糖警示"
            } else {
                return "低血糖警示"
            }
        default:
            return ""
        }
    }
    
    // 調整 Header 的字體大小
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HATableViewCell.identifier, for: indexPath) as! HATableViewCell
            
            cell.swOnOff.isHidden = true
            cell.lbContent.isHidden = true
            
            switch indexPath.row {
            case 0:
                
                if whatVC {
                    cell.lbTitle.text = "高血糖警示"
                    if UserPreferences.shared.highAlertsValue == "none" {
                        cell.swOnOff.isOn = false
                    } else {
                        cell.swOnOff.isOn = true
                    }
                } else {
                    cell.lbTitle.text = "低血糖警示"
                    if UserPreferences.shared.lowAlertsValue == "none" {
                        cell.swOnOff.isOn = false
                    } else {
                        cell.swOnOff.isOn = true
                    }
                }
                cell.swOnOff.isHidden = false
            default:
                break
            }
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: HATableViewCell.identifier, for: indexPath) as! HATableViewCell
                if whatVC {
                    cell.lbTitle.text = "High Limit"
                } else {
                    cell.lbTitle.text = "Low Limit"
                }
                cell.swOnOff.isHidden = true
                cell.lbContent.isHidden = false
                if selectedValue == "-" {
                    cell.lbContent.text = selectedValue
                } else {
                    cell.lbContent.text = "\(selectedValue) mg/dL"
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: HApkvTableViewCell.identifier, for: indexPath) as! HApkvTableViewCell
                
                // 傳值代理
                cell.delegate = self
                
                return cell
            default:
                break
            }
        default:
            break
        }
        return UITableViewCell()
    }
}

// 刷新特定資料
extension HighAlertsViewController: HApkvTableViewCellDelegate {
    func didSelectValue(_ value: String) {
        selectedValue = value
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
}
