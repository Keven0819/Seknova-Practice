//
//  SceneDelegate.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/9/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootVC = MainViewController(nibName: "MainViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootVC)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        // 檢查 iOS 版本是否是 iOS 15.0 或更新版本
        if #available(iOS 15.0, *) {
            // 創建導航欄外觀的配置對象
            let appearance = UINavigationBarAppearance()
            
            // 配置外觀為不透明背景
            appearance.configureWithOpaqueBackground()
            
            // 設置導航欄的背景顏色
            appearance.backgroundColor = #colorLiteral(red: 0.7579411864, green: 0.05860135704, blue: 0.1392720342, alpha: 1) // 深紅色
            
            // 設置導航欄按鈕的顏色
            navigationController.navigationBar.tintColor = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1) // 白色
            
            // 設置導航欄標題文字的顏色
            appearance.titleTextAttributes = [
                .foregroundColor: #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1) // 白色
            ]
            
            // 將配置應用於標準狀態下和滾動邊緣的導航欄外觀
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        } else {
            // 如果設備的 iOS 版本低於 15.0，則使用舊的方法設置導航欄外觀
            
            // 設置導航欄背景顏色
            navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.7579411864, green: 0.05860135704, blue: 0.1392720342, alpha: 1) // 深紅色
            
            // 設置導航欄按鈕的顏色
            navigationController.navigationBar.tintColor = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1) // 白色
            
            // 設置導航欄標題文字的顏色
            navigationController.navigationBar.titleTextAttributes = [
                .foregroundColor: #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 1) // 白色
            ]
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

