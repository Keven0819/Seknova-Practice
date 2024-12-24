//
//  PersonInformationViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/22.
//

import UIKit
import RealmSwift

class PersonInformationViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    let userInformation = UserInformation()
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 列印Realm資料庫位置
        let realm = try! Realm()
        print(realm.configuration.fileURL!)
        
        // 讀取Realm資料庫
        let userInformation = realm.objects(UserInformation.self)
        // 創建Realm陣列
        let userInformationArray = Array(userInformation)
        // 列印Realm資料庫
        print(userInformationArray)
    }
    
    // MARK: - UI Settings
    func setupUI() {
        setupTableView()
    }
    
    // 設定tableView
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 40
        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: InfoTableViewCell.identifier)
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
}

// MARK: - Extensions
extension PersonInformationViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 6
        case 2:
            return 3
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "基本資料"
        case 1:
            return "身體數值"
        case 2:
            return "帳號"
        case 3:
            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        
        // 利用email去篩選最新的資料
        let realm = try! Realm()
        let userInformation = realm.objects(UserInformation.self).filter("Email == %@", UserPreferences.shared.mail ?? "").first!
        
        cell.lbPhonenumber.isHidden = true
        cell.imgvPhoneStatus.isHidden = true
        cell.lbResult.isHidden = true
        
        switch indexPath.section {
        case 0:
            cell.btnLogOut.isHidden = true
            switch indexPath.row {
            case 0:
                cell.lbName.text = "名"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.FirstName != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.FirstName
                }
            case 1:
                cell.lbName.text = "姓"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.LastName != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.LastName
                }
            case 2:
                cell.lbName.text = "出生日期"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.Birthday != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Birthday
                }
            case 3:
                cell.lbName.text = "電子信箱"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.Email != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Email
                }
            case 4:
                cell.lbName.text = "手機號碼"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = false
                cell.lbResult.isHidden = true
                cell.lbPhonenumber.isHidden = true
                if userInformation.Phone != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbPhonenumber.isHidden = false
                    cell.lbPhonenumber.text = userInformation.Phone
                }
            case 5:
                cell.lbName.text = "地址"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                if userInformation.Address != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Address
                }
            default:
                break
            }
        case 1:
            cell.btnLogOut.isHidden = true
            switch indexPath.row {
            case 0:
                cell.lbName.text = "性別"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.Gender != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Gender
                }
            case 1:
                cell.lbName.text = "身高"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.Height != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Height
                }
            case 2:
                cell.lbName.text = "體重"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.Weight != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Weight
                }
            case 3:
                cell.lbName.text = "種族"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.Race != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Race
                }
            case 4:
                cell.lbName.text = "飲酒"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.Liquor != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Liquor
                }
            case 5:
                cell.lbName.text = "抽菸"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvPhoneStatus.isHidden = true
                cell.lbResult.isHidden = true
                if userInformation.Smoke != "" {
                    cell.txfEdit.isHidden = true
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformation.Smoke
                }
            default:
                break
            }
        case 2:
            cell.btnLogOut.isHidden = true
            switch indexPath.row {
            case 0:
                cell.lbName.text = "發射器裝置"
            case 1:
                cell.lbName.text = "感測器裝置"
            case 2:
                cell.lbName.text = "修改密碼"
            default:
                break
            }
        case 3:
            cell.lbName.isHidden = true
            cell.btnLogOut.isHidden = false
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
