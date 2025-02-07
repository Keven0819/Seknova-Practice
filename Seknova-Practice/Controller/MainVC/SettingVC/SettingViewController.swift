//
//  SettingViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/5.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: SettingTableViewCell.identifier)
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        
        // 隱藏不必要的元件
        cell.imgvArrowRight.isHidden = true
        cell.swOnOff.isHidden = true
        cell.imgvReload.isHidden = true
        cell.lbContent.isHidden = true
        
        switch indexPath.row {
        case 0:
            cell.lbTitle.text = "警示設定"
            cell.imgvArrowRight.isHidden = false
        case 1:
            cell.lbTitle.text = "單位切換(mmol/L)"
            cell.swOnOff.isHidden = false
        case 2:
            cell.lbTitle.text = "超出高低血糖警示"
            cell.swOnOff.isHidden = false
        case 3:
            cell.lbTitle.text = "資料同步"
            cell.imgvReload.isHidden = false
        case 4:
            cell.lbTitle.text = "暖機狀態"
            cell.lbContent.isHidden = false
            cell.lbContent.text = "Off"
        case 5:
            cell.lbTitle.text = "韌體版本"
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
    }
}
