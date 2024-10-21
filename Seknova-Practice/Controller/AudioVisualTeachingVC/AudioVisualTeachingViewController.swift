//
//  AudioVisualTeachingViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/21.
//

import UIKit
import WebKit

class AudioVisualTeachingViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnNext: UIButton!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUrl()
    }
    
    // MARK: - UI Settings
    
    // MARK: - IBAction
    @IBAction func turnVC(_ sender: Any) {
        
        let beVC = BloodSugarViewController()
        self.navigationController?.pushViewController(beVC, animated: true)
    }
    
    // MARK: - Function
    
    func getUrl() {
        let url = URL(string: "https://youtube.com/embed/Tzmisk385aw")!
        let request = URLRequest(url: url)
        
        // 設定 WKWebViewConfiguration
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        webViewConfiguration.mediaTypesRequiringUserActionForPlayback = [] // 禁止全屏播放
        
        // 計算垂直居中位置
        let webViewHeight: CGFloat = 200
        let webViewY = (self.view.frame.height - webViewHeight) / 2
        
        
        // 設定固定大小
        let webView = WKWebView(frame: CGRect(x: 0, y: webViewY, width: self.view.frame.width, height: webViewHeight), configuration: webViewConfiguration)
        webView.load(request)
        
        self.view.addSubview(webView) // 将 webView 添加到视图中
    }
}

// MARK: - Extensions
