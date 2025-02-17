//
//  MainViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, SensorPopoverViewControllerDelegate, RightButtonPopoverViewControllerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var TabBarView: UIView!
    @IBOutlet weak var imgvMenu: UIImageView!
    @IBOutlet weak var vMenu: UIView!
    
    // MARK: - Property
    var vc: [UIViewController] = []
    var nowVC: Int = BottomItems.InstantBloodSugarViewController.rawValue
    var titles: [String] = [NSLocalizedString("Glycemic Index", comment: "即時血糖"), NSLocalizedString("Calibrate", comment: "血糖校正"), NSLocalizedString("LifeStyle", comment: "生活作息"), NSLocalizedString("History", comment: "歷史紀錄"), NSLocalizedString("Personal Info", comment: "個人資訊")]
    
    let one = InstantBloodSugarViewController()
    let two = BloodSugarCorrectionViewController()
    let three = LifeViewController()
    let four = HistoryViewController()
    let five = PersonInformationViewController()
    
    var btnMenuCount = 0
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc = [one, two, three, four, five]
        updateView(0)
        
        if let customTabBar = TabBarView as? CustomTabBar {
            customTabBar.buttonTappen = { [self] in
                let page = $0
                if page != self.nowVC {
                    self.pageChange(page: page)
                }
            }
        }
        setUI()
    }
    
    // MARK: - UI Settings
    func setUI() {
        imgvMenu.isHidden = true
        vMenu.isHidden = true
        setNavigatioinBar()
    }
    func setNavigatioinBar() {
        
        self.title = NSLocalizedString("Glycemic Index", comment: "")
        
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
    // MARK: - IBAction
    @IBAction func btnReport(_ sender: Any) {
        let reportVC = ReportViewController()
        self.navigationItem.backButtonTitle = "返回"
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    
    @IBAction func btnLog(_ sender: Any) {
        let logVC = LogViewController()
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(logVC, animated: true)
    }
    
    @IBAction func btnSetting(_ sender: Any) {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    
    @objc func moreButtonTapped() {
        if btnMenuCount == 0 {
            imgvMenu.isHidden = false
            vMenu.isHidden = false
            
            // 初始位置 (隱藏在左側)
            imgvMenu.transform = CGAffineTransform(translationX: -vMenu.frame.width, y: 0)
            vMenu.transform = CGAffineTransform(translationX: -vMenu.frame.width, y: 0)

            // 動畫滑入
            UIView.animate(withDuration: 0.3, animations: {
                self.imgvMenu.transform = .identity // 恢復到原位
                self.vMenu.transform = .identity // 恢復到原位
            })

            btnMenuCount += 1
        } else {
            // 動畫滑出
            UIView.animate(withDuration: 0.3, animations: {
                self.vMenu.transform = CGAffineTransform(translationX: -self.vMenu.frame.width, y: 0)
                self.imgvMenu.transform = CGAffineTransform(translationX: -self.vMenu.frame.width, y: 0)
            }, completion: { _ in
                self.vMenu.isHidden = true
                self.imgvMenu.isHidden = true
            })

            btnMenuCount = 0
        }
    }
    
    @objc func pushToLifeEventRecord() {
        let lifeEventVC = LifeEventRecordViewController()
        self.navigationController?.pushViewController(lifeEventVC, animated: true)
    }
    
    @objc func linkButtonTapped() {
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
    
    @objc func personInfoRightButtonTapped() {
        let realm = try! Realm()
        
        // 從子視圖控制器中獲取 PersonInformationViewController 實例
        if let personInfoVC = children.first(where: { $0 is PersonInformationViewController }) as? PersonInformationViewController,
           let tableView = personInfoVC.tableView {
            
            // 獲取可見的單元格以檢索更新的資料
            _ = tableView.visibleCells.compactMap { $0 as? InfoTableViewCell }
            
            // 獲取當前用戶資訊
            guard let userInfo = realm.objects(UserInformation.self).first else {
                // 如果找不到用戶資料，顯示錯誤提示
                let errorAlert = UIAlertController(
                    title: "更新失敗",
                    message: "找不到用戶資料",
                    preferredStyle: .alert
                )
                errorAlert.addAction(UIAlertAction(title: "確定", style: .default))
                present(errorAlert, animated: true)
                return
            }
            
            // 使用 Realm 交易更新資料
            try! realm.write {
                // 更新基本資料（第 0 區段）和身體數值（第 1 區段）
                for indexPath in tableView.indexPathsForVisibleRows ?? [] {
                    if let cell = tableView.cellForRow(at: indexPath) as? InfoTableViewCell {
                        switch indexPath.section {
                        case 0: // 基本資料
                            switch indexPath.row {
                            case 0: // 名
                                userInfo.FirstName = cell.txfEdit.text ?? ""
                            case 1: // 姓
                                userInfo.LastName = cell.txfEdit.text ?? ""
                            case 2: // 出生日期
                                userInfo.Birthday = cell.lbResult.text ?? ""
                            case 3: // 電子信箱
                                userInfo.Email = cell.txfEdit.text ?? ""
                            case 5: // 地址
                                userInfo.Address = cell.txfEdit.text ?? ""
                            default:
                                break
                            }
                            
                        case 1: // 身體數值
                            switch indexPath.row {
                            case 0: // 性別
                                userInfo.Gender = cell.lbResult.text ?? ""
                            case 1: // 身高
                                userInfo.Height = cell.txfEdit.text ?? ""
                            case 2: // 體重
                                userInfo.Weight = cell.txfEdit.text ?? ""
                            case 3: // 種族
                                userInfo.Race = cell.lbResult.text ?? ""
                            case 4: // 飲酒
                                userInfo.Liquor = cell.lbResult.text ?? ""
                            case 5: // 抽菸
                                userInfo.Smoke = cell.lbResult.text ?? ""
                            default:
                                break
                            }
                            
                        default:
                            break
                        }
                    }
                }
            }
            
            // 顯示更新成功提示
            let successAlert = UIAlertController(
                title: "更新成功",
                message: "您的個人資料已成功更新",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "確定", style: .default))
            present(successAlert, animated: true)
        }
    }
    
    @objc func historyReloadButtonTapped() {
        // 獲取當前顯示的 HistoryViewController
        if let historyVC = children.first(where: { $0 is HistoryViewController }) as? HistoryViewController {
            // 重置圖表數據
            historyVC.chartEntries.removeAll()
            historyVC.timeAxisEntries.removeAll()
            
            // 更新圖表
            historyVC.setupChart()
            historyVC.XAxisUpdate()
            historyVC.startRandomNumberUpdate()
        }
    }
    // MARK: - Function
    func pageChange(page: Int) {
        updateView(page)
        self.title = titles[page] // 更新 NavigationBar 標題
        switch page {
        
        // 即時血糖
        case 0:
            self.navigationItem.rightBarButtonItem?.isHidden = false
            setNavigatioinBar()
        
        // 血糖校正
        case 1:
            self.navigationItem.rightBarButtonItem?.isHidden = true
            
        // 生活作息
        case 2:
            self.navigationItem.rightBarButtonItem?.isHidden =  false
            let rightButton = UIButton(type: .system)
            rightButton.setTitle("事件記錄", for: .normal)
            rightButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            rightButton.addTarget(self, action: #selector(pushToLifeEventRecord), for: .touchUpInside)
            let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            navigationItem.rightBarButtonItem = rightBarButtonItem
            
        // 歷史紀錄
        case 3:
            self.navigationItem.rightBarButtonItem?.isHidden = false
                        
            // 加載原始圖片
            if let originalImage = UIImage(named: "reload") {
                // 調整圖片大小
                let resizedImage = resizeImage(image: originalImage, targetSize: CGSize(width: 24, height: 24))
                
                let rightButton = UIButton(type: .system)
                rightButton.setImage(resizedImage.withRenderingMode(.alwaysTemplate), for: .normal)
                rightButton.tintColor = .white
                rightButton.contentMode = .scaleAspectFit
                rightButton.addTarget(self, action: #selector(historyReloadButtonTapped), for: .touchUpInside)
                
                let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
                navigationItem.rightBarButtonItem = rightBarButtonItem
            }
            
        // 個人資訊
        case 4:
            self.navigationItem.rightBarButtonItem?.isHidden = false
            // 把原本的button改為另一個button
            let rightButton = UIButton(type: .system)
            rightButton.setTitle("更新", for: .normal)
            rightButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            rightButton.addTarget(self, action: #selector(personInfoRightButtonTapped), for: .touchUpInside)
            let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            navigationItem.rightBarButtonItem = rightBarButtonItem
        default:
            break
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        // 選擇較小的比例，以保持圖片比例
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        
        // 繪製調整大小的圖片
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        return scaledImage
    }
    
    func updateView(_ index: Int) {
        
        nowVC = index
        if children.first(where: { String(describing: $0.classForCoder) == String(describing:
            vc[index].classForCoder) }) == nil {
            addChild(vc[index])
            vc[index].view.frame = content.bounds
        }
        content.addSubview(vc[index].view ?? UIView())
    }
    
    func didConfirmSensor() {
    }
    
    func didConfirmRightButton() {
    }
}

// MARK: - Extensions
extension MainViewController: UIPopoverPresentationControllerDelegate {
    
    // 這個方法會在iPhone上將popover改成全螢幕的方式
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // 保持Popover的樣式
    }
}
