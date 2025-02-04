//
//  LifeViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit

class LifeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var vBGcollectionView: UIView!
    
    // MARK: - Property
    
    
    // 用來記錄點擊的 collectionView 是哪一個
    var controlSecondCollectionView: Int = 0
    
    
    // 根據點擊回傳的 index 去控制第二個 collectionView 的 cell 數量
    let indexarray: [Int] = [5, 3, 4, 3, 0 ,0, 0]
    
    var newWidth:Int = 0
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbDate.text = currentDateTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
        setCollectionView()
    }
    
    // MARK: - UI Settings
    
    // 設定collectionView
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LifeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LifeCollectionViewCell")
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.register(UINib(nibName: "LifeChoseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LifeChoseCollectionViewCell")
    }
    
    
    // MARK: - IBAction
    @IBAction func btnDatePicker(_ sender: Any) {
        datePicker.isHidden = false
        toolBar.isHidden = false
        vBackground.isHidden = false
    }
    
    @IBAction func btnCnacel(_ sender: Any) {
        datePicker.isHidden = true
        toolBar.isHidden = true
        vBackground.isHidden = true
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        datePicker.isHidden = true
        toolBar.isHidden = true
        vBackground.isHidden = true
        print(dateFormate())
        lbDate.text = dateFormate()
    }
    
    // MARK: - Function
    
    func dateFormate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = "yyyy/MM/dd EEEE aa hh:mm"
        return formatter.string(from: datePicker.date)
    }
    
    func currentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.dateFormat = "yyyy/MM/dd EEEE aa hh:mm"
        return formatter.string(from: Date())
    }
    
}

// MARK: - Extensions
extension LifeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            print("collectionView1")
            return CGSize(width: 70, height: 90)
        } else if collectionView == self.collectionView2 {
            print("collectionView2")
            return CGSize(width: newWidth, height: 90)
        } else {
            print("none")
            return CGSize(width: 70, height: 90)
        }
    }
    
    // 設置每個 cell 之間的水平間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // 設置項目間的最小間距為 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            return 7
        } else if collectionView == self.collectionView2 {
//            let count = indexarray[controlSecondCollectionView]
//            print("collectionView2: controlSecondCollectionView = \(controlSecondCollectionView), count = \(count)")
//            let width = collectionView.frame.width
//            if count == 0 {
//                return 0
//            } else {
//                newWidth = Int(width) / count
//                print("newWidth: \(newWidth)")
//            }
            return indexarray[controlSecondCollectionView]
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView === self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeCollectionViewCell", for: indexPath) as? LifeCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.vBackground.backgroundColor = UIColor(red: 255/255, green: 143/255, blue: 149/255, alpha: 1)
            
            switch indexPath.item {
            case 0:
                cell.lbTitle.text = "用餐"
                cell.imageView.image = UIImage(named: "meal")
            case 1:
                cell.lbTitle.text = "運動"
                cell.imageView.image = UIImage(named: "exercise")
            case 2:
                cell.lbTitle.text = "睡眠"
                cell.imageView.image = UIImage(named: "sleep")
            case 3:
                cell.lbTitle.text = "胰島素"
                cell.imageView.image = UIImage(named: "insulin")
            case 4:
                cell.lbTitle.text = "起床"
                cell.imageView.image = UIImage(named: "awaken")
            case 5:
                cell.lbTitle.text = "洗澡"
                cell.imageView.image = UIImage(named: "bath")
            case 6:
                cell.lbTitle.text = "其他"
                cell.imageView.image = UIImage(named: "other")
            default:
                break
            }
            return cell
        } else if collectionView === self.collectionView2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifeChoseCollectionViewCell", for: indexPath) as? LifeChoseCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            switch controlSecondCollectionView {
            case 0:
                switch indexPath.item {
                case 0:
                    cell.lbTitle.text = "早餐"
                    cell.imageView.image = UIImage(named: "breakfast")
                case 1:
                    cell.lbTitle.text = "午餐"
                    cell.imageView.image = UIImage(named: "launch")
                case 2:
                    cell.lbTitle.text = "晚餐"
                    cell.imageView.image = UIImage(named: "dinner")
                case 3:
                    cell.lbTitle.text = "點心"
                    cell.imageView.image = UIImage(named: "snacks")
                case 4:
                    cell.lbTitle.text = "飲料"
                    cell.imageView.image = UIImage(named: "drinks")
                default:
                    break
                }
            case 1:
                switch indexPath.item {
                case 0:
                    cell.lbTitle.text = "高強度"
                    cell.imageView.image = UIImage(named: "high_motion")
                case 1:
                    cell.lbTitle.text = "中強度"
                    cell.imageView.image = UIImage(named: "mid_motion")
                case 2:
                    cell.lbTitle.text = "低強度"
                    cell.imageView.image = UIImage(named: "low_motion")
                default:
                    break
                }
            case 2:
                switch indexPath.item {
                case 0:
                    cell.lbTitle.text = "就寢"
                    cell.imageView.image = UIImage(named: "sleep")
                case 1:
                    cell.lbTitle.text = "午睡"
                    cell.imageView.image = UIImage(named: "sleepy")
                case 2:
                    cell.lbTitle.text = "小憩"
                    cell.imageView.image = UIImage(named: "nap")
                case 3:
                    cell.lbTitle.text = "放鬆時刻"
                    cell.imageView.image = UIImage(named: "relax")
                default:
                    break
                }
            case 3:
                cell.imageView.image = UIImage(named: "insulin")
                switch indexPath.item {
                case 0:
                    cell.lbTitle.text = "速效型"
                case 1:
                    cell.lbTitle.text = "長效型"
                case 2:
                    cell.lbTitle.text = "未指定"
                default:
                    break
                }
            default:
                break
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 重置所有 cell 的背景顏色
        for index in 0..<collectionView.numberOfItems(inSection: 0) {
            if let otherCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? LifeCollectionViewCell {
                otherCell.vBackground.backgroundColor = UIColor(red: 255/255, green: 143/255, blue: 149/255, alpha: 1) // 默認顏色
            }
        }
        
        // 設置選中的 cell 的背景顏色
        if let cell = collectionView.cellForItem(at: indexPath) as? LifeCollectionViewCell {
            cell.vBackground.backgroundColor = UIColor(red: 195/255, green: 14/255, blue: 35/255, alpha: 1) // 選中顏色
            print("顏色改變")
            
            // 抓取選中的 cell 的 index
            controlSecondCollectionView = indexPath.item
            print("controlSecondCollectionView: \(controlSecondCollectionView)")
            
            // 計算新的 cell 寬度
            let count = indexarray[controlSecondCollectionView]
            let width = collectionView2.frame.width
            newWidth = count == 0 ? 70 : Int(width) / count // 預設 70 防止 width = 0 時的問
            
            collectionView2.reloadData()

        }
    }
}
