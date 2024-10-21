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
    @IBOutlet weak var dpkBirthday: UIDatePicker!
    @IBOutlet weak var Toolbar: UIToolbar!
    @IBOutlet weak var btnNext: UIButton!
    // MARK: - Property
    
    var btnDone: Bool = false
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    // MARK: - UI Settings
    func setUI() {
        setNavigationBar()
        setTableView()
        dpkBirthday.locale = Locale(identifier: "zh_TW")
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
    @IBAction func confirmPickerView(_ sender: Any) {
        Toolbar.isHidden = true
        dpkBirthday.isHidden = true
        btnDone = true
        btnNext.isHidden = false
        
        let chosenDate = dpkBirthday.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: chosenDate)
        
        // 更新表格中的出生日期
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
        cell.lbResult.isHidden = false
        cell.lbResult.text = dateString
    }
    
    @IBAction func cancelPickerView(_ sender: Any) {
        Toolbar.isHidden = true
        dpkBirthday.isHidden = true
        btnDone = false
        btnNext.isHidden = false
    }
    
    @IBAction func Next(_ sender: Any) {
        // 獲取其他用戶資訊
        let firstName = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let lastName = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let dateString = (tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! PersonalInfoTableViewCell).lbResult.text ?? ""
        let email = (tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let phone = (tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let address = (tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        
        // 獲取永久性資料
        let gender = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let height = (tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let weight = (tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let race = (tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let smoke = (tableView.cellForRow(at: IndexPath(row: 4, section: 1)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let liquor = (tableView.cellForRow(at: IndexPath(row: 5, section: 1)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        
        // 檢查永久性資料欄位是否空
        if gender.isEmpty || race.isEmpty || smoke.isEmpty || liquor.isEmpty {
            // 顯示警告
            let alert = UIAlertController(title: "錯誤", message: "所有永久性資料欄位都不可為空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // 檢查出生日期是否超過今天
        if dpkBirthday.date > Date() {
            let alert = UIAlertController(title: "錯誤", message: "出生日期不可超過今天", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // 創建 UserInformation 實例
        let userInfo = UserInformation()
        userInfo.FirstName = firstName
        userInfo.LastName = lastName
        userInfo.Birthday = dateString
        userInfo.Email = email
        userInfo.Phone = phone
        userInfo.Address = address
        userInfo.Gender = gender
        userInfo.Height = height
        userInfo.Weight = weight
        userInfo.Race = race
        userInfo.Smoke = smoke
        userInfo.Liquor = liquor

        // 儲存到 Realm
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(userInfo)
            }
            print("使用者資訊已成功儲存！")
        } catch {
            print("儲存使用者資訊時出現錯誤: \(error)")
        }
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension BodyInformationViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonalInfoTableViewCell.identifier, for: indexPath) as! PersonalInfoTableViewCell
        
        cell.lbResult.isHidden = true
        cell.txfEdit.delegate = self
        
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
                cell.txfEdit.text = UserPreferences.shared.mail
                cell.imgvArrowDown.isHidden = true
            case 4:
                cell.lbFieldName.text = "手機號碼"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.txfEdit.keyboardType = .numberPad
                cell.txfEdit.tag = 1
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
                cell.txfEdit.keyboardType = .numberPad
                cell.txfEdit.tag = 2
                cell.imgvArrowDown.isHidden = true
            case 2:
                cell.lbFieldName.text = "體重"
                cell.txfEdit.isHidden = false
                cell.txfEdit.placeholder = "點擊進行編輯"
                cell.txfEdit.keyboardType = .numberPad
                cell.txfEdit.tag = 3
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                // 動畫顯示
                UIView.transition(with: dpkBirthday, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
                dpkBirthday.isHidden.toggle()
                
                UIView.transition(with: Toolbar, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
                Toolbar.isHidden.toggle()
                
                btnNext.isHidden = true
            }
        } else {
            switch indexPath.row {
            case 0:
                let alert = UIAlertController( title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.view.tintColor = UIColor.mainColor
                
                let maleAction = UIAlertAction(title: "生理男", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "生理男"
                }
                let femaleAction = UIAlertAction(title: "生理女", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "生理女"
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                alert.addAction(maleAction)
                alert.addAction(femaleAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            case 3:
                let alert = UIAlertController( title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.view.tintColor = UIColor.mainColor
                
                let oneAction = UIAlertAction(title: "亞洲", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "亞洲"
                }
                let twoAction = UIAlertAction(title: "非洲", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "非洲"
                }
                
                let threeAction = UIAlertAction(title: "高加索", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "高加索"
                }
                
                let fourAction = UIAlertAction(title: "拉丁", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "拉丁"
                }
                
                let fiveAction = UIAlertAction(title: "其他", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "其他"
                }
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                alert.addAction(oneAction)
                alert.addAction(twoAction)
                alert.addAction(threeAction)
                alert.addAction(fourAction)
                alert.addAction(fiveAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            case 4:
                let alert = UIAlertController( title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.view.tintColor = UIColor.mainColor
                
                let oneAction = UIAlertAction(title: "不喝酒", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "不喝酒"
                }
                let twoAction = UIAlertAction(title: "偶爾喝", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "偶爾喝"
                }
                
                let threeAction = UIAlertAction(title: "經常喝", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "經常喝"
                }
                
                let fourAction = UIAlertAction(title: "每天喝", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "每天喝"
                }
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                alert.addAction(oneAction)
                alert.addAction(twoAction)
                alert.addAction(threeAction)
                alert.addAction(fourAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            case 5:
                let alert = UIAlertController( title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.view.tintColor = UIColor.mainColor
                
                let yesAction = UIAlertAction(title: "有", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "有"
                }
                let noAction = UIAlertAction(title: "無", style: .default) { _ in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = "無"
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
        case 1: // 手機號碼
            return newString.length <= 10
        case 2: // 身高
            return newString.length <= 3
        case 3: // 體重
            return newString.length <= 3
        default:
            return true
        }
    }
}
