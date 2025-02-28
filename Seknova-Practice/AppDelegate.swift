//
//  AppDelegate.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/9/23.
//

import UIKit
import RealmSwift
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        resetRealmDatabase()
        // IQKeyboardManager設定
        IQKeyboardManager.shared().isEnabled = true
        
        // 點擊空白處收起鍵盤
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        IQKeyboardManager.shared().toolbarDoneBarButtonItemText = "完成"
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 10
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysShow
        
        
        // 重設 Realm 數據庫
        func resetRealmDatabase() {
            let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
            let realmURLs = [
                realmURL,
                realmURL.appendingPathExtension("lock"),
                realmURL.appendingPathExtension("note"),
                realmURL.appendingPathExtension("management")
            ]

            for URL in realmURLs {
                do {
                    try FileManager.default.removeItem(at: URL)
                    print("Realm 數據庫文件已成功刪除: \(URL)")
                } catch let error as NSError {
                    print("刪除 Realm 數據庫文件時出錯: \(error.localizedDescription)")
                }
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

