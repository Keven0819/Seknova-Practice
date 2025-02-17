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
    @IBOutlet weak var btnGetPassKey: UIButton!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Settings
    func setupUI() {
        setupNavigationBar()
        txfInputPhoneNumber.placeholder = NSLocalizedString("Enter phone number", comment: "")
        txfInputPassKey.placeholder = NSLocalizedString("6-digit verify code", comment: "")
        btnInputPassKey.setTitle(NSLocalizedString("Input verify code", comment: ""), for: .normal)
        btnBack.setTitle(NSLocalizedString("Return", comment: ""), for: .normal)
        btnGetPassKey.setTitle(NSLocalizedString("Get verify code", comment: ""), for: .normal)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = NSLocalizedString("Bind Phone Cell", comment: "")
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
            let alert = UIAlertController(title: NSLocalizedString("Enter phone number", comment: ""), message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
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
