//
//  PersonInformationViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/22.
//

import UIKit

class PersonInformationViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    func setupUI() {
        setupTableView()
        registerTableViewCell()
    }
    
    // 設定tableView
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 40
    }
    // 註冊tableViewCell
    func registerTableViewCell() {
        let nib = UINib(nibName: "PersonalInfoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PersonalInfoTableViewCell.identifier)
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
extension PersonInformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
            return "聯絡資訊"
        case 2:
            return "帳號"
        case 3:
            return ""
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
