//
//  BindPhoneViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/1/13.
//

import UIKit
import RealmSwift

class BindPhoneViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txfInputPhoneNumber: UITextField!
    @IBOutlet weak var txfInputPassKey: UITextField!
    @IBOutlet weak var btnInputPassKey: UIButton!
    @IBOutlet weak var btnReturn: UIButton!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    func setupUI() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "綁定手機"
    }
    
    // MARK: - IBAction
    @IBAction func btnInputPassKeyTapped(_ sender: Any) {
        let realm = try! Realm()
        let userInformation = realm.objects(UserInformation.self)
        let userInformations = Array(arrayLiteral: userInformation.last ?? UserInformation())
        
        if txfInputPhoneNumber.text != "" {
            try! realm.write {
                userInformations[0].Phone = txfInputPhoneNumber.text!
            }
            // 返回上一页面前通知需要刷新
            if let personVC = navigationController?.viewControllers.first(where: { $0 is PersonInformationViewController }) as? PersonInformationViewController {
                personVC.viewWillAppear(true) // 这会触发数据重新加载
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "請輸入手機號碼", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func btnReturnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
