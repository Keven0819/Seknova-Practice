//
//  BodyInformationViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/14.
//

import UIKit
import RealmSwift

class BodyInformationViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - UI Settings
    func setUI() {
        setNavigationBar()
        setTableView()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "Persional Information"
        self.navigationItem.hidesBackButton = true
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PersonalInfoTableViewCell", bundle: nil),
                           forCellReuseIdentifier: PersonalInfoTableViewCell.identifier)
        tableView.sectionHeaderHeight = 40
    }
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension BodyInformationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           return 6 // 第一個 section 的行數
       } else {
           return 6 // 第二個 section 的行數
       }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "個人資訊"
        } else if section == 1 {
            return "身體數值"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalInfoTableViewCell.identifier,
                                                 for: indexPath) as! PersonalInfoTableViewCell
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.lbFieldName.text = "名"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvArrowDown.isHidden = true
            case 1:
                cell.lbFieldName.text = "姓"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvArrowDown.isHidden = true
            case 2:
                cell.lbFieldName.text = "出生日期"
                cell.txfEdit.isHidden = true
                cell.imgvArrowDown.isHidden = false
            case 3:
                cell.lbFieldName.text = "電子信箱"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = ""
                cell.imgvArrowDown.isHidden = true
            case 4:
                cell.lbFieldName.text = "手機號碼"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvArrowDown.isHidden = true
            case 5:
                cell.lbFieldName.text = "地址"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvArrowDown.isHidden = true
            default:
                break
            }
            return cell
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                cell.lbFieldName.text = "性別"
                cell.txfEdit.isHidden = true
                cell.imgvArrowDown.isHidden = false
            case 1:
                cell.lbFieldName.text = "身高"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvArrowDown.isHidden = true
            case 2:
                cell.lbFieldName.text = "體重"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.imgvArrowDown.isHidden = true
            case 3:
                cell.lbFieldName.text = "種族"
                cell.txfEdit.isHidden = true
                cell.imgvArrowDown.isHidden = false
            case 4:
                cell.lbFieldName.text = "飲酒"
                cell.txfEdit.isHidden = true
                cell.imgvArrowDown.isHidden = false
            case 5:
                cell.lbFieldName.text = "抽菸"
                cell.txfEdit.isHidden = true
                cell.imgvArrowDown.isHidden = false
                
            default:
                break
            }
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
