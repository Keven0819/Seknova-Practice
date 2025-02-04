//
//  LifeEvents.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/1/22.
//

import Foundation

class editOrNot{
    var isEditingMode = false
    static let shared = editOrNot()
    private init() {}
}

class LifeEventData {
    static let shared = LifeEventData()
    var UUnum: String?  // 可選的 String
    var selectedCVTag0: Int = 0 //選擇ＣＶ0的tag
    var selectedCVTag1: Int = 0 //選擇ＣＶ1的tag
    var event1: String?
    var event2: String?
    var event3: String?
}

class landscapeMode{
    var isLandscapeMode = false
    static let shared = landscapeMode()
    private init() {}
}

class bloodSugarMode {
    static let shared = bloodSugarMode()
    var highBloodSugarMode = false
//    var highBloodSugarModeAlert = false
//    var lowBloodSugarModeAlert = false
//    var highBloodSugar: String = "無"
//    var lowBloodSugar: String = "無"
    private init() {}
}
