//
//  CalibrationModeViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/11.
//

import UIKit
import RealmSwift

class CalibrationModeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    // 新增屬性來追蹤當前編輯的校正模式
    private var currentModeID: Int = 1  // 預設為模式1，你可以根據需求修改
    private var calibrationData: CalibrationModeData?  // 儲存載入的資料
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCalibrationData()  // 載入資料
        setupUI()
    }
    
    func setupUI() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "設定校正模式"
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "儲存", style: .plain, target: self, action: #selector(saveTapped)), animated: true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CalibrationModeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CalibrationModeTableViewCell.identifier)
    }
    
    private func loadCalibrationData() {
        do {
            let realm = try Realm()
            // 讀取指定 modeID 的資料
            if let savedData = realm.objects(CalibrationModeData.self).filter("modeID == %@", currentModeID).first {
                self.calibrationData = savedData
            }
        } catch {
            print("讀取校正模式資料失敗：\(error.localizedDescription)")
        }
    }
    
    // MARK: - UI Settings
    
    @objc func saveTapped() {
        // 1. 取得所有輸入的值
        guard let cells = tableView.visibleCells as? [CalibrationModeTableViewCell] else {
            showAlert(message: "無法取得輸入資料")
            return
        }
        
        // 2. 建立一個字典來儲存所有值
        var values: [String: Int] = [:]
        
        // 3. 遍歷所有cell取得輸入值
        for (index, cell) in cells.enumerated() {
            guard let inputText = cell.txfInput.text,
                  let inputValue = Int(inputText) else {
                showAlert(message: "請確認所有欄位都已填寫且為數字")
                return
            }
            
            // 根據index儲存對應的值
            switch index {
            case 0: values["rawData2BGBias"] = inputValue
            case 1: values["bgBias"] = inputValue
            case 2: values["bgLow"] = inputValue
            case 3: values["bgHigh"] = inputValue
            case 4: values["mapRate"] = inputValue
            case 5: values["thresholdRise"] = inputValue
            case 6: values["thresholdFall"] = inputValue
            case 7: values["riseRate"] = inputValue
            case 8: values["fallenRate"] = inputValue
            default: break
            }
        }
        
        // 4. 建立CalibrationModeData物件
        let calibrationData = CalibrationModeData(
            modeID: currentModeID,
            rawData2BGBias: values["rawData2BGBias"] ?? 0,
            bgBias: values["bgBias"] ?? 0,
            gLow: values["bgLow"] ?? 0,
            bgHigh: values["bgHigh"] ?? 0,
            mapRate: values["mapRate"] ?? 0,
            thresholdRise: values["thresholdRise"] ?? 0,
            thresholdFall: values["thresholdFall"] ?? 0,
            riseRate: values["riseRate"] ?? 0,
            fallenRate: values["fallenRate"] ?? 0
        )
        
        // 5. 儲存到Realm
        do {
            let realm = try Realm()
            try realm.write {
                // 檢查是否已存在相同modeID的資料
                if let existingData = realm.objects(CalibrationModeData.self).filter("modeID == %@", currentModeID).first {
                    // 更新現有資料
                    realm.delete(existingData)
                }
                realm.add(calibrationData)
            }
            showAlert(message: "校正模式儲存成功") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } catch {
            showAlert(message: "儲存失敗：\(error.localizedDescription)")
        }
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
    // 輔助方法：顯示警告訊息
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - Extensions
extension CalibrationModeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalibrationModeTableViewCell.identifier, for: indexPath) as? CalibrationModeTableViewCell else {
            return UITableViewCell()
        }
        
        // 設定標題
        let title: String
        var value: Int
        
        switch indexPath.row {
        case 0:
            title = "RawData2BGBias"
            value = calibrationData?.rawData2BGBias ?? 100
        case 1:
            title = "BGBias"
            value = calibrationData?.bgBias ?? 100
        case 2:
            title = "BGLow"
            value = calibrationData?.gLow ?? 40
        case 3:
            title = "BGHigh"
            value = calibrationData?.bgHigh ?? 400
        case 4:
            title = "MapRate"
            value = calibrationData?.mapRate ?? 1
        case 5:
            title = "ThresholdRise"
            value = calibrationData?.thresholdRise ?? 50
        case 6:
            title = "ThresholdFall"
            value = calibrationData?.thresholdFall ?? 50
        case 7:
            title = "RiseRate"
            value = calibrationData?.riseRate ?? 100
        case 8:
            title = "FallenRate"
            value = calibrationData?.fallenRate ?? 100
        default:
            title = ""
            value = 0
        }
        
        cell.lbTitle.text = title
        cell.txfInput.text = String(value)
        
        return cell
    }
    
    // 設定 Header 標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "校正模式"
    }
    
    // 設定 Header 標題字體大小
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    // 設定 Header 高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
