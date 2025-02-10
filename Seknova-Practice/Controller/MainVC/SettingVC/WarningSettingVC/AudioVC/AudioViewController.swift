//
//  AudioViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/10.
//

import UIKit

class SoundSwitch {
    static let shared = SoundSwitch()
    
    var swSoundState = false
}

class AudioViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    private var selectedValue: String = "-"
    private var switchState: Bool = false
    
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
        self.navigationItem.title = "鈴聲設定"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: AudioTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AudioTableViewCell.identifier)
        tableView.register(UINib(nibName: AudiopkvTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AudiopkvTableViewCell.identifier)
    }
    
    func setupNavigationRightButton() {
        let rightButton = UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // MARK: - IBAction
    
    @objc func saveTapped() {
        
        // 儲存開關狀態
        switchState = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AudioTableViewCell).swOnOff.isOn
        
        if switchState {
            UserPreferences.shared.audioValue = selectedValue
        } else {
            UserPreferences.shared.audioValue = "Overriden ringer for all alerts"
        }
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension AudioViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Override ringer setting to always play\n a tone, even when your ringer is"
        case 1:
            return "OPTIONS"
        default:
            return ""
        }
    }
    
    // 設定 Header 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 60
        case 1:
            return 40
        default:
            return 0
        }
    }
    
    // 設定 Section 的 Footer 字體大小
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let footerView = UIView()
            let label = UILabel()
            label.text = "Note: the Urgent Low Alert will always override your ringer, \n regardless of this setting."
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let footerView = UIView()
            let label = UILabel()
            label.text = "Override ringer setting to always play\n a tone, even when your ringer is"
            label.font = UIFont.systemFont(ofSize: 21)
            label.textColor = .black
            label.textAlignment = .left
            label.numberOfLines = 0
            label.frame = CGRect(x: 20, y: -5, width: tableView.frame.width, height: 60)
            footerView.addSubview(label)
            return footerView
        case 1:
            let footerView = UIView()
            let label = UILabel()
            label.text = "OPTIONS"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .gray
            label.textAlignment = .left
            label.numberOfLines = 0
            label.frame = CGRect(x: 20, y: 15, width: tableView.frame.width, height: 30)
            footerView.addSubview(label)
            return footerView
        default:
                return nil
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        
//        switch section {
//        case 0:
//            header.frame = CGRect(x: 20, y: 0, width: tableView.frame.width, height: 40)
//            header.textLabel?.textColor = .black
//            header.textLabel?.font = UIFont.systemFont(ofSize: 22)
//        case 1:
//            header.textLabel?.textColor = .gray
//            header.textLabel?.font = UIFont.systemFont(ofSize: 12)
//        default:
//            break
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AudioTableViewCell.identifier, for: indexPath) as! AudioTableViewCell
            
            cell.swOnOff.isHidden = true
            cell.lbContent.isHidden = true
            
            switch indexPath.row {
            case 0:
                cell.lbTitle.text = "Override"
                cell.swOnOff.isHidden = false
                cell.lbContent.isHidden = true
                
                if UserPreferences.shared.audioValue == "Overriden ringer for all alerts" {
                    cell.swOnOff.isOn = false
                } else {
                    cell.swOnOff.isOn = true
                }
                
            default:
                break
            }
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: AudioTableViewCell.identifier, for: indexPath) as! AudioTableViewCell
                
                cell.lbTitle.text = "鈴聲設定"
                cell.lbContent.isHidden = false
                cell.swOnOff.isHidden = true
                cell.lbContent.text = selectedValue
                
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: AudiopkvTableViewCell.identifier, for: indexPath) as! AudiopkvTableViewCell
                
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

extension AudioViewController: AudiopkvTableViewCellDelegate {
    func didSelectValue(_ value: String) {
        selectedValue = value
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
}
