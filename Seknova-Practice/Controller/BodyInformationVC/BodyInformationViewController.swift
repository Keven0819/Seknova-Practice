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
        
        let gender = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! PersonalInfoTableViewCell).lbResult.text ?? ""
        let height = (tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let weight = (tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! PersonalInfoTableViewCell).txfEdit.text ?? ""
        let race = (tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as! PersonalInfoTableViewCell).lbResult.text ?? ""
        let smoke = (tableView.cellForRow(at: IndexPath(row: 4, section: 1)) as! PersonalInfoTableViewCell).lbResult.text ?? ""
        let liquor = (tableView.cellForRow(at: IndexPath(row: 5, section: 1)) as! PersonalInfoTableViewCell).lbResult.text ?? ""
        
        let alert = Alert()
        
        // 檢查資料是否為空
        switch (firstName.isEmpty, lastName.isEmpty, dateString.isEmpty, email.isEmpty, race.isEmpty, smoke.isEmpty, liquor.isEmpty
            , height.isEmpty, weight.isEmpty) {
        case (true, _, _, _, _, _, _, _, _):
            
            alert.showAlert(title: "錯誤", message: "名字不可為空", vc: self, action: {})
            
        case (_, true, _, _, _, _, _, _, _):
            
            alert.showAlert(title: "錯誤", message: "姓氏不可為空", vc: self, action: {})
            
        case (_, _, true, _, _, _, _, _, _):
            
            alert.showAlert(title: "錯誤", message: "日期不可為空", vc: self, action: {})
            
        case (_, _, _, true, _, _, _, _, _):
            
            alert.showAlert(title: "錯誤", message: "信箱不可為空", vc: self, action: {})
            
        case (_, _, _, _, true, _, _, _, _):
            
            alert.showAlert(title: "錯誤", message: "種族不可為空", vc: self, action: {})
            
        case (_, _, _, _, _, true, _, _, _):
            
            alert.showAlert(title: "錯誤", message: "吸菸狀況不可為空", vc: self, action: {})
            
        case (_, _, _, _, _, _, true, _, _):
            
            alert.showAlert(title: "錯誤", message: "飲酒狀況不可為空", vc: self, action: {})
            
        case (_, _, _, _, _, _, _, true, _):
            
            alert.showAlert(title: "錯誤", message: "身高不可為空", vc: self, action: {})
            
        case (_, _, _, _, _, _, _, _, true):
            
            alert.showAlert(title: "錯誤", message: "體重不可為空", vc: self, action: {})
            
        default:
            // 所有欄位都已填寫，繼續後續的程式邏輯
            let checked = true
            let phone_verified = true
            // 創建 UserInformation 實例
            let userInfo = UserInformation(
                FirstName: firstName,
                LastName: lastName,
                Birthday: dateString,
                Email: email,
                Phone: phone,
                Address: address,
                Gender: gender,
                Height: height,
                Weight: weight,
                Race: race,
                Liquor: liquor,
                Smoke: smoke,
                Check: checked,
                Phone_Verified: phone_verified)

            // 儲存到 Realm
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(userInfo)
                }
                print("使用者資訊已成功儲存！")
                print("fileURL: \(realm.configuration.fileURL!)")
            } catch {
                print("儲存使用者資訊時出現錯誤: \(error)")
            }
            break
        }
        let VideoVC = AudioVisualTeachingViewController()
        self.navigationItem.title = ""
        self.navigationItem.backButtonTitle = "Back"
        self.navigationController?.pushViewController(VideoVC, animated: true)
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
            
            let alert = Alert()
            
            switch indexPath.row {
                
            case 0:
                
                let title = ["生理男", "生理女", "其他"]
                
                alert.showActionSheet(titles: title, cancelTitle: "取消", vc: self) { result in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = result
                }
                
            case 3:
                
                let title = ["亞洲", "非洲", "高加索", "拉丁", "其他"]
                
                alert.showActionSheet(titles: title, cancelTitle: "取消", vc: self) { result in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = result
                }
                
            case 4:
                
                let title = ["不喝酒", "偶爾喝", "經常喝", "每天喝"]
                
                alert.showActionSheet(titles: title, cancelTitle: "取消", vc: self) { result in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = result
                }
                
            case 5:
                
                let title = ["有", "無"]
                
                alert.showActionSheet(titles: title, cancelTitle: "取消", vc: self) { result in
                    let cell = tableView.cellForRow(at: indexPath) as! PersonalInfoTableViewCell
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = result
                }
                
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
