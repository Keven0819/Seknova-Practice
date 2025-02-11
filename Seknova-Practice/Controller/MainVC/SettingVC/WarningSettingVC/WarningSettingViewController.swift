//
//  WarningSettingViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/7.
//

import UIKit

class HighOrLow {
    static let shared = HighOrLow()
    var highOrLow: Bool = true
}

class WarningSettingViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: WSTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WSTableViewCell.identifier)
    }
    
    
    func setupNavigationBar() {
        self.navigationItem.title = "警示設定"
        let backButton = UIBarButtonItem()
        backButton.title = "返回"
        navigationItem.backBarButtonItem = backButton
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension WarningSettingViewController: UITableViewDelegate, UITableViewDataSource {

    // 設定 Section 數量
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // 設定每個 Section 的行數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    // 設定 Section 的 Header 標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return " "
        case 1:
            return ""
        case 2:
            return ""
        default:
            return nil
        }
    }
    
    // 設定 Section 的 Header 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 15
        case 1:
            return 0
        case 2:
            return 0
        default :
            return 0
        }
    }
    
    // 設定 Section 的 Footer 標題
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Note: Urgent low alert at 55 mg/dL is always on."
        default:
            return ""
        }
    }
    
    // 設定 Section 的 Footer 字體大小
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let footerView = UIView()
            let label = UILabel()
            label.text = "Note: Urgent low alert at 55 mg/dL is always on."
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .gray
            label.textAlignment = .left
            label.numberOfLines = 0
            label.frame = CGRect(x: 20, y: -5, width: tableView.frame.width, height: 40)
            footerView.addSubview(label)
            return footerView
        default:
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 40
        case 1:
            return 10
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    // 設定 cell 的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 設定 TableViewCell 顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WSTableViewCell.identifier, for: indexPath) as! WSTableViewCell
        
        cell.lbSubTitle.text = "none"
        
        // 設定灰色箭頭
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = "High Alerts"
                cell.lbSubTitle.text = UserPreferences.shared.highAlertsValue
            case 1:
                cell.lbTitle.text = "Low Alerts"
                cell.lbSubTitle.text = UserPreferences.shared.lowAlertsValue
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = "Rate Alerts"
                if RateAlertSwitch.shared.swRiseAlertState || RateAlertSwitch.shared.swFallAlertState {
                    cell.lbSubTitle.text = "On"
                } else {
                    cell.lbSubTitle.text = "Off"
                }
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = "Audio"
                cell.lbSubTitle.text = UserPreferences.shared.audioValue
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                HighOrLow.shared.highOrLow = true
                let vc = HighAlertsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                HighOrLow.shared.highOrLow = false
                let vc = HighAlertsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = RateAlertsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                let vc = AudioViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
}
