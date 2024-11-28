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

class InstantBloodSugarViewController: UIViewController, CBCentralManagerDelegate, SensorPopoverViewControllerDelegate, RightButtonPopoverViewControllerDelegate {
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgvMenuBackground: UIImageView!
    @IBOutlet weak var vMenu: UIView!
    @IBOutlet weak var imgvBluetooth: UIImageView!
    @IBOutlet weak var imgvNetwork: UIImageView!
    
    // MARK: - Property
    var btnMenuCount = 0
    var centralManager: CBCentralManager?
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // 初始化 centralManager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        checkWiFiStatus()
    }
    
    // MARK: - UI Settings
    func setUI() {
        imgvMenuBackground.isHidden = true
        vMenu.isHidden = true
        setNavigatioinBar()
    }
    func setNavigatioinBar() {
        self.navigationItem.title = "即時血糖"
        
        let moreButton = UIButton(type: .system)
        moreButton.setImage(UIImage(named: "ThreeLineSmall"), for: .normal)
        moreButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)

        let linkButton = UIButton(type: .system)
        linkButton.setImage(UIImage(named: "link"), for: .normal)
        linkButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)

        // 使用 UIStackView
        let stackView = UIStackView(arrangedSubviews: [moreButton, linkButton])
        stackView.axis = .horizontal
        stackView.spacing = 10 // 設定按鈕之間的間距為 0
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        // 約束條件
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moreButton.widthAnchor.constraint(equalToConstant: 24), // 明確寬度
            moreButton.heightAnchor.constraint(equalToConstant: 24) // 明確高度
        ])
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkButton.widthAnchor.constraint(equalToConstant: 24), // 明確寬度
            linkButton.heightAnchor.constraint(equalToConstant: 24) // 明確高度
        ])


        // 將 UIStackView 包裝為 UIBarButtonItem
        let customBarButtonItem = UIBarButtonItem(customView: stackView)
        self.navigationItem.leftBarButtonItem = customBarButtonItem
        
        // 創建自定義 UIButton
        let rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.backgroundColor = .clear

        // 創建綠色左半圓
        let greenArcLayer = CAShapeLayer()
        let greenArcPath = UIBezierPath(
            arcCenter: CGPoint(x: 15, y: 15),
            radius: 12,
            startAngle: CGFloat(-Double.pi / 2), // 從頂部開始
            endAngle: CGFloat(Double.pi / 2), // 到底部結束
            clockwise: true
        )
        greenArcLayer.path = greenArcPath.cgPath
        greenArcLayer.strokeColor = UIColor.systemGreen.cgColor
        greenArcLayer.fillColor = UIColor.clear.cgColor
        greenArcLayer.lineWidth = 5
        greenArcLayer.lineCap = .butt

        // 創建灰色右半圓
        let grayArcLayer = CAShapeLayer()
        let grayArcPath = UIBezierPath(
            arcCenter: CGPoint(x: 15, y: 15),
            radius: 12,
            startAngle: CGFloat(Double.pi / 2), // 從底部開始
            endAngle: CGFloat(Double.pi * 1.5), // 到頂部結束
            clockwise: true
        )
        grayArcLayer.path = grayArcPath.cgPath
        grayArcLayer.strokeColor = UIColor.systemGray.cgColor
        grayArcLayer.fillColor = UIColor.clear.cgColor
        grayArcLayer.lineWidth = 5
        grayArcLayer.lineCap = .butt

        // 創建外圍黑色邊框
        let outerBorderLayer = CAShapeLayer()
        let outerCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: 15, y: 15),
            radius: 14.5,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        outerBorderLayer.path = outerCirclePath.cgPath
        outerBorderLayer.strokeColor = UIColor.black.cgColor
        outerBorderLayer.fillColor = UIColor.clear.cgColor
        outerBorderLayer.lineWidth = 0.5

        // 創建內圍黑色邊框
        let innerBorderLayer = CAShapeLayer()
        let innerCirclePath = UIBezierPath(
            arcCenter: CGPoint(x: 15, y: 15),
            radius: 9.5,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        innerBorderLayer.path = innerCirclePath.cgPath
        innerBorderLayer.strokeColor = UIColor.black.cgColor
        innerBorderLayer.fillColor = UIColor.clear.cgColor
        innerBorderLayer.lineWidth = 0.5

        // 創建垂直分隔線（上半部分）
        let topSeparatorLayer = CAShapeLayer()
        let topSeparatorPath = UIBezierPath()
        topSeparatorPath.move(to: CGPoint(x: 15, y: 15 - 14.5)) // 從頂部開始
        topSeparatorPath.addLine(to: CGPoint(x: 15, y: 5)) // 到中心點
        topSeparatorLayer.path = topSeparatorPath.cgPath
        topSeparatorLayer.strokeColor = UIColor.black.cgColor
        topSeparatorLayer.lineWidth = 0.5

        // 創建垂直分隔線（下半部分）
        let bottomSeparatorLayer = CAShapeLayer()
        let bottomSeparatorPath = UIBezierPath()
        bottomSeparatorPath.move(to: CGPoint(x: 15, y: 15 + 14.5)) // 從中心點開始
        bottomSeparatorPath.addLine(to: CGPoint(x: 15, y: 25)) // 到底部
        bottomSeparatorLayer.path = bottomSeparatorPath.cgPath
        bottomSeparatorLayer.strokeColor = UIColor.black.cgColor
        bottomSeparatorLayer.lineWidth = 0.5

        // 按正確的順序添加圖層
        rightButton.layer.addSublayer(greenArcLayer)
        rightButton.layer.addSublayer(grayArcLayer)
        rightButton.layer.addSublayer(outerBorderLayer)
        rightButton.layer.addSublayer(innerBorderLayer)
        rightButton.layer.addSublayer(topSeparatorLayer)
        rightButton.layer.addSublayer(bottomSeparatorLayer)

        // 添加點擊事件
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)

        // 創建 UIBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
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
    @objc func moreButtonTapped() {
        if btnMenuCount == 0 {
            imgvMenuBackground.isHidden = false
            vMenu.isHidden = false
            btnMenuCount += 1
        } else {
            imgvMenuBackground.isHidden = true
            vMenu.isHidden = true
            btnMenuCount = 0
        }
    }
    
    @objc func linkButtonTapped() {
        print("linkButtonTapped")
        let sensorPopoverVC = SensorPopoverViewController()
        sensorPopoverVC.delegate = self
        sensorPopoverVC.modalPresentationStyle = .popover
        if let popover = sensorPopoverVC.popoverPresentationController {
            
            popover.sourceView = self.navigationItem.leftBarButtonItem?.customView?.subviews[1]
            popover.sourceRect = navigationItem.leftBarButtonItem?.customView?.subviews[1].bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
            popover.delegate = self
            popover.permittedArrowDirections = .up
        }
        
        sensorPopoverVC.preferredContentSize = CGSize(width: 200, height: 50)
        
        present(sensorPopoverVC, animated: true)
    }
    
    @objc func rightButtonTapped() {
        print("rightButtonTapped")
        let rightPopoverVC = RightButtonPopoverViewController()
        rightPopoverVC.delegate = self
        rightPopoverVC.modalPresentationStyle = .popover
        if let popover = rightPopoverVC.popoverPresentationController {
            
            popover.sourceView = self.navigationItem.rightBarButtonItem?.customView
            popover.sourceRect = navigationItem.rightBarButtonItem?.customView?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
            popover.delegate = self
            popover.permittedArrowDirections = .up
        }
        
        rightPopoverVC.preferredContentSize = CGSize(width: 200, height: 200)
        
        present(rightPopoverVC, animated: true)
    }
    // MARK: - Function
    func didConfirmSensor() {
        print("Sensor confirmed.")
    }
    
    func didConfirmRightButton() {
        print("Right button confirmed.")
    }
}

// MARK: - Extensions
extension InstantBloodSugarViewController: UIPopoverPresentationControllerDelegate {
    
    // 這個方法會在iPhone上將popover改成全螢幕的方式
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // 保持Popover的樣式
    }
}
