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
}