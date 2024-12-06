//
//  BloodSugarCorrectionViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit

class BloodSugarCorrectionViewController: UIViewController , BloodSugarCorrectionKnowMoreViewControllerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnKnowMore: UIButton!
    
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
        self.navigationItem.title = "血糖校正"
        self.navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    // MARK: - IBAction
    @IBAction func btnKnowMoreTapped(_ sender: Any) {
        print("btnKnowMoreTapped")
        let knowMoreVC = BloodSugarCorrectionKnowMoreViewController()
        knowMoreVC.delegate = self
        knowMoreVC.modalPresentationStyle = .popover
        if let popover = knowMoreVC.popoverPresentationController {
            
            popover.sourceView = self.btnKnowMore
            popover.sourceRect = self.btnKnowMore?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
            popover.delegate = self
            popover.permittedArrowDirections = .down
        }
        
        knowMoreVC.preferredContentSize = CGSize(width: 300, height: 150)
        
        present(knowMoreVC, animated: true)
        
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        let bloodSugarCorrectionSureVC = BloodSugarCorrectionSureViewController()
        self.navigationController?.pushViewController(bloodSugarCorrectionSureVC, animated: true)
    }
    
    // MARK: - Function
    func didKowMore() {
        print("didKowMore")
    }
}

// MARK: - Extensions
extension BloodSugarCorrectionViewController: UIPopoverPresentationControllerDelegate {
    
    // 這個方法會在iPhone上將popover改成全螢幕的方式
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // 保持Popover的樣式
    }
}
