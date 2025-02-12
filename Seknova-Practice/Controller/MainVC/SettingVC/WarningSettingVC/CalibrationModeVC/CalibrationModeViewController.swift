//
//  CalibrationModeViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/11.
//

import UIKit

class CalibrationModeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - UI Settings
    
    @objc func saveTapped() {
        print("資料已儲存")
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
    
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
        
        switch indexPath.row {
        case 0:
            cell.lbTitle.text = "RawData2BGBias"
            cell.txfInput.text = "100"
        case 1:
            cell.lbTitle.text = "BGBias"
            cell.txfInput.text = "100"
        case 2:
            cell.lbTitle.text = "BGLow"
            cell.txfInput.text = "40"
        case 3:
            cell.lbTitle.text = "BGHigh"
            cell.txfInput.text = "400"
        case 4:
            cell.lbTitle.text = "MapRate"
            cell.txfInput.text = "1"
        case 5:
            cell.lbTitle.text = "ThresholdRise"
            cell.txfInput.text = "50"
        case 6:
            cell.lbTitle.text = "ThresholdFall"
            cell.txfInput.text = "50"
        case 7:
            cell.lbTitle.text = "RiseRate"
            cell.txfInput.text = "100"
        case 8:
            cell.lbTitle.text = "FallenRate"
            cell.txfInput.text = "100"
        default:
            break
        }
        
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
