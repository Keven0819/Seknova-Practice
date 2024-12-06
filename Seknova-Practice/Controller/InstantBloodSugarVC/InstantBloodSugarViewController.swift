//
//  InstantBloodSugarViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/21.
//

import UIKit
import SwiftUI
import CoreBluetooth
import Network

class InstantBloodSugarViewController: UIViewController, CBCentralManagerDelegate {
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgvBluetooth: UIImageView!
    @IBOutlet weak var imgvNetwork: UIImageView!
    @IBOutlet weak var lbValue: UILabel!
    
    // MARK: - Property
    var centralManager: CBCentralManager?
    var number: Int = 0
    var timer = Timer()
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化 centralManager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        checkWiFiStatus()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // MARK: - UI Settings
    
    // Bluetooth 狀態處理
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            imgvBluetooth.image = UIImage(named: "bluetooth-check")
            print("Bluetooth is On")
        case .poweredOff:
            imgvBluetooth.image = UIImage(named: "bluetooth-false")
            print("Bluetooth is Off")
        case .unauthorized:
            print("Bluetooth permissions not granted.")
        case .unsupported:
            print("Bluetooth is not supported on this device.")
        default:
            print("Unknown Bluetooth state.")
        }
    }
    
    func checkWiFiStatus() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")

        // 檢查網路狀態
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        self.imgvNetwork.image = UIImage(named: "network-check")
                        print("WiFi is connected.")
                    } else {
                        self.imgvNetwork.image = UIImage(named: "network-false")
                        print("WiFi is not connected.")
                    }
                } else {
                    self.imgvNetwork.image = UIImage(named: "network-false")
                    print("No network connection.")
                }
            }
        }

        // 啟動監視器
        monitor.start(queue: queue)

        // 檢查初始網路狀態
        DispatchQueue.global().async {
            let path = monitor.currentPath
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        self.imgvNetwork.image = UIImage(named: "network-check")
                        print("WiFi is connected (initial check).")
                    } else {
                        self.imgvNetwork.image = UIImage(named: "network-false")
                        print("WiFi is not connected (initial check).")
                    }
                } else {
                    self.imgvNetwork.image = UIImage(named: "network-false")
                    print("No network connection (initial check).")
                }
            }
        }
    }
    // MARK: - IBAction
    
    @objc func timerAction() {
        number = Int.random(in: 55...400)
        lbValue.text = "\(number)"
    }
    
    // MARK: - Function
    
}

// MARK: - Extensions
