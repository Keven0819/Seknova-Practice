//
//  UserInformation.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/17.
//

import RealmSwift

class UserInformation: Object {
    //uuid
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var FirstName: String
    @Persisted var LastName: String
    @Persisted var Birthday: String
    @Persisted var Email: String
    @Persisted var Phone: String
    @Persisted var Address: String
    @Persisted var Gender: String
    @Persisted var Height: String
    @Persisted var Weight: String
    @Persisted var Race: String
    @Persisted var Liquor: String
    @Persisted var Smoke: String
    @Persisted var Check: Bool
    @Persisted var Phone_Verified: Bool
    
    convenience init(FirstName: String, LastName: String,
                     Birthday: String, Email: String, Phone: String,
                     Address: String, Gender: String, Height: String,
                     Weight: String, Race: String, Liquor: String,
                     Smoke: String, Check: Bool, Phone_Verified: Bool) {
        self.init()
        self.FirstName = FirstName
        self.LastName = LastName
        self.Birthday = Birthday
        self.Email = Email
        self.Phone = Phone
        self.Address = Address
        self.Gender = Gender
        self.Height = Height
        self.Weight = Weight
        self.Race = Race
        self.Liquor = Liquor
        self.Smoke = Smoke
        self.Check = Check
        self.Phone_Verified = Phone_Verified
    }
}

class LifeEvents: Object {
    @Persisted var id: String = UUID().uuidString  // 使用 UUID 作为主键
    @Persisted var event: String = ""
    @Persisted var dateTime: String = ""
    @Persisted var displayTime: String = ""
    @Persisted var mealName: String = ""
    @Persisted var mealNum: String = ""
    @Persisted var exeName: String = ""
    @Persisted var exeTime: String = ""
    @Persisted var doseG: String = ""
    @Persisted var sleepTime: String = ""
    @Persisted var eventId: Int = 0  // 用於儲存第一個collectionView的Tag
    @Persisted var eventValue: Int = 0 //用於儲存第二個collectionView的Tag
    @Persisted var note: String = ""
    @Persisted var check: Bool = false
    
    // 设置主键
    override static func primaryKey() -> String? {
        return "id"  // 以 UUID 作为主键
    }
    
    // convenience init 方法
    convenience init(event: String,
                     dateTime: String,
                     displayTime: String,
                     mealName: String,
                     mealNum: String,
                     exeName: String,
                     exeTime: String,
                     doseG: String,
                     sleepTime: String,
                     eventId: Int,
                     eventValue: Int,
                     note: String,
                     check: Bool)
    {
        self.init()
        self.event = event
        self.dateTime = dateTime
        self.displayTime = displayTime
        self.mealName = mealName
        self.mealNum = mealNum
        self.exeName = exeName
        self.exeTime = exeTime
        self.doseG = doseG
        self.sleepTime = sleepTime
        self.eventId = eventId // 用於儲存選擇到的tag
        self.eventValue = eventValue
        self.note = note
        self.check = check
    }
}

class Record: Object {
    @Persisted var id: String = UUID().uuidString  // 使用 UUID 作為主鍵
    @Persisted var count: Int = 0
    @Persisted var recordTime: String = "" // 記錄時間
    @Persisted var displayTime: String = "" // 顯示時間
    @Persisted var temperature: Int = 0
    @Persisted var adc1: Int = 0
    @Persisted var battery: Int = 0
    @Persisted var check: Bool = false
    @Persisted var calibrated: Bool = false

    // 設置主鍵
    override static func primaryKey() -> String? {
        return "id"
    }

    // Convenience Init 方法
    convenience init(count: Int,
                     recordTime: String,
                     displayTime: String,
                     temperature: Int,
                     adc1: Int,
                     battery: Int,
                     check: Bool,
                     calibrated: Bool) {
        self.init()
        self.count = count
        self.recordTime = recordTime
        self.displayTime = displayTime
        self.temperature = temperature
        self.adc1 = adc1
        self.battery = battery
        self.check = check
        self.calibrated = calibrated
    }
}

class CalibrationModeData: Object {
    @Persisted var id: String = UUID().uuidString  // 使用 UUID 作為主鍵
    @Persisted var modeID: Int = 0
    @Persisted var rawData2BGBias: Int = 0
    @Persisted var bgBias: Int = 0
    @Persisted var gLow: Int = 0
    @Persisted var bgHigh: Int = 0
    @Persisted var mapRate: Int = 0
    @Persisted var thresholdRise: Int = 0
    @Persisted var thresholdFall: Int = 0
    @Persisted var riseRate: Int = 0
    @Persisted var fallenRate: Int = 0

    // 設置主鍵
    override static func primaryKey() -> String? {
        return "id"
    }

    // Convenience Init 方法
    convenience init(modeID: Int,
                     rawData2BGBias: Int,
                     bgBias: Int,
                     gLow: Int,
                     bgHigh: Int,
                     mapRate: Int,
                     thresholdRise: Int,
                     thresholdFall: Int,
                     riseRate: Int,
                     fallenRate: Int) {
        self.init()
        self.modeID = modeID
        self.rawData2BGBias = rawData2BGBias
        self.bgBias = bgBias
        self.gLow = gLow
        self.bgHigh = bgHigh
        self.mapRate = mapRate
        self.thresholdRise = thresholdRise
        self.thresholdFall = thresholdFall
        self.riseRate = riseRate
        self.fallenRate = fallenRate
    }
}
