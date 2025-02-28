//
//  UserPreferences.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/16.
//

import Foundation

class UserPreferences {
    
    static let shared = UserPreferences()
    let userPreference: UserDefaults
    
    private init() {
        userPreference = UserDefaults.standard
    }
    
    enum UserPreferenceKey: String {
        case mail
        case password
        case loginCount
        case confirmPassword
        case country
        case newPassword
        case lowSugarValue
        case highSugarValue
        case transmitterDeviceID
        case sensorDeviceID
        case bloodsugarCorrectionValue
        case highAertsValue
        case lowAlertsValue
        case developmentModeKey
        case audioValue
        case adcInitialValue
        case timeIntervalValue
        case yAxisLimitsValue
    }
    
    var mail: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.mail.rawValue) ?? ""
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.mail.rawValue)
        }
    }
    
    var password: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.password.rawValue) ?? ""
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.password.rawValue)
        }
    }
    
    var loginCount: Int? {
        get {
            return userPreference.integer(forKey: UserPreferenceKey.loginCount.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.loginCount.rawValue)
        }
    }
    
    var confirmPassword: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.confirmPassword.rawValue) ?? ""
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.confirmPassword.rawValue)
        }
    }
    
    var country: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.country.rawValue) ?? ""
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.country.rawValue)
        }
    }
    
    var newPassword: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.newPassword.rawValue) ?? ""
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.newPassword.rawValue)
        }
    }
    
    var lowSugarValue: Int? {
        get {
            return userPreference.integer(forKey: UserPreferenceKey.lowSugarValue.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.lowSugarValue.rawValue)
        }
    }
    
    var highSugarValue: Int? {
        get {
            return userPreference.integer(forKey: UserPreferenceKey.highSugarValue.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.highSugarValue.rawValue)
        }
    }
    
    var transmitterDeviceID: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.transmitterDeviceID.rawValue) ?? ""
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.transmitterDeviceID.rawValue)
        }
    }
    
    var sensorDeviceID: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.sensorDeviceID.rawValue) ?? ""
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.sensorDeviceID.rawValue)
        }
    }
    
    var bloodsugarCorrectionValue: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.bloodsugarCorrectionValue.rawValue) ?? ""
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.bloodsugarCorrectionValue.rawValue)
        }
    }
    
    var highAlertsValue: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.highAertsValue.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.highAertsValue.rawValue)
        }
    }
    
    var lowAlertsValue: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.lowAlertsValue.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.lowAlertsValue.rawValue)
        }
    }
    
    var developmentModeKey: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.developmentModeKey.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.developmentModeKey.rawValue)
        }
    }
    
    var audioValue: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.audioValue.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.audioValue.rawValue)
        }
    }
    
    var adcInitialValue: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.adcInitialValue.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.adcInitialValue.rawValue)
        }
    }
    
    var timeIntervalValue: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.timeIntervalValue.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.timeIntervalValue.rawValue)
        }
    }
    
    var yAxisLimitsValue: String? {
        get {
            return userPreference.string(forKey: UserPreferenceKey.yAxisLimitsValue.rawValue)
        }
        set {
            userPreference.set(newValue, forKey: UserPreferenceKey.yAxisLimitsValue.rawValue)
        }
    }
}
