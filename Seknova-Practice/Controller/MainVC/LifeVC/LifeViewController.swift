//
//  LifeViewController.swift
//  Seknova-Practice
//
//  Created by imac-1681 on 2024/10/23.
//

import UIKit
import RealmSwift

struct LifeRoutineItem {
    var id: Int
    var title: String
    var image: UIImage
}

struct TableViewData {
    var title: String
    var subtitle: String?
    var txfValue: String?
}

// 用於儲存編輯模式的資料
class EventManager {
    static var isEditingModeNum: LifeEvents?
}

class LifeViewController: UIViewController {
    // MARk: - IBOutlet
    @IBOutlet var btnSelectDate: UIButton!
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var vDate: UIView!
    @IBOutlet var dpkDate: UIDatePicker!
    @IBOutlet var pkvDate: UIPickerView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var cvLife: UICollectionView!
    @IBOutlet var tbvLife: UITableView!
    @IBOutlet var vLifeSegc: UIView!
    @IBOutlet var cvLifeRoutin: UICollectionView!
    @IBOutlet var tbvLifeMain: UITableView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet weak var lbRecordTime: UILabel!
    // MARK: - Proprtty
    var vDisplay: Bool = false
    var isTableViewExpanded = false
    var isAnimating = false
    var isAnimatingHidding = false
    var firstIN: Bool = true
    var dateString: String = ""
    var lifeArr = [
            NSLocalizedString("Dining", comment: ""),
            NSLocalizedString("Exercise", comment: ""),
            NSLocalizedString("Sleeping", comment: ""),
            NSLocalizedString("Insulin", comment: ""),
            NSLocalizedString("Get up", comment: ""),
            NSLocalizedString("Bath", comment: ""),
            NSLocalizedString("Others", comment: "")
        ]
    let cellImages = [
        UIImage(named: "meal"),
        UIImage(named: "exercise"),
        UIImage(named: "sleep"),
        UIImage(named: "insulin"),
        UIImage(named: "awaken"),
        UIImage(named: "bath"),
        UIImage(named: "other")
    ]
    var lifeRoutineItems: [LifeRoutineItem] = []
    var tableData: [TableViewData] = []
    let hourArr = [0...23]
    let MinArr = [0...59]
    var flag: Bool = false
    var time = "00:30"
    var selectedHours: Int?
    var selectedMinutes: Int?
    var notFirstSelect: Bool = true
    var selectedTag: Int = -1
    var selectedCollectionViewTag: Int = -1
    var selectedLifeRoutin: String = ""
    var mealName: String = ""
    var mealNum: String = ""
    var mealInfo: String = ""
    
    var exeName: String = ""
    var exeTime: String = ""
    var exeInfo: String = ""
    
    var DoseG: String = ""
    var DoseInfo: String = ""
    
    var sleepTime: String = ""
    var sleepInfo: String = ""
    
    var wakeUpInfo: String = ""
    var washInfo: String = ""
    var elseInfo: String = ""
    
    var saveTimeFormatter: String = ""
    
    private var selectedIndex: Int? = LifeEventData.shared.selectedCVTag0
    var originTag: Int = -1
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar()
        dpkDate.tag = 0
        viewDidLoadTime()
        vDate.isHidden = true
        vLifeSegc.isHidden = true
        tbvLife.isHidden = true
        tbvLifeMain.isHidden = true
        setUpCollectionView()
        tableSet()
        pkvSet()
        setCollectionViewCornerRadius(cvLifeRoutin)
        let realm = try! Realm()

        // 編輯模式
        if editOrNot.shared.isEditingMode {
            let selectedCVId0 = LifeEventData.shared.selectedCVTag0
            selectedTag = selectedCVId0
            originTag = selectedCVId0
            selectedCollectionViewTag = LifeEventData.shared.selectedCVTag1
            updateSelectedCellColor(selectedTag: selectedCVId0) // 更新選中顏色
            setLifeRoutineItems(for: selectedCVId0) // 更新 lifeRoutineItems
            updateTableViewData(selectedTag: selectedCVId0) // 更新 tableData
            
            if LifeEventData.shared.UUnum != nil {
                if let uuid = LifeEventData.shared.UUnum {
                    if let select = realm.objects(LifeEvents.self).filter("id = %@", uuid).first {
                        EventManager.isEditingModeNum = select
                        lbDate.text = select.dateTime
                    }
                }
            }
            btnAdd.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
            print("編輯模式")
            if selectedCVId0 < 4 {
                isAnimatingHidding = false
                isAnimating = true
                tbvLifeMain.isHidden = false
                tbvLife.isHidden = true
                vLifeSegc.isHidden = false
                animateUIViewAndTableView()
            } else {
                isAnimatingHidding = true
                isAnimating = false
                tbvLife.isHidden = false
                tbvLifeMain.isHidden = true
                vLifeSegc.isHidden = true
                hideLifeRoutineCollectionView()
            }
            
            switch selectedCVId0 {
            case 0:
                mealName = LifeEventData.shared.event1 ?? ""
                mealNum = LifeEventData.shared.event2 ?? ""
                mealInfo = LifeEventData.shared.event3 ?? ""
            case 1:
                exeName = LifeEventData.shared.event1 ?? ""
                exeTime = LifeEventData.shared.event2 ?? ""
                exeInfo = LifeEventData.shared.event3 ?? ""
            case 2:
                sleepTime = LifeEventData.shared.event1 ?? ""
                sleepInfo = LifeEventData.shared.event3 ?? ""
            case 3:
                DoseG = LifeEventData.shared.event1 ?? ""
                DoseInfo = LifeEventData.shared.event3 ?? ""
            case 4:
                wakeUpInfo = LifeEventData.shared.event3 ?? ""
            case 5:
                washInfo = LifeEventData.shared.event3 ?? ""
            case 6:
                elseInfo = LifeEventData.shared.event3 ?? ""
            default:
                break
            }
            changeTagToWord()
            cvLife.reloadData()
            cvLifeRoutin.reloadData()
        } else {
            print("editOrNot.shared.isEditIng = ",editOrNot.shared.isEditingMode)
            btnAdd.setTitle(NSLocalizedString("Insert", comment: ""), for: .normal)
        }
        
        lbRecordTime.text = NSLocalizedString("Record time", comment: "")
        
        if NSLocale.current.language.languageCode?.identifier == "en" {
            dpkDate.locale = Locale(identifier: "en")
        } else {
            dpkDate.locale = Locale(identifier: "zh_TW")
        }
    }
    // MARK: - UI Setting
    func setupLocalizedUI() {
        btnAdd.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
        btnSelectDate.setTitle(NSLocalizedString("Select Date", comment: ""), for: .normal)
    }
    
    
    func setupToolbar() {
        let leftItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(leftItemTapped))
        let midItem = UIBarButtonItem(title: "")
        let rightItem = UIBarButtonItem(title: NSLocalizedString("Complete", comment: ""), style: .plain, target: self, action: #selector(rightItemTapped))
        leftItem.tintColor = .black
        rightItem.tintColor = .black
        
        // 分開按鈕
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // 將按鈕加入toolbar
        toolBar.setItems([leftItem, flexibleSpace, midItem, flexibleSpace, rightItem], animated: false)
    }
    @objc func leftItemTapped(){
        vDate.isHidden = true
        vDisplay.toggle()
    }
    
    @objc func rightItemTapped(){
        if dpkDate.tag == 0 && !flag {
            dpkDate.maximumDate = Date()
            let selectDate = dpkDate.date
            print(pkvDate.tag)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd EEEE a hh:mm"
            if NSLocale.current.language.languageCode?.identifier == "en" {
                dateFormatter.locale = Locale(identifier: "en")
            } else {
                dateFormatter.locale = Locale(identifier: "zh_TW")
            }
            
            dateString = dateFormatter.string(from: selectDate)
            print(dateString)
            
            lbDate.text = dateString
            
        } else if pkvDate.tag == 1 {
            // 取得時間選擇器的時間 (小時和分鐘)
            
            let hours = pkvDate.selectedRow(inComponent: 0)
            let minutes = pkvDate.selectedRow(inComponent: 2)
            
            selectedHours = hours
            selectedMinutes = minutes
            
            // 格式化時間為 "00:00"
            let formattedTime = String(format: "%02d:%02d", hours, minutes)
            print(formattedTime)
            // 更新 TableView 中的 時長 欄位的 txfLifeEvent
            if let indexPath = tbvLifeMain.indexPathForSelectedRow {
                if let cell = tbvLifeMain.cellForRow(at: indexPath) as? LifeTableViewCell {
                    if cell.lbLifeEvent.text == NSLocalizedString("During Time", comment: "") && selectedTag == 1 {
                        cell.txfLifeEvent.placeholder = formattedTime
                        exeTime = formattedTime
                    } else if cell.lbLifeEvent.text == NSLocalizedString("During Time", comment: "") && selectedTag == 2 {
                        cell.txfLifeEvent.placeholder = formattedTime
                        sleepTime = formattedTime
                    }
                }
            }
            flag = false
            notFirstSelect = true
            tbvLifeMain.reloadData()
        }
        // 隱藏日期選擇視圖
        vDate.isHidden = true
        vDisplay.toggle()
    }
    
    func setUpCollectionView() {
        cvLife.register(UINib(nibName: "LifeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: LifeCollectionViewCell.identifiler)
        cvLife.delegate = self
        cvLife.dataSource = self
        cvLife.tag = 0
        // 設置 contentInset 使 collectionView 在 safeArea 內顯示
        cvLife.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // 設置 sectionInset，確保每個 section 邊緣也不會被擠壓
        if let layout = cvLife.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        cvLifeRoutin.register(UINib(nibName: "LifeRoutineCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: LifeRoutineCollectionViewCell.identifiler)
        cvLifeRoutin.delegate = self
        cvLifeRoutin.dataSource = self
        cvLifeRoutin.tag = 1
        // cvLifeRoutin.isUserInteractionEnabled = true
    }
    
    func tableSet() {
        tbvLife.register(UINib(nibName: "LifeTableViewCell", bundle: nil), forCellReuseIdentifier: LifeTableViewCell.identifiler)
        tbvLife.dataSource = self
        tbvLife.delegate = self
        tbvLife.tag = 1
        
        tbvLifeMain.register(UINib(nibName: "LifeTableViewCell", bundle: nil), forCellReuseIdentifier: LifeTableViewCell.identifiler)
        tbvLifeMain.register(UINib(nibName: "TxfGTableViewCell", bundle: nil), forCellReuseIdentifier: TxfGTableViewCell.identifiler)
        tbvLifeMain.dataSource = self
        tbvLifeMain.delegate = self
        tbvLifeMain.tag = 0
    }
    
    func setCollectionViewCornerRadius(_ collectionView: UICollectionView) {
        collectionView.layer.cornerRadius = 15  // 圓角半徑，調整此數值來改變圓角的程度
        collectionView.layer.masksToBounds = true  // 設置為 true，確保超出圓角區域的部分被裁剪
    }
    
    func updateTableViewData(selectedTag: Int) {
        switch selectedTag {
        case 0:
            if selectedTag == 0 {
                tableData = [
                    TableViewData(title: NSLocalizedString("Meal Name", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Add Product Name", comment: "")),
                    TableViewData(title: NSLocalizedString("Quantity", comment: ""), subtitle: nil, txfValue: ""),
                    TableViewData(title: NSLocalizedString("Note", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Additional Notes", comment: ""))
                ]
            }
            print(tableData)
            tbvLife.isHidden = true
        case 1:
            if selectedTag == 1 {
                tableData = [
                    TableViewData(title: NSLocalizedString("Exercise Type", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Add Product Name", comment: "")),
                    TableViewData(title: NSLocalizedString("During Time", comment: ""), subtitle: nil, txfValue: "00:30"),
                    TableViewData(title: NSLocalizedString("Note", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Additional Notes", comment: ""))
                ]
            }
            print(tableData)
            tbvLife.isHidden = true
        case 2:
            if selectedTag == 2 {
                tableData = [
                    TableViewData(title: NSLocalizedString("During Time", comment: ""), subtitle: nil, txfValue: "00:30"),
                    TableViewData(title: NSLocalizedString("Note", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Additional Notes", comment: ""))
                ]
            }
            tbvLife.isHidden = true
        case 3:
            if selectedTag == 3 {
                tableData = [
                    TableViewData(title: "", subtitle: nil, txfValue: ""),
                    TableViewData(title: NSLocalizedString("Note", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Additional Notes", comment: ""))
                ]
            }
            tbvLife.isHidden = true
        case 4:
            if selectedTag == 4 {
                tableData = [
                    TableViewData(title: NSLocalizedString("Note", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Additional Notes", comment: ""))
                ]
            }
            tbvLifeMain.isHidden = true
            
        case 5:
            if selectedTag == 5 {
                tableData = [
                    TableViewData(title: NSLocalizedString("Note", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Additional Notes", comment: ""))
                ]
            }
            tbvLifeMain.isHidden = true
            
        case 6:
            if selectedTag == 6 {
                tableData = [
                    TableViewData(title: NSLocalizedString("Note", comment: ""), subtitle: nil, txfValue: NSLocalizedString("Additional Notes", comment: ""))
                ]
            }
            tbvLifeMain.isHidden = true
            
        default:
            break
        }
        tbvLifeMain.reloadData()
        tbvLife.reloadData()
    }
    
    func pkvSet() {
        pkvDate.dataSource = self
        pkvDate.delegate = self
        pkvDate.tag = 1
    }
    // MARK: - IBAction
    @IBAction func select123(_ sender: Any) {
        vDisplay.toggle()
        dpkDate.isHidden = false
        pkvDate.isHidden = true
        vDate.isHidden = !vDisplay
    }
    
    @IBAction func addLifeRoutin(_ sender: Any) {
        print("按鈕觸發，模式：", editOrNot.shared.isEditingMode ? "編輯模式" : "普通模式")

        if selectedCollectionViewTag == -1 && selectedTag < 3 {
            let alertController = UIAlertController(
                title: NSLocalizedString("Error", comment: ""),
                message: NSLocalizedString("Please select an event", comment: ""),
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }

        
        var DataMealName = ""
        var DataMealNum = ""
        
        var DataExeName = ""
        var DataExeTime = ""
        
        var DataDoseG = ""
        
        var DataSleepTime = ""
        
        var note = ""
        var displayTime = ""
        
        switch selectedTag {
        case 0:
            DataMealName = mealName
            DataMealNum = mealNum
            note = mealInfo
            print(mealName,mealNum,mealInfo)
        case 1:
            DataExeName = exeName
            DataExeTime = exeTime
            note = exeInfo
            print(exeName,exeTime,exeInfo)
        case 2:
            DataSleepTime = sleepTime
            note = sleepInfo
            print(sleepTime,sleepInfo)
        case 3:
            DataDoseG = String(DoseG)
            note = DoseInfo
            print(DoseG,DoseInfo)
        case 4:
            note = wakeUpInfo
            print(wakeUpInfo)
        case 5:
            note = washInfo
            print(washInfo)
        case 6:
            note = elseInfo
            print(elseInfo)
        default:
            break
        }
        
        
        if let currentDateText = lbDate.text {
            let currentDateFormatter = DateFormatter()
            currentDateFormatter.dateFormat = "yyyy/MM/dd EEEE a hh:mm" // 假设当前的日期格式是这个
            if NSLocale.current.language.languageCode?.identifier == "en" {
                currentDateFormatter.locale = Locale(identifier: "en")
            } else {
                currentDateFormatter.locale = Locale(identifier: "zh_TW")
            }
            
            if let date = currentDateFormatter.date(from: currentDateText) {
                // 使用新的日期格式
                let newDateFormatter = DateFormatter()
                newDateFormatter.dateFormat = "MM/dd a hh:mm"
                
                if NSLocale.current.language.languageCode?.identifier == "en" {
                    newDateFormatter.locale = Locale(identifier: "en")
                } else {
                    newDateFormatter.locale = Locale(identifier: "zh_TW")
                }
                
                displayTime = newDateFormatter.string(from: date)
                print(displayTime)
                
            } else {
                print("解析日期失败")
            }
        } else {
            print("lbDate.text 为空")
        }
        
        let realm = try! Realm()
        if editOrNot.shared.isEditingMode, let uuid = LifeEventData.shared.UUnum {
            // 編輯模式：更新資料
            if let eventToUpdate = realm.objects(LifeEvents.self).filter("id == %@", uuid).first {
                try! realm.write {
                    eventToUpdate.event = selectedLifeRoutin
                    eventToUpdate.dateTime = lbDate.text ?? ""
                    eventToUpdate.displayTime = displayTime
                    eventToUpdate.mealName = DataMealName
                    eventToUpdate.mealNum = DataMealNum
                    eventToUpdate.exeName = DataExeName
                    eventToUpdate.exeTime = DataExeTime
                    eventToUpdate.doseG = DataDoseG
                    eventToUpdate.sleepTime = DataSleepTime
                    eventToUpdate.eventId = selectedTag
                    eventToUpdate.eventValue = selectedCollectionViewTag
                    eventToUpdate.note = note
                }
                print("資料更新成功：", eventToUpdate)
            } else {
                print("未找到對應的資料，UUID：", uuid)
            }
        } else {
            
            // 先確保 dateTime 可轉換為 Date 型別
            guard let eventDate = convertToDate(lbDate.text ?? "") else {
                print("日期轉換失敗")
                return
            }
            
            let event = LifeEvents(event: selectedLifeRoutin,
                                   dateTime: lbDate.text ?? "",
                                   displayTime: displayTime,
                                   timestamp: eventDate.timeIntervalSince1970, // 存入 UNIX timestamp
                                   mealName: DataMealName,
                                   mealNum: DataMealNum,
                                   exeName: DataExeName,
                                   exeTime: DataExeTime,
                                   doseG: DataDoseG,
                                   sleepTime: DataSleepTime,
                                   eventId: selectedTag,
                                   eventValue: selectedCollectionViewTag,
                                   note: note,
                                   check: false)
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(event)
            }
            
            print("Event saved to Realm with UUID:", event.id)
            print("fileURL: \(realm.configuration.fileURL!)")
            print("儲存進realm的資料：",event)
        }
        
        let LifeEventRecordVC = LifeEventRecordViewController()
        LifeEventRecordVC.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(LifeEventRecordVC, animated: false)
    }
    // MARK: - Function
    
    // 日期轉換函式
    func convertToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd EEEE a hh:mm"
        
        if NSLocale.current.language.languageCode?.identifier == "en" {
            formatter.locale = Locale(identifier: "en")
        } else {
            formatter.locale = Locale(identifier: "zh_TW")
        }
        
        return formatter.date(from: dateString)
    }
    
    func viewDidLoadTime() {
        dpkDate.maximumDate = Date()
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd EEEE a hh:mm"
        
        if NSLocale.current.language.languageCode?.identifier == "en" {
            dateFormatter.locale = Locale(identifier: "en")
        } else {
            dateFormatter.locale = Locale(identifier: "zh_TW")
        }
        
        let dateString = dateFormatter.string(from: currentDate)
        lbDate.text = dateString
    }
    
    func animateUIViewAndTableView() {
        // 避免重複動畫
        if isAnimating { return }
        print("OPen")
        let tableHeight: CGFloat = 200  // 假設展開的高度為 200
        
        // 動畫開始
        UIView.animate(withDuration: 0.2, animations: {
            // 讓 vLifeSegc 向下移動
            self.vLifeSegc.frame.origin.y += tableHeight
            self.tbvLifeMain.frame.origin.y += tableHeight
            self.cvLifeRoutin.alpha = 1.0
            self.vLifeSegc.alpha = 1.0
            
            // 如果 tableView 沒有展開，則顯示它，並更新資料源
            if !self.isTableViewExpanded {
                self.tbvLifeMain.isHidden = false
                self.tbvLifeMain.alpha = 0.0 // 初始透明度設為 0
                
                // 最後設置透明度為 1，完成展開動畫
                UIView.animate(withDuration: 0.5, animations: {
                    self.tbvLifeMain.alpha = 1.0
                })
                
                self.isTableViewExpanded = true
            }
        })
    }
    
    func hideLifeRoutineCollectionView() {
        // 避免重複動畫
        if isAnimatingHidding { return }
        
        
        print("hide")
        UIView.animate(withDuration: 0.3, animations: {
            self.vLifeSegc.frame.origin.y -= 200
            self.tbvLifeMain.frame.origin.y -= 200
            self.cvLifeRoutin.alpha = 0.0
            self.vLifeSegc.alpha = 0.0
        }) { _ in
            
            self.cvLifeRoutin.isHidden = true
            self.vLifeSegc.isHidden = true
        }
        isTableViewExpanded.toggle()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 检查是哪种类型的 cell
        if let cell = textField.superview?.superview as? LifeTableViewCell {
            handleLifeTableViewCell(textField: textField, cell: cell)
        } else if let cell1 = textField.superview?.superview as? TxfGTableViewCell {
            handleTxfGTableViewCell(textField: textField, cell: cell1)
        }
    }
    
    // 处理 LifeTableViewCell 的数据更新
    func handleLifeTableViewCell(textField: UITextField, cell: LifeTableViewCell) {
        if let indexPath = tbvLifeMain.indexPath(for: cell) {
            switch (selectedTag ,indexPath.row) {
            case(0,0):
                mealName = textField.text ?? ""
                tableData[0].txfValue = mealName  // 更新 tableData
                print("mealName: \(mealName)")
            case(0,1):
                mealNum = textField.text ?? ""
                tableData[1].txfValue = "\(mealNum)"  // 更新 tableData
                print("mealNum: \(mealNum)")
            case(0,2):
                mealInfo = textField.text ?? ""
                tableData[2].txfValue = mealInfo  // 更新 tableData
                print("mealInfo: \(mealInfo)")
            case(1,0):
                exeName = textField.text ?? ""
                tableData[indexPath.row].txfValue = exeName  // 更新 tableData
                print("exeName: \(exeName)")
            case(1,1):
                break
            case(1,2):
                exeInfo = textField.text ?? ""
                tableData[indexPath.row].txfValue = exeInfo  // 更新 tableData
                print("exeInfo: \(exeInfo)")
            case(2,0):
                break
            case(2,1):
                sleepInfo = textField.text ?? ""
                tableData[indexPath.row].txfValue = sleepInfo  // 更新 tableData
                print("sleepInfo: \(sleepInfo)")
            case(3,0):
                //                DoseG = textField.text ?? ""
                //                tableData[indexPath.row].txfValue = DoseG
                //                print("DoseG: \(DoseG)")
                break
            case(3,1):
                DoseInfo = textField.text ?? ""
                tableData[indexPath.row].txfValue = DoseInfo  // 更新 tableData
                print("DoseInfo: \(DoseInfo)")
                
            default:
                break
            }
        }
        if let indexPath = tbvLife.indexPath(for: cell) {
            switch (selectedTag ,indexPath.row) {
            case(4,0):
                wakeUpInfo = textField.text ?? ""
                tableData[indexPath.row].txfValue = wakeUpInfo  // 更新 tableData
                print("wakeUpInfo: \(wakeUpInfo)")
            case(5,0):
                washInfo = textField.text ?? ""
                tableData[indexPath.row].txfValue = washInfo  // 更新 tableData
                print("washInfo: \(washInfo)")
            case(6,0):
                elseInfo = textField.text ?? ""
                tableData[indexPath.row].txfValue = elseInfo  // 更新 tableData
                print("elseInfo: \(elseInfo)")
            default:
                break
            }
        }
    }
    
    // 处理 TxfGTableViewCell 的数据更新
    func handleTxfGTableViewCell(textField: UITextField, cell: TxfGTableViewCell) {
        if let indexPath = tbvLifeMain.indexPath(for: cell) {
            switch (selectedTag, indexPath.row) {
            case (3, 0):
                DoseG = textField.text ?? ""
                tableData[indexPath.row].txfValue = DoseG
                print("DoseG: \(DoseG)")
                //            case (3, 1):
                //                DoseInfo = textField.text ?? ""
                //                tableData[indexPath.row].txfValue = DoseInfo
                //                print("DoseInfo: \(DoseInfo)")
            default:
                break
            }
        }
    }
    
    func updateSelectedCellColor(selectedTag: Int) {
        for i in 0..<lifeArr.count {
            if let cell = cvLife.cellForItem(at: IndexPath(row: i, section: 0)) as? LifeCollectionViewCell {
                cell.vLifeBackground.backgroundColor = (i == selectedTag) ?
                UIColor(red: 195/255, green: 14/255, blue: 35/255, alpha: 1.0) : // 選中顏色
                UIColor(red: 255/255, green: 143/255, blue: 149/255, alpha: 1.0)  // 預設顏色
            }
        }
    }
    
    
    func setLifeRoutineItems(for selectedTag: Int) {
        switch selectedTag {
        case 0:
            lifeRoutineItems = [
                LifeRoutineItem(id: 0, title: NSLocalizedString("Breakfast", comment: ""), image: UIImage(named: "breakfast") ?? UIImage()),
                LifeRoutineItem(id: 1, title: NSLocalizedString("Lunch", comment: ""), image: UIImage(named: "launch") ?? UIImage()),
                LifeRoutineItem(id: 2, title: NSLocalizedString("Dinner", comment: ""), image: UIImage(named: "dinner") ?? UIImage()),
                LifeRoutineItem(id: 3, title: NSLocalizedString("Snack", comment: ""), image: UIImage(named: "snacks") ?? UIImage()),
                LifeRoutineItem(id: 4, title: NSLocalizedString("Drinks", comment: ""), image: UIImage(named: "drinks") ?? UIImage())
            ]
        case 1:
            lifeRoutineItems = [
                LifeRoutineItem(id: 0, title: NSLocalizedString("High Intensity", comment: ""), image: UIImage(named: "high_motion") ?? UIImage()),
                LifeRoutineItem(id: 1, title: NSLocalizedString("Medium Intensity", comment: ""), image: UIImage(named: "mid_motion") ?? UIImage()),
                LifeRoutineItem(id: 2, title: NSLocalizedString("Low Intensity", comment: ""), image: UIImage(named: "low_motion") ?? UIImage())
            ]
        case 2:
            lifeRoutineItems = [
                LifeRoutineItem(id: 0, title: NSLocalizedString("Sleep", comment: ""), image: UIImage(named: "sleep") ?? UIImage()),
                LifeRoutineItem(id: 1, title: NSLocalizedString("Nap", comment: ""), image: UIImage(named: "sleepy") ?? UIImage()),
                LifeRoutineItem(id: 2, title: NSLocalizedString("Rest", comment: ""), image: UIImage(named: "nap") ?? UIImage()),
                LifeRoutineItem(id: 3, title: NSLocalizedString("Relax time", comment: ""), image: UIImage(named: "relax") ?? UIImage())
            ]
        case 3:
            lifeRoutineItems = [
                LifeRoutineItem(id: 0, title: NSLocalizedString("Rapid acting", comment: ""), image: UIImage(named: "insulin") ?? UIImage()),
                LifeRoutineItem(id: 1, title: NSLocalizedString("Long acting", comment: ""), image: UIImage(named: "insulin") ?? UIImage()),
                LifeRoutineItem(id: 2, title: NSLocalizedString("Unspecified", comment: ""), image: UIImage(named: "insulin") ?? UIImage())
            ]
        case 4...6:
            lifeRoutineItems = []  // 空陣列時隱藏相關 UI
        default:
            break
        }
        cvLifeRoutin.reloadData()
    }
    
    
    func changeTagToWord() {
        switch selectedTag {
        case 0:
            switch selectedCollectionViewTag {
            case 0:
                selectedLifeRoutin = NSLocalizedString("Breakfast", comment: "")
            case 1:
                selectedLifeRoutin = NSLocalizedString("Lunch", comment: "")
            case 2:
                selectedLifeRoutin = NSLocalizedString("Dinner", comment: "")
            case 3:
                selectedLifeRoutin = NSLocalizedString("Snack", comment: "")
            case 4:
                selectedLifeRoutin = NSLocalizedString("Drinks", comment: "")
            default:
                break
            }
        case 1:
            switch selectedCollectionViewTag {
            case 0:
                selectedLifeRoutin = NSLocalizedString("High Intensity", comment: "")
            case 1:
                selectedLifeRoutin = NSLocalizedString("Medium Intensity", comment: "")
            case 2:
                selectedLifeRoutin = NSLocalizedString("Low Intensity", comment: "")
            default:
                break
            }
        case 2:
            switch selectedCollectionViewTag {
            case 0:
                selectedLifeRoutin = NSLocalizedString("Sleep", comment: "")
            case 1:
                selectedLifeRoutin = NSLocalizedString("Nap", comment: "")
            case 2:
                selectedLifeRoutin = NSLocalizedString("Rest", comment: "")
            case 3:
                selectedLifeRoutin = NSLocalizedString("Relax time", comment: "")
            default:
                break
            }
        case 3:
            switch selectedCollectionViewTag {
            case 0:
                selectedLifeRoutin = NSLocalizedString("Rapid acting", comment: "")
            case 1:
                selectedLifeRoutin = NSLocalizedString("Long acting", comment: "")
            case 2:
                selectedLifeRoutin = NSLocalizedString("Unspecified", comment: "")
            default:
                break
            }
        case 4:
            selectedLifeRoutin = NSLocalizedString("Get up", comment: "")
        case 5:
            selectedLifeRoutin = NSLocalizedString("Bath", comment: "")
        case 6:
            selectedLifeRoutin = NSLocalizedString("Others", comment: "")
        default:
            break
        }
        print(selectedLifeRoutin)
    }
}
// MARK: - Extensions
extension LifeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1:
            return 1
        case 2:
            return 60
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return NSLocalizedString("hour", comment: "")
        case 2:
            return "\(row)"
        case 3:
            return NSLocalizedString("minute", comment: "")
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if editOrNot.shared.isEditingMode {
            switch LifeEventData.shared.selectedCVTag0 {
            case 0: // 用餐
                let MainCell = tbvLifeMain.dequeueReusableCell(withIdentifier: LifeTableViewCell.identifiler, for: indexPath) as! LifeTableViewCell
                let tableDataItem = tableData[indexPath.row]
                
                // 初始化：清空 UITextField
                MainCell.txfLifeEvent.text = nil
                MainCell.txfLifeEvent.placeholder = nil
                // 設定標題
                MainCell.lbLifeEvent.text = tableDataItem.title
                
                // 根據已儲存的資料填充值
                switch indexPath.row {
                case 0:
                    if mealName.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = mealName
                    }
                case 1:
                    if mealNum.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = mealNum
                    }
                case 2:
                    if mealInfo.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = mealInfo
                    }
                default:
                    break
                }
                
                // 防止不可編輯欄位誤操作（僅示例）
                MainCell.txfLifeEvent.isUserInteractionEnabled = true
                
                // 監聽文字變化
                MainCell.txfLifeEvent.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return MainCell
                
            case 1: // 運動
                let MainCell = tbvLifeMain.dequeueReusableCell(withIdentifier: LifeTableViewCell.identifiler, for: indexPath) as! LifeTableViewCell
                let tableDataItem = tableData[indexPath.row]
                
                // 初始化：清空 UITextField
                MainCell.txfLifeEvent.text = nil
                MainCell.txfLifeEvent.placeholder = nil
                // 設定標題
                MainCell.lbLifeEvent.text = tableDataItem.title
                
                // 根據已儲存的資料填充值
                switch indexPath.row {
                case 0:
                    if exeName.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = exeName
                    }
                case 1:
                    if exeTime.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = exeTime
                    }
                case 2:
                    if exeInfo.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = exeInfo
                    }
                default:
                    break
                }
                
                // 防止不可編輯欄位誤操作
                MainCell.txfLifeEvent.isUserInteractionEnabled = indexPath.row != 1 // 時長不可編輯
                
                // 監聽文字變化
                MainCell.txfLifeEvent.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return MainCell
                
            case 2: // 睡眠
                let MainCell = tbvLifeMain.dequeueReusableCell(withIdentifier: LifeTableViewCell.identifiler, for: indexPath) as! LifeTableViewCell
                let tableDataItem = tableData[indexPath.row]
                
                // 初始化：清空 UITextField
                MainCell.txfLifeEvent.text = nil
                MainCell.txfLifeEvent.placeholder = nil
                // 設定標題
                MainCell.lbLifeEvent.text = tableDataItem.title
                
                // 根據已儲存的資料填充值
                switch indexPath.row {
                case 0:
                    if sleepTime.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = sleepTime
                    }
                    //                    MainCell.txfLifeEvent.text = LifeEventData.shared.event1 // event1 對應 時長
                case 1:
                    if sleepInfo.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = sleepInfo
                    }
                    //MainCell.txfLifeEvent.text = LifeEventData.shared.event3 // event3 對應 NSLocalizedString("Note", comment: "")
                default:
                    break
                }
                
                // 防止不可編輯欄位誤操作
                MainCell.txfLifeEvent.isUserInteractionEnabled = indexPath.row != 0 // 時長不可編輯
                
                // 監聽文字變化
                MainCell.txfLifeEvent.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return MainCell
                
            case 3:
                if indexPath.row == 0 {
                    // 直接初始化為 TxfGTableViewCell
                    let TxfGcell = tbvLifeMain.dequeueReusableCell(withIdentifier: TxfGTableViewCell.identifiler, for: indexPath) as! TxfGTableViewCell
                    TxfGcell.lbDose.text = NSLocalizedString("Dose", comment: "")
                    // 設定劑量的值
                    if String(DoseG).isEmpty {
                        TxfGcell.txfDose.placeholder = "---"
                    } else {
                        TxfGcell.txfDose.text = "\(DoseG)"
                    }
                    
                    // 增加文字輸入變化監聽
                    TxfGcell.txfDose.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                    
                    return TxfGcell
                } else if indexPath.row == 1 {
                    // 初始化為 LifeTableViewCell
                    let MainCell = tbvLifeMain.dequeueReusableCell(withIdentifier: LifeTableViewCell.identifiler, for: indexPath) as! LifeTableViewCell
                    let tableDataItem = tableData[indexPath.row]
                    
                    // 初始化 UITextField
                    MainCell.txfLifeEvent.text = nil
                    MainCell.txfLifeEvent.placeholder = nil
                    // 設定標題
                    MainCell.lbLifeEvent.text = tableDataItem.title
                    
                    // 填充數據
                    if DoseInfo.isEmpty {
                        MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        MainCell.txfLifeEvent.text = DoseInfo
                    }
                    
                    // 允許編輯
                    MainCell.txfLifeEvent.isUserInteractionEnabled = true
                    
                    // 增加文字輸入變化監聽
                    MainCell.txfLifeEvent.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                    
                    return MainCell
                }
                
                
            case 4, 5, 6: // 起床、洗澡、其他
                let ElseCell = tbvLife.dequeueReusableCell(withIdentifier: LifeTableViewCell.identifiler, for: indexPath) as! LifeTableViewCell
                let tableDataItem = tableData[indexPath.row]
                
                // 初始化：清空 UITextField
                ElseCell.txfLifeEvent.text = nil
                ElseCell.txfLifeEvent.placeholder = nil
                // 設定標題
                ElseCell.lbLifeEvent.text = tableDataItem.title
                
                // 根據已儲存的資料填充值
                switch (selectedTag, indexPath.row) {
                case (4, 0):
                    if wakeUpInfo.isEmpty {
                        ElseCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        ElseCell.txfLifeEvent.text = wakeUpInfo
                    }
                case (5, 0):
                    if washInfo.isEmpty {
                        ElseCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        ElseCell.txfLifeEvent.text = washInfo
                    }
                case (6, 0):
                    if elseInfo.isEmpty {
                        ElseCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        ElseCell.txfLifeEvent.text = elseInfo
                    }
                default:
                    break
                }
                
                // 監聽文字變化
                ElseCell.txfLifeEvent.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                return ElseCell
                
            default:
                return UITableViewCell()
            }
            
        } else {
            if tableView.tag == 0 {
                if selectedTag == 3 && indexPath.row == 0 {
                    let TxfGcell = tbvLifeMain.dequeueReusableCell(withIdentifier: TxfGTableViewCell.identifiler, for: indexPath) as! TxfGTableViewCell
                    TxfGcell.lbDose.text = NSLocalizedString("Dose", comment: "")
                    // 设置 txfLifeEvent 的值
                    if String(DoseG).isEmpty {
                        TxfGcell.txfDose.placeholder = "---"
                    } else {
                        TxfGcell.txfDose.text = "\(DoseG)"
                    }
                    
                    // 讓 txfLifeEvent 在編輯時儲存
                    TxfGcell.txfDose.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                    
                    
                    return TxfGcell
                } else {
                    let MainCell = tbvLifeMain.dequeueReusableCell(withIdentifier: LifeTableViewCell.identifiler, for: indexPath) as! LifeTableViewCell
                    let tableDataItem = tableData[indexPath.row]
                    
                    // 如果是時長的話不給輸入
                    if (indexPath.row == 0 && selectedTag == 2 ) || (selectedTag == 1 && indexPath.row == 1 ) {
                        MainCell.txfLifeEvent.isUserInteractionEnabled = false
                    } else {
                        MainCell.txfLifeEvent.isUserInteractionEnabled = true
                    }
                    
                    MainCell.lbLifeEvent.text = tableDataItem.title
                    MainCell.txfLifeEvent.text = ""
                    switch (selectedTag, indexPath.row) {
                    case (0, 0):
                        if mealName.isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.text = mealName
                        }
                        
                    case (0, 1):
                        if String(mealNum).isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.text = String(mealNum)
                        }
                        
                    case (0, 2):
                        if mealInfo.isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.text = mealInfo
                        }
                        
                    case (1, 0):
                        if exeName.isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.text = exeName
                        }
                    case (1,1):
                        if exeTime.isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.placeholder = exeTime
                        }
                        
                    case (1, 2):
                        if exeInfo.isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.text = exeInfo
                        }
                    case (2, 0):
                        if sleepTime.isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.placeholder = sleepTime
                        }
                        
                    case (2, 1):
                        if sleepInfo.isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.text = sleepInfo
                        }
                        
                    case (3, 0):
                        if String(DoseG) .isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.text = "\(DoseG)"
                        }
                        
                    case (3, 1):
                        if DoseInfo.isEmpty {
                            MainCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                        } else {
                            MainCell.txfLifeEvent.text = DoseInfo
                        }
                        
                        
                        
                    default:
                        MainCell.txfLifeEvent.text = tableDataItem.txfValue
                    }
                    
                    // 讓txf在編輯時儲存
                    MainCell.txfLifeEvent.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                    return MainCell
                }
            } else {
                let ElseCell = tbvLife.dequeueReusableCell(withIdentifier: LifeTableViewCell.identifiler, for: indexPath) as! LifeTableViewCell
                ElseCell.lbLifeEvent.text = NSLocalizedString("Note", comment: "")
                let tableDataItem = tableData[indexPath.row]
                ElseCell.txfLifeEvent.text = ""
                switch(selectedTag, indexPath.row) {
                case (4, 0):
                    if wakeUpInfo.isEmpty {
                        ElseCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        ElseCell.txfLifeEvent.text = wakeUpInfo
                    }
                    
                case (5, 0):
                    if washInfo.isEmpty {
                        ElseCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        ElseCell.txfLifeEvent.text = washInfo
                    }
                    
                case (6, 0):
                    if elseInfo.isEmpty {
                        ElseCell.txfLifeEvent.placeholder = tableDataItem.txfValue
                    } else {
                        ElseCell.txfLifeEvent.text = elseInfo
                    }
                default:
                    break
                }
                
                ElseCell.txfLifeEvent.addTarget(self,
                                                action: #selector(textFieldDidChange(_:)),
                                                for: .editingChanged)
                return ElseCell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            // 不需要重新建立 cell
            let data = tableData[indexPath.row]
            if data.title == NSLocalizedString("Note", comment: "") {
                return 80
            }
            return 50
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? LifeTableViewCell else { return }
        print(indexPath.row)
        let selectedData = tableData[indexPath.row]
        if selectedData.title == NSLocalizedString("During Time", comment: "") && selectedTag == 1 || selectedTag == 2 {
            vDate.isHidden = false
            dpkDate.isHidden = true
            pkvDate.isHidden = false
            pkvDate.tag = 1
            flag = true
            if !notFirstSelect {
                pkvDate.selectRow(0, inComponent: 0, animated: false)
                pkvDate.selectRow(0, inComponent: 1, animated: false)
                pkvDate.selectRow(30, inComponent: 2, animated: false)
                pkvDate.selectRow(0, inComponent: 3, animated: false)
                notFirstSelect = true
            } else {
                pkvDate.selectRow(selectedHours ?? 0, inComponent: 0, animated: false)
                pkvDate.selectRow(selectedMinutes ?? 30, inComponent: 2, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return 7
        } else if collectionView.tag == 1 {
            // collectionView.tag == 1 時根據 indexPath.row 返回不同數量的項目
            return lifeRoutineItems.count
        } else {
            // 如果是其他 tag 或者沒有特別處理的情況，默認返回 1 個項目
            return 1
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let originalColor = UIColor(red: 255/255, green: 143/255, blue: 149/255, alpha: 1.0)
            let selectedColor = UIColor(red: 195/255, green: 14/255, blue: 35/255, alpha: 1.0)
            let cell = cvLife.dequeueReusableCell(withReuseIdentifier: LifeCollectionViewCell.identifiler, for: indexPath)  as! LifeCollectionViewCell
            
            let size: CGFloat = 55 // 增加圓形的大小
            cell.vLifeBackground.frame.size = CGSize(width: size, height: size)
            
            // 設定每個cell的tag
            cell.tag = indexPath.row
            
            // 設置 cell 為圓形
            let radius = size / 2
            cell.vLifeBackground.layer.cornerRadius = radius
            //cell.vLifeBackground.layer.masksToBounds = true  // 確保內容不會超出圓形範圍
            
            let text = lifeArr[indexPath.row]  // 使用 indexPath.row 取得對應的文字
            cell.lbLife.text = text
            
            if let image = cellImages[indexPath.row] {
                cell.imgLife.image = image
            }
            
            // 檢查是否為選中的 Cell
            if indexPath.row == selectedTag {
                cell.vLifeBackground.backgroundColor = selectedColor
            } else {
                cell.vLifeBackground.backgroundColor = originalColor
            }
            
            return cell
        } else {
            let cell = cvLifeRoutin.dequeueReusableCell(withReuseIdentifier: LifeRoutineCollectionViewCell.identifiler, for: indexPath) as! LifeRoutineCollectionViewCell
            let selectedCV1Color = UIColor(red: 255/255, green: 143/255, blue: 149/255, alpha: 1.0)
            let originalCV1Color = UIColor.white
            let item = lifeRoutineItems[indexPath.row]
            cell.lbLifeRoutine.text = item.title
            cell.imgLifeRoutine.image = item.image
            
            cell.backgroundColor = originalCV1Color
            if editOrNot.shared.isEditingMode {
                // 如果 selectedCVTag1 為 -1，設置為白色
                if selectedCollectionViewTag == -1 {
                    cell.backgroundColor = originalCV1Color
                } else {
                    cell.backgroundColor = (indexPath.row == LifeEventData.shared.selectedCVTag1) ? selectedCV1Color : originalCV1Color
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView.tag == 0 {
            let width: CGFloat = 70 // 設置寬度為整個畫面寬度
            let height: CGFloat = 75 // 設置每個 cell 的高度為 50
            return CGSize(width: width, height: height)
        } else if collectionView.tag == 1 {
            let height: CGFloat = cvLifeRoutin.frame.height
            var width: CGFloat = 70
            let screenWidth = cvLifeRoutin.frame.width
            
            switch lifeRoutineItems.count {
            case 5:
                width = screenWidth * 0.2
            case 3:
                width = screenWidth * 0.333
            case 4:
                width = screenWidth * 0.25
            default:
                width = screenWidth * 0.2
            }
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 70, height: 75)
        }
    }
    
    
    // 設置每個 cell 之間的水平間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 設置項目間的最小間距為 0
    }
    
    // 如果您需要自定義每個 section 的邊界間距，也可以設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0) // 設置整個 section 的邊界
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // 設置整個 section 的邊界
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if editOrNot.shared.isEditingMode {
            if collectionView.tag == 0 {
                tbvLife.isHidden = false
                selectedTag = indexPath.row
                LifeEventData.shared.selectedCVTag0 = selectedTag
                selectedCollectionViewTag = -1
                
                for cell in cvLifeRoutin.visibleCells {
                    if let routineCell = cell as? LifeRoutineCollectionViewCell {
                        routineCell.backgroundColor = UIColor.white // 重置為原始顏色
                    }
                }
                cvLifeRoutin.reloadData()
                
                let selectedCVId0 = LifeEventData.shared.selectedCVTag0
                cvLifeRoutin.reloadData()
                cvLife.reloadData()
                print(originTag)
                print("selectedTag = \(selectedTag), LifeEventData.shared.selectedCVTag0 = \(LifeEventData.shared.selectedCVTag0)")
                
                setLifeRoutineItems(for: selectedTag)
                updateTableViewData(selectedTag: selectedTag)
                vLifeSegc.isHidden = false
                cvLifeRoutin.isHidden = false
                switch indexPath.row {
                case 0, 1, 2, 3:
                    animateUIViewAndTableView()
                    isAnimatingHidding = false
                    isAnimating = true
                    tbvLife.isHidden = true
                    tbvLifeMain.isHidden = false
                    vLifeSegc.isHidden = false
                case 4, 5, 6:
                    changeTagToWord()
                    hideLifeRoutineCollectionView()
                    isAnimatingHidding = true
                    isAnimating = false
                    vLifeSegc.isHidden = true
                    tbvLifeMain.isHidden = true
                    tbvLife.isHidden = false
                default:
                    break
                }
            } else if collectionView.tag == 1 {
                selectedCollectionViewTag = indexPath.row
                LifeEventData.shared.selectedCVTag1 = selectedCollectionViewTag
                for cell in cvLifeRoutin.visibleCells {
                    if let routineCell = cell as? LifeRoutineCollectionViewCell {
                        routineCell.backgroundColor = UIColor.white // 重置為原始顏色
                    }
                }
                // 設置選中顏色
                if let cell = collectionView.cellForItem(at: indexPath) as? LifeRoutineCollectionViewCell {
                    cell.backgroundColor = UIColor(red: 255/255, green: 143/255, blue: 149/255, alpha: 1.0)
                }
                changeTagToWord() // 更新選中標籤對應的文字
                cvLifeRoutin.reloadData()
            }
        } else {
            if collectionView.tag == 0 {

                tbvLife.isHidden = false
                for i in 0..<lifeRoutineItems.count {
                    if let cell = cvLifeRoutin.cellForItem(at: IndexPath(row: i, section: 0)) as? LifeRoutineCollectionViewCell {
                        // Reset the color to white (or default color)
                        cell.backgroundColor = UIColor.white
                    }
                }
                
                if let cell = collectionView.cellForItem(at: indexPath) as? LifeCollectionViewCell {
                    // 重設所有按鈕的顏色
                    for i in 0..<7 {
                        if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? LifeCollectionViewCell {
                            // 重設所有按鈕的顏色
                            cell.vLifeBackground.backgroundColor = UIColor(red: 255/255, green: 143/255, blue: 149/255, alpha: 1.0) // #FF8F95
                        }
                    }
                    
                    // 為當前選中的按鈕設置選中顏色
                    if let cell = collectionView.cellForItem(at: indexPath) as? LifeCollectionViewCell {
                        cell.vLifeBackground.backgroundColor = UIColor(red: 195/255, green: 14/255, blue: 35/255, alpha: 1.0) // #C30E23
                    }
                    selectedTag = cell.tag
                    print("selectedtag = ",selectedTag)
                    updateTableViewData(selectedTag: selectedTag)
                    // 顯示第二個 collectionView
                    vLifeSegc.isHidden = false
                    cvLifeRoutin.isHidden = false
                    lifeRoutineItems.removeAll()
                    // 動態更新 lifeRoutineItems 數據源
                    setLifeRoutineItems(for: selectedTag)
                    switch indexPath.row {
                    case 0, 1, 2, 3:
                        animateUIViewAndTableView()
                        isAnimatingHidding = false
                        isAnimating = true
                        tbvLife.isHidden = true
                        tbvLifeMain.isHidden = false
                    case 4, 5, 6:
                        changeTagToWord()
                        hideLifeRoutineCollectionView()
                        isAnimatingHidding = true
                        isAnimating = false
                        tbvLifeMain.isHidden = true
                        tbvLife.isHidden = false
                    default:
                        break
                    }
                    if let cell = collectionView.cellForItem(at: indexPath) as? LifeRoutineCollectionViewCell {
                        cell.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // 重置顏色
                    }
                    cvLifeRoutin.reloadData()
                    print("lifeRoutineItems count: \(lifeRoutineItems.count)")

                }
            } else if collectionView.tag == 1 {
                if let cell = collectionView.cellForItem(at: indexPath) as? LifeRoutineCollectionViewCell {
                    // Reset all cells in tag == 1 to white color
                    for i in 0..<lifeRoutineItems.count {
                        if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? LifeRoutineCollectionViewCell {
                            // Reset color to white
                            cell.backgroundColor = UIColor.white
                        }
                    }
                    
                    cell.backgroundColor = UIColor(red: 255/255, green: 143/255, blue: 149/255, alpha: 1.0)
                    
                    selectedCollectionViewTag = indexPath.row
                    changeTagToWord()
                    print(selectedCollectionViewTag,selectedLifeRoutin)
                }
            }
        }
    }
}

