//
//  HApkvTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/7.
//

import UIKit

protocol HApkvTableViewCellDelegate: AnyObject {
    func didSelectValue(_ value: String)
}

class HApkvTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    static let identifier = "HApkvTableViewCell"
    
    weak var delegate: HApkvTableViewCellDelegate?
    
    var highArray = ["-"] + (150...250).map { String($0) }
    var lowArray = ["-"] + (70...90).map { String($0) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupPickerView()
        selectRow()
        
        // 高血糖警示陣列
        print(highArray)
        
        // 低血糖警示陣列
        print(lowArray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // 根據我之前選擇的值跳轉
    func selectRow() {
        if HighOrLow.shared.highOrLow {
            if let index = highArray.firstIndex(of: UserPreferences.shared.highAlertsValue ?? "") {
                pickerView.selectRow(index, inComponent: 0, animated: true)
            }
        } else {
            if let index = lowArray.firstIndex(of: UserPreferences.shared.lowAlertsValue ?? "") {
                pickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
}

extension HApkvTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if HighOrLow.shared.highOrLow {
            return highArray.count
        } else {
            return lowArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if HighOrLow.shared.highOrLow {
            return highArray[row]
        } else {
            return lowArray[row]
        }
    }
    
    // 當使用者選擇某個選項時觸發
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("選擇了：\(highArray[row])")
        
        if HighOrLow.shared.highOrLow {
            let selectedValue = highArray[row]
            delegate?.didSelectValue(selectedValue)
        } else {
            let selectedValue = lowArray[row]
            delegate?.didSelectValue(selectedValue)
        }
    }
}
