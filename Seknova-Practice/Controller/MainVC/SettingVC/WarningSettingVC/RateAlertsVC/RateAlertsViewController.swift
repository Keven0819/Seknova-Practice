//
//  RateAlertsViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/10.
//

import UIKit

class RateAlertSwitch {
    static let shared = RateAlertSwitch()
    
    var swRiseAlertState = false
    var swFallAlertState = false
}

class RateAlertsViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    var switchRiseState: Bool = false
    var switchFallState: Bool = false
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupNavigationBar()
        setupTableView()
        setupNavigationRightButton()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = NSLocalizedString("Rate Alerts", comment: "")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: RateAlertsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RateAlertsTableViewCell.identifier)
    }
    
    func setupNavigationRightButton() {
        let rightButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // MARK: - IBAction
    
    @objc func saveTapped() {
        // 當儲存時，將值儲存到 shared 中
        RateAlertSwitch.shared.swRiseAlertState = switchRiseState
        RateAlertSwitch.shared.swFallAlertState = switchFallState
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension RateAlertsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RateAlertsTableViewCell.identifier, for: indexPath) as! RateAlertsTableViewCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = "Rise Alert"
                cell.swOnOff.isOn = RateAlertSwitch.shared.swRiseAlertState
                // 設置開關值變更時的回調
                cell.switchChanged = { isOn in
                    self.switchRiseState = isOn
                }
            default:
                break
            }
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = "Fall Alert"
                cell.swOnOff.isOn = RateAlertSwitch.shared.swFallAlertState
                // 設置開關值變更時的回調
                cell.switchChanged = { isOn in
                    self.switchFallState = isOn
                }
            default:
                break
            }
            return cell
        default:
            break
        }
        return cell
    }
    // 設定 Section 的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return " "
        case 1:
            return ""
        default:
            return ""
        }
    }
    
    // 設定 Section 的 Footer 標題
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Alert when sensor glucose rate is rising quickly"
        case 1:
            return "Alert when sensor glucose rate is falling quickly"
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
            label.text = "Alert when sensor glucose rate is rising quickly"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .gray
            label.textAlignment = .left
            label.numberOfLines = 0
            label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width, height: 40)
            footerView.addSubview(label)
            return footerView
        case 1:
            let footerView = UIView()
            let label = UILabel()
            label.text = "Alert when sensor glucose rate is falling quickly"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .gray
            label.textAlignment = .left
            label.numberOfLines = 0
            label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width, height: 40)
            footerView.addSubview(label)
            return footerView
        default:
                return nil
        }
    }
    
    // 設定 Footer 的高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
