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
    @IBOutlet weak var btnConfirm: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnToolbarCancel: UIBarButtonItem!
    @IBOutlet weak var btnToolbarConfirm: UIBarButtonItem!
    
    // MARK: - Property
    
    private var userInformation: UserInformation?
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    private func setupUI() {
        setupTableView()
        setupDatePicker()
        setupBackgroundTapGesture()
        btnToolbarCancel.title = NSLocalizedString("Cancel", comment: "")
        btnToolbarConfirm.title = NSLocalizedString("Confirm", comment: "")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 40
        tableView.register(UINib(nibName: "InfoTableViewCell", bundle: nil),
                         forCellReuseIdentifier: InfoTableViewCell.identifier)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupDatePicker() {
        dpkBirthday.datePickerMode = .date
        if NSLocale.current.language.languageCode?.identifier == "en" {
            dpkBirthday.locale = Locale(identifier: "en")
        } else {
            dpkBirthday.locale = Locale(identifier: "zh_TW")
        }
        dpkBirthday.maximumDate = Date() // 設置最大日期為今天
        hideDatePickerViews()
    }
    
    private func setupBackgroundTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                               action: #selector(handleBackgroundTap))
        vDpkBackground.addGestureRecognizer(tapGesture)
    }
    // MARK: - IBAction
    @IBAction func doneDatePicker(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: dpkBirthday.date)
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? InfoTableViewCell {
            cell.lbResult.text = selectedDate
            updateUserData(selectedDate, for: "Birthday")
        }
        
        // 隱藏 DatePicker 相關視圖
        hideDatePickerViews()
    }
    @IBAction func cancelDatePicker(_ sender: Any) {
        // 直接隱藏 DatePicker 相關視圖，不更新值
        hideDatePickerViews()
    }
    
    @objc private func handleBackgroundTap() {
        hideDatePickerViews()
    }
    
    @objc private func logoutButtonTapped() {
        print("Logout button tapped") // 用於測試按鈕是否被點擊
        
        let alert = UIAlertController(title: NSLocalizedString("Are you sure you want to log out ?", comment: ""),
                                     message: nil,
                                     preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                        style: .cancel,
                                        handler: nil)
        
        let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""),
                                         style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
            // 返回之後，將返回到的頁面的TextField清空
            if let loginVC = self?.navigationController?.viewControllers.first as? LoginViewController {
                loginVC.txfUserName.text = ""
                loginVC.txfPassword.text = ""
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    // MARK: - Function
    private func hideDatePickerViews() {
        dpkBirthday.isHidden = true
        vDpkBackground.isHidden = true
        dpkToolBar.isHidden = true
    }
    
    private func loadUserData() {
        let realm = try! Realm()
        userInformation = realm.objects(UserInformation.self).first
        print("Realm 資料庫位置: \(realm.configuration.fileURL!)")
        tableView.reloadData()
    }
    
    private func updateUserData(_ data: String, for field: String) {
        guard let userInfo = userInformation else { return }
        let realm = try! Realm()
        
        try! realm.write {
            switch field {
            case "FirstName": userInfo.FirstName = data
            case "LastName": userInfo.LastName = data
            case "Birthday": userInfo.Birthday = data
            case "Email": userInfo.Email = data
            case "Phone": userInfo.Phone = data
            case "Address": userInfo.Address = data
            case "Gender": userInfo.Gender = data
            case "Height": userInfo.Height = data
            case "Weight": userInfo.Weight = data
            case "Race": userInfo.Race = data
            case "Liquor": userInfo.Liquor = data
            case "Smoke": userInfo.Smoke = data
            default: break
            }
        }
    }
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
            return NSLocalizedString("Personal information", comment: "")
        case 1:
            return NSLocalizedString("Body value", comment: "")
        case 2:
            return NSLocalizedString("Account", comment: "")
        case 3:
            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        let realm = try! Realm()
        let userInformation = realm.objects(UserInformation.self)
        // 將 Results 轉換為 Array，並取最新的資料
        let userInformations = Array(arrayLiteral: userInformation.last ?? UserInformation())
        
        cell.lbName.isHidden = false
        cell.lbResult.isHidden = true
        cell.txfEdit.isHidden = true
        cell.lbPhonenumber.isHidden = true
        cell.imgvPhoneStatus.isHidden = true
        cell.btnLogOut.isHidden = true
        cell.accessoryType = .none
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.lbName.text = NSLocalizedString("FirstName", comment: "")
                cell.txfEdit.isHidden = false
                if userInformations[0].FirstName.isEmpty == false {
                    cell.txfEdit.text = userInformations[0].FirstName
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = NSLocalizedString("Click to edit", comment: "")
                }
            case 1:
                cell.lbName.text = NSLocalizedString("LastName", comment: "")
                cell.txfEdit.isHidden = false
                if userInformations[0].LastName.isEmpty == false {
                    cell.txfEdit.text = userInformations[0].LastName
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = NSLocalizedString("Click to edit", comment: "")
                }
            case 2:
                cell.lbName.text = NSLocalizedString("Birthday", comment: "")
                if userInformations[0].Birthday.isEmpty == false {
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = userInformations[0].Birthday
                } else {
                    cell.lbResult.isHidden = true
                }
            case 3:
                cell.lbName.text = NSLocalizedString("Email", comment: "")
                cell.txfEdit.isHidden = false
                if userInformations[0].Email.isEmpty == false {
                    cell.txfEdit.text = userInformations[0].Email
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = NSLocalizedString("Click to edit", comment: "")
                }
            case 4:
                cell.lbName.text = NSLocalizedString("Phone", comment: "")
                cell.lbPhonenumber.isHidden = false
                cell.imgvPhoneStatus.isHidden = false
                if userInformations[0].Phone.isEmpty == false {
                    cell.lbPhonenumber.text = "+886 " +  userInformations[0].Phone
                    cell.imgvPhoneStatus.image = UIImage(named: "phone_verified")
                } else {
                    cell.lbPhonenumber.text = "+886"
                    cell.imgvPhoneStatus.image = UIImage(named: "phone_alarm")
                }
            case 5:
                cell.lbName.text = NSLocalizedString("Address", comment: "")
                cell.txfEdit.isHidden = false
                if userInformations[0].Address.isEmpty == false {
                    cell.txfEdit.text = userInformations[0].Address
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = NSLocalizedString("Click to edit", comment: "")
                }
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.lbName.text = NSLocalizedString("Gender", comment: "")
                if userInformations[0].Gender.isEmpty == false {
                    cell.lbResult.isHidden = false
                    
                    if let languageCode = NSLocale.current.language.languageCode?.identifier {
                        if languageCode == "en" {
                            // 中文轉英文
                            if userInformations[0].Gender == "男性" {
                                cell.lbResult.text = "Male"
                            } else if userInformations[0].Gender == "女性" {
                                cell.lbResult.text = "Female"
                            } else {
                                cell.lbResult.text = userInformations[0].Gender // 預設不變
                            }
                        } else {
                            // 英文轉中文
                            if userInformations[0].Gender == "Male" {
                                cell.lbResult.text = "男性"
                            } else if userInformations[0].Gender == "Female" {
                                cell.lbResult.text = "女性"
                            } else {
                                cell.lbResult.text = userInformations[0].Gender // 預設不變
                            }
                        }
                    }

                    
                } else {
                    cell.lbResult.isHidden = true
                }
            case 1:
                cell.lbName.text = NSLocalizedString("Height", comment: "")
                cell.txfEdit.isHidden = false
                if userInformations[0].Height.isEmpty == false {
                    cell.txfEdit.text = userInformations[0].Height
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = NSLocalizedString("Click to edit", comment: "")
                }
                cell.txfEdit.tag = 1
            case 2:
                cell.lbName.text = NSLocalizedString("Weight", comment: "")
                cell.txfEdit.isHidden = false
                if userInformations[0].Weight.isEmpty == false {
                    cell.txfEdit.text = userInformations[0].Weight
                } else {
                    cell.txfEdit.text = ""
                    cell.txfEdit.placeholder = NSLocalizedString("Click to edit", comment: "")
                }
                cell.txfEdit.tag = 2
            case 3:
                cell.lbName.text = NSLocalizedString("Race", comment: "")
                if userInformations[0].Race.isEmpty == false {
                    cell.lbResult.isHidden = false
                    
                    if let languageCode = NSLocale.current.language.languageCode?.identifier {
                        if languageCode == "en" {
                            // 中文轉英文
                            if let localizedRace = [
                                "亞洲": "Asia",
                                "非洲": "Africa",
                                "高加索": "Caucasus",
                                "拉丁": "Latin"
                            ][userInformations[0].Race] {
                                cell.lbResult.text = localizedRace
                            } else {
                                cell.lbResult.text = userInformations[0].Race // 預設不變
                            }
                        } else {
                            // 英文轉中文
                            if let localizedRace = [
                                "Asia": "亞洲",
                                "Africa": "非洲",
                                "Caucasus": "高加索",
                                "Latin": "拉丁"
                            ][userInformations[0].Race] {
                                cell.lbResult.text = localizedRace
                            } else {
                                cell.lbResult.text = userInformations[0].Race // 預設不變
                            }
                        }
                    }

                    
                } else {
                    cell.lbResult.isHidden = true
                }
            case 4:
                cell.lbName.text = NSLocalizedString("Liquor", comment: "")
                if userInformations[0].Liquor.isEmpty == false {
                    cell.lbResult.isHidden = false
                    
                    if let languageCode = NSLocale.current.language.languageCode?.identifier {
                        if languageCode == "en" {
                            // 中文轉英文
                            if let localizedDrink = [
                                "不喝酒": "Don't drink",
                                "偶爾喝": "Drink occasionally",
                                "經常喝": "Drink often",
                                "每天喝": "Drink every day"
                            ][userInformations[0].Liquor] {
                                cell.lbResult.text = localizedDrink
                            } else {
                                cell.lbResult.text = userInformations[0].Liquor // 預設不變
                            }
                        } else {
                            // 英文轉中文
                            if let localizedDrink = [
                                "Don't drink": "不喝酒",
                                "Drink occasionally": "偶爾喝",
                                "Drink often": "經常喝",
                                "Drink every day": "每天喝"
                            ][userInformations[0].Liquor] {
                                cell.lbResult.text = localizedDrink
                            } else {
                                cell.lbResult.text = userInformations[0].Liquor // 預設不變
                            }
                        }
                    }
                } else {
                    cell.lbResult.isHidden = true
                }
            case 5:
                cell.lbName.text = NSLocalizedString("Smoke", comment: "")
                if userInformations[0].Smoke.isEmpty == false {
                    cell.lbResult.isHidden = false
                    
                    if let languageCode = NSLocale.current.language.languageCode?.identifier {
                        if languageCode == "en" {
                            // 中文轉英文
                            if let localizedSmoking = [
                                "有": "Yes",
                                "無": "No"
                            ][userInformations[0].Smoke] {
                                cell.lbResult.text = localizedSmoking
                            } else {
                                cell.lbResult.text = userInformations[0].Smoke // 預設不變
                            }
                        } else {
                            // 英文轉中文
                            if let localizedSmoking = [
                                "Yes": "有",
                                "No": "無"
                            ][userInformations[0].Smoke] {
                                cell.lbResult.text = localizedSmoking
                            } else {
                                cell.lbResult.text = userInformations[0].Smoke // 預設不變
                            }
                        }
                    }


                } else {
                    cell.lbResult.isHidden = true
                }
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.lbName.text = NSLocalizedString("Transmitter Device", comment: "")
                if UserPreferences.shared.transmitterDeviceID?.isEmpty == false {
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = UserPreferences.shared.transmitterDeviceID
                } else {
                    cell.lbResult.isHidden = true
                }
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.lbName.text = NSLocalizedString("Sensor Device", comment: "")
                if UserPreferences.shared.sensorDeviceID?.isEmpty == false {
                    cell.lbResult.isHidden = false
                    cell.lbResult.text = UserPreferences.shared.sensorDeviceID
                } else {
                    cell.lbResult.isHidden = true
                }
                cell.accessoryType = .disclosureIndicator
            case 2:
                cell.lbName.text = NSLocalizedString("Change Password", comment: "")
                cell.accessoryType = .disclosureIndicator
            default:
                break
            }
        case 3:
            cell.lbName.isHidden = true
            cell.btnLogOut.isHidden = false
            // 直接在這裡添加按鈕事件
            cell.btnLogOut.addTarget(self,
                                    action: #selector(logoutButtonTapped),
                                    for: .touchUpInside)
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 直接使用 cellForRow 獲取現有的單元格
        if let cell = tableView.cellForRow(at: indexPath) as? InfoTableViewCell {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 2:
                    // 出生日期
                    dpkToolBar.isHidden = false
                    dpkBirthday.isHidden = false
                    vDpkBackground.isHidden = false
                case 4:
                    // 手機號碼
                    let bindVC = BindPhoneViewController()
                    navigationController?.pushViewController(bindVC, animated: true)
                default:
                    break
                }
            case 1:
                let alert = Alert()
                switch indexPath.row {
                case 0:
                    // 性別
                    let titles = [NSLocalizedString("Male", comment: ""), NSLocalizedString("Female", comment: ""), NSLocalizedString("Others", comment: "")]
                    alert.showActionSheet(titles: titles, cancelTitle: NSLocalizedString("Cancel", comment: ""), vc: self) { result in
                        cell.lbResult.text = result
                    }
                case 3:
                    // 種族
                    let titles = [NSLocalizedString("Asia", comment: ""), NSLocalizedString("Africa", comment: ""), NSLocalizedString("Caucasus", comment: ""), NSLocalizedString("Latin", comment: ""), NSLocalizedString("Others", comment: "")]
                    alert.showActionSheet(titles: titles, cancelTitle: NSLocalizedString("Cancel", comment: ""), vc: self) { result in
                        cell.lbResult.text = result
                    }
                case 4:
                    // 飲酒
                    let titles = [NSLocalizedString("Don't drink", comment: ""), NSLocalizedString("Drink occasionally", comment: ""), NSLocalizedString("Drink often", comment: ""), NSLocalizedString("Drink every day", comment: "")]
                    alert.showActionSheet(titles: titles, cancelTitle: NSLocalizedString("Cancel", comment: ""), vc: self) { result in
                        cell.lbResult.text = result
                    }
                case 5:
                    // 抽菸
                    let titles = [NSLocalizedString("Yes", comment: ""), NSLocalizedString("No", comment: "")]
                    alert.showActionSheet(titles: titles, cancelTitle: NSLocalizedString("Cancel", comment: ""), vc: self) { result in
                        cell.lbResult.text = result
                    }
                default:
                    break
                }
            case 2:
                switch indexPath.row {
                case 2:
                    let resetPasswordVC = ResetPasswordViewController()
                    navigationController?.pushViewController(resetPasswordVC, animated: true)
                default:
                    break
                }
            case 3:
                switch indexPath.row {
                case 0:
                    let alert = UIAlertController(title: NSLocalizedString("Are you sure you want to log out ?", comment: ""), message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default) { _ in
                        // 回到 LoginViewController 並清除輸入框
                        if let navigationController = self.navigationController,
                           let loginVC = navigationController.viewControllers.first as? LoginViewController {
                            // 清除登入頁面的輸入框
                            loginVC.txfUserName.text = ""
                            loginVC.txfPassword.text = ""
                            // 返回到登入頁面
                            navigationController.popToViewController(loginVC, animated: true)
                        }
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(confirmAction)
                    present(alert, animated: true, completion: nil)
                default:
                    break
                }
            default:
                break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        switch textField.tag {
        case 1: // 身高
            return newString.length <= 3
        case 2: // 體重
            return newString.length <= 3
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell = textField.superview?.superview as? InfoTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }
        
        let text = textField.text ?? ""
        switch (indexPath.section, indexPath.row) {
        case (0, 0): updateUserData(text, for: "FirstName")
        case (0, 1): updateUserData(text, for: "LastName")
        case (0, 3): updateUserData(text, for: "Email")
        case (0, 5): updateUserData(text, for: "Address")
        case (1, 1): updateUserData(text, for: "Height")
        case (1, 2): updateUserData(text, for: "Weight")
        default: break
        }
    }
}
