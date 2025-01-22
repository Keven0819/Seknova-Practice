//
//  LifeEvents.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2025/1/22.
//

import Foundation
import RealmSwift

class LifeEvents: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var eventType: String = ""      // 事件類型
    @Persisted var eventTime: Date = Date()    // 事件時間
    @Persisted var eventDetail: String = ""    // 事件詳情
    @Persisted var bloodSugar: Double = 0.0    // 血糖值
    @Persisted var createdAt: Date = Date()    // 創建時間
    
    convenience init(eventType: String, eventTime: Date, eventDetail: String, bloodSugar: Double) {
        self.init()
        self.eventType = eventType
        self.eventTime = eventTime
        self.eventDetail = eventDetail
        self.bloodSugar = bloodSugar
        self.createdAt = Date()
    }
}
