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
    @IBOutlet weak var dpkBirthday: UIDatePicker!
    @IBOutlet weak var dpkToolBar: UIToolbar!
    @IBOutlet weak var vDpkBackground: UIView!
    
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
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.lbName.text = "名"
                if userInformation.FirstName.isEmpty == false {
                    cell.txfEdit.text = userInformation.FirstName
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = "點擊進行編輯"
                }
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 1:
                cell.lbName.text = "姓"
                if userInformation.LastName.isEmpty == false {
                    cell.txfEdit.text = userInformation.LastName
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = "點擊進行編輯"
                }
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 2:
                cell.lbName.text = "出生日期"
                if userInformation.Birthday.isEmpty == false {
                    cell.lbResult.text = userInformation.Birthday
                } else {
                    cell.lbResult.text = ""
                }
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 3:
                cell.lbName.text = "電子信箱"
                if userInformation.Email.isEmpty == false {
                    cell.txfEdit.text = userInformation.Email
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = "點擊進行編輯"
                }
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 4:
                cell.lbName.text = "手機號碼"
                if userInformation.Phone.isEmpty == false {
                    cell.lbPhonenumber.text = userInformation.Phone
                } else {
                    cell.lbPhonenumber.text = ""
                }
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = false
                cell.txfEdit.isHidden = true
                cell.btnLogOut.isHidden = true
            case 5:
                cell.lbName.text = "地址"
                if userInformation.Address.isEmpty == false {
                    cell.txfEdit.text = userInformation.Address
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = "點擊進行編輯"
                }
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.lbName.text = "性別"
                if userInformation.Gender.isEmpty == false {
                    cell.lbResult.text = userInformation.Gender
                } else {
                    cell.lbResult.text = ""
                }
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 1:
                cell.lbName.text = "身高"
                if userInformation.Height.isEmpty == false {
                    cell.txfEdit.text = userInformation.Height
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = "點擊進行編輯"
                }
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 2:
                cell.lbName.text = "體重"
                if userInformation.Weight.isEmpty == false {
                    cell.txfEdit.text = userInformation.Weight
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = "點擊進行編輯"
                }
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 3:
                cell.lbName.text = "種族"
                if userInformation.Race.isEmpty == false {
                    cell.lbResult.text = userInformation.Race
                } else {
                    cell.lbResult.text = ""
                }
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 4:
                cell.lbName.text = "飲酒"
                if userInformation.Liquor.isEmpty == false {
                    cell.lbResult.text = userInformation.Liquor
                } else {
                    cell.lbResult.text = ""
                }
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 5:
                cell.lbName.text = "抽菸"
                if userInformation.Smoke.isEmpty == false {
                    cell.lbResult.text = userInformation.Smoke
                } else {
                    cell.lbResult.text = ""
                }
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.lbName.text = "發射器裝置"
                if UserPreferences.shared.transmitterDeviceID?.isEmpty == false {
                    cell.lbResult.text = UserPreferences.shared.transmitterDeviceID
                } else {
                    cell.lbResult.text = ""
                }
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.lbName.text = "感測器裝置"
                if UserPreferences.shared.sensorDeviceID?.isEmpty == false {
                    cell.lbResult.text = UserPreferences.shared.sensorDeviceID
                } else {
                    cell.lbResult.text = ""
                }
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
                cell.accessoryType = .disclosureIndicator
            case 2:
                cell.lbName.text = "修改密碼"
                cell.txfEdit.isHidden = true
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        case 3:
            cell.lbName.isHidden = true
            cell.txfEdit.isHidden = true
            cell.lbResult.isHidden = true
            cell.imgvPhoneStatus.isHidden = true
            cell.btnLogOut.isHidden = false
            cell.lbPhonenumber.isHidden = true
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 2:
                // 出生日期
                cell.lbName.text = "出生日期"
                dpkToolBar.isHidden = false
                dpkBirthday.isHidden = false
                vDpkBackground.isHidden = false
                cell.lbResult.isHidden = true
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
            case 4:
                cell.lbName.text = "手機號碼"
                cell.lbName.isHidden = false
                cell.lbResult.isHidden = true
                cell.imgvPhoneStatus.isHidden = false
                cell.txfEdit.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = false
                let bindVC = BindPhoneViewController()
                navigationController?.pushViewController(bindVC, animated: true)
            default:
                break
            }
        case 1:
            let alert = Alert()
            switch indexPath.row {
            case 0:
                cell.lbName.text = "性別"
                cell.lbName.isHidden = false
                cell.lbResult.isHidden = true
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
                let titles = ["生理男", "生理女", "其他"]
                alert.showActionSheet(titles: titles, cancelTitle: "取消", vc: self) { result in
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = result
                }
            case 3:
                cell.lbName.text = "種族"
                cell.lbName.isHidden = false
                cell.lbResult.isHidden = true
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
                let titles = ["亞洲", "非洲", "高加索", "拉丁", "其他"]
                alert.showActionSheet(titles: titles, cancelTitle: "取消", vc: self) { result in
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = result
                }
            case 4:
                cell.lbName.text = "飲酒"
                cell.lbName.isHidden = false
                cell.lbResult.isHidden = true
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
                let titles = ["不喝酒", "偶爾喝", "經常喝", "每天喝"]
                alert.showActionSheet(titles: titles, cancelTitle: "取消", vc: self) { result in
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = result
                }
            case 5:
                cell.lbName.text = "抽菸"
                cell.lbName.isHidden = false
                cell.lbResult.isHidden = true
                cell.txfEdit.isHidden = true
                cell.imgvPhoneStatus.isHidden = true
                cell.btnLogOut.isHidden = true
                cell.lbPhonenumber.isHidden = true
                let titles = ["有", "無"]
                alert.showActionSheet(titles: titles, cancelTitle: "取消", vc: self) { result in
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = result
                }
            default:
                break
            }
            
        default:
            break
        }
    }
}
