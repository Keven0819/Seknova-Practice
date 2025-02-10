//
//  AudiopkvTableViewCell.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/2/10.
//

import UIKit

protocol AudiopkvTableViewCellDelegate: AnyObject {
    func didSelectValue(_ value: String)
}

class AudiopkvTableViewCell: UITableViewCell {
    
    static let identifier = "AudiopkvTableViewCell"
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    weak var delegate: AudiopkvTableViewCellDelegate?
    
    var audioArray = ["-", "sound1", "sound2", "sound3", "sound4", "sound5"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupPickerView()
        selectRow()
        
        print(audioArray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func selectRow() {
        if let index = audioArray.firstIndex(of: UserPreferences.shared.audioValue ?? "") {
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
}

extension AudiopkvTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return audioArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return audioArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectValue(audioArray[row])
    }
}
