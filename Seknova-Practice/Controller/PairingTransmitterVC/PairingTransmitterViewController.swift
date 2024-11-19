//
//  PairingTransmitterViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/13.
//

import UIKit

class PairingTransmitterViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lbTitle1: UILabel!
    @IBOutlet weak var lbTitle2: UILabel!
    @IBOutlet weak var imgvTitle: UIImageView!
    @IBOutlet weak var imgvPhone: UIImageView!
    @IBOutlet weak var imgvLoding: UIImageView!
    @IBOutlet weak var imgvDevice: UIImageView!
    @IBOutlet weak var btnPair: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imgvSuccess: UIImageView!
    
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        imgvSuccess.isHidden = true
    }
    
    // MARK: - UI Settings
    func setNavigationBar() {
        self.navigationItem.title = "Pair Bluetooth"
    }
    // MARK: - IBAction
    @IBAction func btnCancelTapped(_ sender: Any) {
        UserPreferences.shared.deviceID = ""
        let transmitterVC = TransmitterViewController()
        navigationController?.pushViewController(transmitterVC, animated: true)
        print(UserPreferences.shared.deviceID ?? "nil")
    }
    @IBAction func btnPairTapped(_ sender: Any) {
        let animateVC = PairAnimateViewController()
        animateVC.delegate = self
        navigationController?.pushViewController(animateVC, animated: true)
    }
    
    // MARK: - Function
    func showSuccessAndNavigate() {
        // 隱藏其他元件
        [lbTitle1, lbTitle2, imgvTitle, imgvPhone, imgvLoding,
         imgvDevice, btnPair, btnCancel].forEach { $0?.isHidden = true }
        
        // 顯示成功圖示
        imgvSuccess.isHidden = false
        
        // 3秒後導航到掃描頁面
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let scanningVC = ScanningSensorViewController()
            self.navigationController?.pushViewController(scanningVC, animated: true)
        }
    }
}

// MARK: - Extensions
extension PairingTransmitterViewController: PairAnimateDelegate {
    func animationDidComplete() {
        showSuccessAndNavigate()
    }
}
