//
//  MainViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var TabBarView: UIView!
    
    // MARK: - Property
    var vc: [UIViewController] = []
    var nowVC: Int = BottomItems.InstantBloodSugarViewController.rawValue
    
    let one = InstantBloodSugarViewController()
    let two = BloodSugarCorrectionViewController()
    let three = LifeViewController()
    let four = HistoryViewController()
    let five = BloodSugarCorrectionSureViewController()
    
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
        let instantBloodSugarVC = InstantBloodSugarViewController()
        instantBloodSugarVC.imgvMenuBackground?.isHidden = true
        instantBloodSugarVC.vMenu?.isHidden = true
        setNavigatioinBar()
    }
    func setNavigatioinBar() {
        self.navigationItem.title = "即時血糖"
        
        let moreButton = UIButton(type: .system)
        moreButton.setImage(UIImage(named: "ThreeLineSmall"), for: .normal)
        moreButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        moreButton.addTarget(self, action: #selector(InstantBloodSugarViewController.moreButtonTapped), for: .touchUpInside)

        let linkButton = UIButton(type: .system)
        linkButton.setImage(UIImage(named: "link"), for: .normal)
        linkButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        linkButton.addTarget(self, action: #selector(InstantBloodSugarViewController.linkButtonTapped), for: .touchUpInside)

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
        rightButton.addTarget(self, action: #selector(InstantBloodSugarViewController.rightButtonTapped), for: .touchUpInside)

        // 創建 UIBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    // MARK: - IBAction
    
    // MARK: - Function
    func pageChange(page: Int) {
        updateView(page)
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
}

// MARK: - Extensions
