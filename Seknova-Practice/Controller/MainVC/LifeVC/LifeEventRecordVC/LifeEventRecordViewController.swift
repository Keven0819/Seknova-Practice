//
//  LifeEventRecordViewController.swift
//  Seknova-Practice
//
//  Created by imac-1681 on 2024/12/11.
//

import UIKit
import RealmSwift

class LifeEventRecordViewController: UIViewController {
    // MARk: - IBOutlet
    @IBOutlet var tbvLIfeEvent: UITableView!
    
    // MARK: - Proprtty
    var isEditingMode: Bool = false
    var expandedIndexPath: IndexPath?
    var btnTag: Int = 0
    let realm = try! Realm()
    var events: [LifeEvents] = []  // 用於存儲所有事件
    var todayEvents: [LifeEvents] = []
    var yesterdayEvents: [LifeEvents] = []
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableSet()
        setupNavigationbar()
        tbvLIfeEvent.backgroundColor = .clear // 设置背景为透明
        events = Array(realm.objects(LifeEvents.self))  // 抓取所有資料並轉換為陣列
        print("所有資料 = ",events)
        groupEventsByDate()
        addButton(to: navigationItem, target: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        editOrNot.shared.isEditingMode = false
        LifeEventData.shared.UUnum = ""
    }
    // MARK: - UI Setting
    func tableSet() {
        tbvLIfeEvent.register(UINib(nibName: "LifeEventReordTableViewCell", bundle: nil), forCellReuseIdentifier: LifeEventReordTableViewCell.identifiler)
        tbvLIfeEvent.dataSource = self
        tbvLIfeEvent.delegate = self
    }
    
    func setupNavigationbar () {
        self.navigationItem.title = "事件記錄"
        
        let editButton = UIBarButtonItem(title: "刪除",
                                         style: .plain,
                                         target: self,
                                         action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func addButton(to navigationItem: UINavigationItem, target: Any) {
        let leftBtn = UIButton(type: .system)
        
        // 設置圖像與標題
        leftBtn.setImage(UIImage(named: "back"), for: .normal) // 使用資源中的圖像
        leftBtn.setTitle("", for: .normal) // 設置按鈕標題
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20) // 增大標題字體大小
        leftBtn.tintColor = .white // 設置圖像與文字顏色
        
        // 圖像調整，讓大小適配標題
        if let image = leftBtn.imageView?.image {
            let scaledImage = image.withRenderingMode(.alwaysTemplate) // 使用模板模式調整顏色
            let targetHeight: CGFloat = leftBtn.titleLabel?.font.lineHeight ?? 20
            let scale = targetHeight / image.size.height
            leftBtn.setImage(scaledImage.resize(to: CGSize(width: image.size.width * scale, height: targetHeight)), for: .normal)
        }
        
        // 調整圖像和文字的間距
        leftBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) // 調整圖像與文字之間的間距
        //leftBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) // 調整標題的位置
        
        // 設置點擊動作
        leftBtn.addTarget(target, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 將 UIButton 包裝為 UIBarButtonItem
        let barButton = UIBarButtonItem(customView: leftBtn)
        navigationItem.leftBarButtonItem = barButton
    }
    // MARK: - IBAction
    @objc func editButtonTapped() {
        
        if isEditingMode {
            self.navigationItem.rightBarButtonItem?.title = "刪除"
            btnTag = 0
        } else {
            self.navigationItem.rightBarButtonItem?.title = "編輯"
            btnTag = 1
        }
        print(btnTag)
        
        tbvLIfeEvent.reloadData()
        isEditingMode.toggle()
    }
    // MARK: - Function
    // 返回上一頁
    @objc func backButtonTapped() {
        // pop到最剛開始的頁面
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // 把今天和昨天的資料分組
    func groupEventsByDate() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())  // 今天的開始時間
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!  // 昨天的開始時間
        
        
        todayEvents.removeAll()
        yesterdayEvents.removeAll()
        
        // 初始化 DateFormatter 用來將字符串轉換為 Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd EEEE a hh:mm"
        dateFormatter.locale = Locale(identifier: "zh_TW")
        
        
        for event in events {
            print("Processing event with dateTime: \(event.dateTime)")
            
            // 假設 event.dateTime 是字符串，這裡將它轉換為 Date
            guard let eventDate = dateFormatter.date(from: event.dateTime) else {
                print("Fail!!!!!!!!!!!!!!!!!!")
                continue  // 如果轉換失敗，跳過這個事件
            }
            print("1231231231321312313132123132",eventDate)
            // 比較日期
            if calendar.isDate(eventDate, inSameDayAs: today) {
                todayEvents.append(event)  // 添加到 "今天" 的事件列表
            } else if calendar.isDate(eventDate, inSameDayAs: yesterday) {
                yesterdayEvents.append(event)  // 添加到 "昨天" 的事件列表
            }
        }
        print("Today Events: \(todayEvents)")
        print("Yesterday Events: \(yesterdayEvents)")
    }
    
    func setExpanded(_ expanded: Bool) {
        let cell = tbvLIfeEvent.dequeueReusableCell(withIdentifier: LifeEventReordTableViewCell.identifiler) as! LifeEventReordTableViewCell
        cell.vLifeDetail.isHidden = !expanded
        
        // 更新约束
        cell.vLifeDetail.heightAnchor.constraint(equalToConstant: expanded ? 140 : 0).isActive = true
    }
    // 編輯與刪除
    @objc func btnEditAndDelete(_ sender: UIButton) {
        let section = sender.accessibilityValue == "today" ? 0 : 1
        let row = sender.tag
        print("Section: \(section == 0 ? "today" : "yesterday"), Row: \(row)")
        
        if btnTag == 0 {
            let selectedEvent: LifeEvents
            if section == 0 {
                selectedEvent = todayEvents[row]
            } else {
                selectedEvent = yesterdayEvents[row]
            }
            
            
            LifeEventData.shared.UUnum = selectedEvent.id
            LifeEventData.shared.selectedCVTag0 = selectedEvent.eventId
            LifeEventData.shared.selectedCVTag1 = selectedEvent.eventValue
            
            LifeEventData.shared.event3 = selectedEvent.note
            switch selectedEvent.eventId {
            case 0:
                LifeEventData.shared.event1 = selectedEvent.mealName
                LifeEventData.shared.event2 = selectedEvent.mealNum

            case 1:
                LifeEventData.shared.event1 = selectedEvent.exeName
                LifeEventData.shared.event2 = selectedEvent.exeTime
            case 2:
                LifeEventData.shared.event1 = selectedEvent.sleepTime
                LifeEventData.shared.event2 = ""
            case 3:
                LifeEventData.shared.event1 = selectedEvent.doseG
                LifeEventData.shared.event2 = ""
            default:
                break
            }
            
            print("編輯", row)
            print("顯示時間: ",selectedEvent)
            print("UUID:",selectedEvent.id)
            print("CVTag0 = ",selectedEvent.eventId)
            print("CVTag1 = ",selectedEvent.eventValue)
            print("事件1 = ",LifeEventData.shared.event1 ?? "")
            print("事件2 = ",LifeEventData.shared.event2 ?? "")
            print("備註 = ",selectedEvent.note)
            
            let LifeViewVC = LifeViewController()
            self.navigationController?.pushViewController(LifeViewVC, animated: true)
            editOrNot.shared.isEditingMode = true
            
            
        } else {
            try! realm.write {
                let event: LifeEvents
                
                if section == 0 {
                    if row < todayEvents.count {
                        event = todayEvents[row]
                        todayEvents.remove(at: row)
                    } else {
                        print("Index out of range for todayEvents")
                        return
                    }
                } else {
                    if row < yesterdayEvents.count {
                        event = yesterdayEvents[row]
                        yesterdayEvents.remove(at: row)
                    } else {
                        print("Index out of range for yesterdayEvents")
                        return
                    }
                }
                
                realm.delete(event)
            }
            tbvLIfeEvent.reloadData()
            print("刪除", row)
        }
    }
}
// MARK: - Extensions
extension LifeEventRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return todayEvents.count  // 今天的事件數量
        } else {
            return yesterdayEvents.count  // 昨天的事件數量
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == expandedIndexPath {
            return 200
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvLIfeEvent.dequeueReusableCell(withIdentifier: LifeEventReordTableViewCell.identifiler, for: indexPath) as! LifeEventReordTableViewCell
        
        let event: LifeEvents
        if indexPath.section == 0 {
            event = todayEvents[indexPath.row]
        } else {
            event = yesterdayEvents[indexPath.row]
        }
        
        cell.lbLifeEvent.text = event.event
        cell.lbTime.text = event.displayTime
        
        switch event.eventId {
        case 0:
            cell.lbLift0.text = "品名:"
            cell.lbLift1.text = "份量:"
            cell.lbLift2.text = "註記:"
            cell.lbRight0.text = event.mealName
            cell.lbRight1.text = event.mealNum
            cell.lbRight2.text = event.note
        case 1:
            cell.lbLift0.text = "類型:"
            cell.lbLift1.text = "時長:"
            cell.lbLift2.text = "註記:"
            cell.lbRight0.text = event.exeName
            cell.lbRight1.text = event.exeTime
            cell.lbRight2.text = event.note
            
        case 2:
            cell.lbLift0.text = "時長:"
            cell.lbLift1.text = "註記:"
            cell.lbLift2.text = ""
            cell.lbRight0.text = event.sleepTime
            cell.lbRight1.text = event.note
            cell.lbRight2.text = ""
            
        case 3:
            cell.lbLift0.text = "劑量:"
            cell.lbLift1.text = "註記:"
            cell.lbLift2.text = ""
            cell.lbRight0.text = event.doseG
            cell.lbRight1.text = event.note
            cell.lbRight2.text = ""
        case 4:
            cell.lbLift0.text = "註記:"
            cell.lbLift1.text = ""
            cell.lbLift2.text = ""
            cell.lbRight0.text = event.note
            cell.lbRight1.text = ""
            cell.lbRight2.text = ""
        case 5:
            cell.lbLift0.text = "註記:"
            cell.lbLift1.text = ""
            cell.lbLift2.text = ""
            cell.lbRight0.text = event.note
            cell.lbRight1.text = ""
            cell.lbRight2.text = ""
        case 6:
            cell.lbLift0.text = "註記:"
            cell.lbLift1.text = ""
            cell.lbLift2.text = ""
            cell.lbRight0.text = event.note
            cell.lbRight1.text = ""
            cell.lbRight2.text = ""
        default:
            break
        }
        
        
        // 0:刪除 1:編輯
        if btnTag == 0 {
            cell.imgEdit.image = UIImage(named: "edit")
            print("edit")
        } else {
            cell.imgEdit.image = UIImage(named: "waste")
            print("delete")
        }
        // 設定btn的tag
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.accessibilityValue = (indexPath.section == 0) ? "today" : "yesterday"
            
        cell.setExpanded(indexPath == expandedIndexPath)
        cell.btnEdit.addTarget(self, action: #selector(btnEditAndDelete(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear // 设置背景为透明
        
        let label = UILabel()
        label.textAlignment = .center
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        switch section {
        case 0:
            let today = Date()
            label.text = dateFormatter.string(from: today)
        case 1:
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            label.text = dateFormatter.string(from: yesterday ?? Date())
        default:
            label.text = ""
        }
        
        label.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40) // 设置标签的 frame
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let expandedIndexPath = expandedIndexPath {
            print(expandedIndexPath)
            // 如果已经有展开的单元格，并且点击的是不同的单元格
            if expandedIndexPath != indexPath {
                // 将之前展开的单元格收起
                self.expandedIndexPath = nil
                tableView.reloadRows(at: [expandedIndexPath], with: .automatic)
            }
        }
        
        // 切换当前单元格的展开状态
        if expandedIndexPath == indexPath {
            // 如果当前单元格已经展开，就收起
            self.expandedIndexPath = nil
        } else {
            // 否则展开
            self.expandedIndexPath = indexPath
        }
        
        // 重新加载当前单元格
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
