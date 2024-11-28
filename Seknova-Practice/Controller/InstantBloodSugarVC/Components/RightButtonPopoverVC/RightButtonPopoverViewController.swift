//
//  RightButtonPopoverViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/26.
//

import UIKit

protocol RightButtonPopoverViewControllerDelegate: AnyObject {
    func didConfirmRightButton()
}

class RightButtonPopoverViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgvDeadline: UIImageView!
    @IBOutlet weak var lbBottom: UILabel!
    @IBOutlet weak var lbtenday: UILabel!
    @IBOutlet weak var imgvBlood: UIImageView!
    
    // MARK: - Property
    
    weak var delegate: RightButtonPopoverViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - UI Settings
    func setUI() {
        
        // 創建自定義 UIView
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false // 開啟 Auto Layout
        customView.backgroundColor = .clear

        // 設置新尺寸
        let viewSize: CGFloat = 50 // 調整 UIView 的寬高
        let centerPoint = CGPoint(x: viewSize / 2, y: viewSize / 2)
        let outerRadius: CGFloat = 52 // 外圍半徑（稍小於 viewSize / 2）
        let innerRadius: CGFloat = 28 // 內圍半徑（小一些）
        let arcRadius: CGFloat = 40  // 半圓弧的半徑
        let lineWidth: CGFloat = 25   // 線寬加粗

        // 創建綠色左半圓
        let greenArcLayer = CAShapeLayer()
        let greenArcPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: arcRadius,
            startAngle: CGFloat(-Double.pi / 2), // 從頂部開始
            endAngle: CGFloat(Double.pi / 2), // 到底部結束
            clockwise: true
        )
        greenArcLayer.path = greenArcPath.cgPath
        greenArcLayer.strokeColor = UIColor.systemGreen.cgColor
        greenArcLayer.fillColor = UIColor.clear.cgColor
        greenArcLayer.lineWidth = lineWidth
        greenArcLayer.lineCap = .butt

        // 創建灰色右半圓
        let grayArcLayer = CAShapeLayer()
        let grayArcPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: arcRadius,
            startAngle: CGFloat(Double.pi / 2), // 從底部開始
            endAngle: CGFloat(Double.pi * 1.5), // 到頂部結束
            clockwise: true
        )
        grayArcLayer.path = grayArcPath.cgPath
        grayArcLayer.strokeColor = UIColor.systemGray.cgColor
        grayArcLayer.fillColor = UIColor.clear.cgColor
        grayArcLayer.lineWidth = lineWidth
        grayArcLayer.lineCap = .butt

        // 創建外圍黑色邊框
        let outerBorderLayer = CAShapeLayer()
        let outerCirclePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: outerRadius,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        outerBorderLayer.path = outerCirclePath.cgPath
        outerBorderLayer.strokeColor = UIColor.black.cgColor
        outerBorderLayer.fillColor = UIColor.clear.cgColor
        outerBorderLayer.lineWidth = 1

        // 創建內圍黑色邊框
        let innerBorderLayer = CAShapeLayer()
        let innerCirclePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: innerRadius,
            startAngle: 0,
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )
        innerBorderLayer.path = innerCirclePath.cgPath
        innerBorderLayer.strokeColor = UIColor.black.cgColor
        innerBorderLayer.fillColor = UIColor.clear.cgColor
        innerBorderLayer.lineWidth = 1

        // 創建垂直分隔線（上半部分）
        let topSeparatorLayer = CAShapeLayer()
        let topSeparatorPath = UIBezierPath()
        topSeparatorPath.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y - outerRadius)) // 從頂部開始
        topSeparatorPath.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y - innerRadius)) // 到中心點
        topSeparatorLayer.path = topSeparatorPath.cgPath
        topSeparatorLayer.strokeColor = UIColor.black.cgColor
        topSeparatorLayer.lineWidth = 1

        // 創建垂直分隔線（下半部分）
        let bottomSeparatorLayer = CAShapeLayer()
        let bottomSeparatorPath = UIBezierPath()
        bottomSeparatorPath.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y + outerRadius)) // 從中心點開始
        bottomSeparatorPath.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y + innerRadius)) // 到底部
        bottomSeparatorLayer.path = bottomSeparatorPath.cgPath
        bottomSeparatorLayer.strokeColor = UIColor.black.cgColor
        bottomSeparatorLayer.lineWidth = 1

        // 按正確的順序添加圖層
        customView.layer.addSublayer(greenArcLayer)
        customView.layer.addSublayer(grayArcLayer)
        customView.layer.addSublayer(outerBorderLayer)
        customView.layer.addSublayer(innerBorderLayer)
        customView.layer.addSublayer(topSeparatorLayer)
        customView.layer.addSublayer(bottomSeparatorLayer)

        // 將 customView 添加到父視圖
        self.view.addSubview(customView)

        // 添加 Auto Layout 約束
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), // 水平置中
            customView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor), // 垂直置中
            customView.widthAnchor.constraint(equalToConstant: viewSize), // 設定寬度
            customView.heightAnchor.constraint(equalToConstant: viewSize), // 設定高度
            
        ])
        
        // 日曆
        imgvDeadline.image = UIImage(named: "deadline")
        imgvDeadline.contentMode = .scaleAspectFit
        imgvDeadline.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imgvDeadline)
        NSLayoutConstraint.activate([
            imgvDeadline.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50), // 調整上方間距
            imgvDeadline.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 50),
            imgvDeadline.widthAnchor.constraint(equalToConstant: 100), // 根據圖片大小調整
            imgvDeadline.heightAnchor.constraint(equalToConstant: 100), // 根據圖片大小調整
        ])
        
        // 底部 Label
        lbBottom.text = "Calibrated Now"
        lbBottom.font = UIFont.systemFont(ofSize: 22)
        lbBottom.textColor = .black
        lbBottom.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbBottom)
        NSLayoutConstraint.activate([
            lbBottom.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            lbBottom.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        // 10 Day Label
        lbtenday.text = "10 Day"
        lbtenday.font = UIFont.systemFont(ofSize: 22)
        lbtenday.textColor = .black
        lbtenday.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbtenday)
        NSLayoutConstraint.activate([
            lbtenday.topAnchor.constraint(equalTo: imgvDeadline.bottomAnchor, constant: 20),
            lbtenday.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 40)
        ])

        // 血滴圖片
        imgvBlood.image = UIImage(named: "blood")
        imgvBlood.contentMode = .scaleAspectFit
        imgvBlood.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imgvBlood)
        NSLayoutConstraint.activate([
            imgvBlood.topAnchor.constraint(equalTo: lbtenday.bottomAnchor, constant: 20),
            imgvBlood.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imgvBlood.widthAnchor.constraint(equalToConstant: 50),
            imgvBlood.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    // MARK: - IBAction
    
    // MARK: - Function
    
}

// MARK: - Extensions
