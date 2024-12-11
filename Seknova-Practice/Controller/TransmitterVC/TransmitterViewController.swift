//
//  TransmitterViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/12.
//

import UIKit
import AVFoundation

class TransmitterViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vCamera: UIView!
    
    // MARK: - Property
    // 管理相機擷取的輸入輸出
    var captureSession: AVCaptureSession?
    // 預覽畫面，即將相機擷取到畫面預覽在這層上
    var previewLayer: AVCaptureVideoPreviewLayer?
    // 針對分析到的QRCode，加上框框到畫面上讓使用者知道
    var qrCodeBounds: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - UI Settings
    func setNavigationBar() {
        self.navigationItem.title = "Scanning Transmitter"
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - IBAction
    @IBAction func btnScan(_ sender: Any) {
        vCamera.isHidden = false
        startScanning()
        
        // 簡單的動畫過渡
        qrCodeBounds.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        UIView.animate(withDuration: 1) {
            // 設定框框的大小 , 寬跟高要跟 vCamera 一樣
            self.qrCodeBounds.frame = CGRect(x: 0, y: 0, width: self.vCamera.frame.width, height: self.vCamera.frame.height)
        }
        
        // 再按一次關閉相機
        let button = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeCamera))
        self.navigationItem.rightBarButtonItem = button
        
        // 加上框框到畫面上
        vCamera.addSubview(qrCodeBounds)
    }
    @IBAction func btnTextInput(_ sender: Any) {
        let alertController = UIAlertController(title: "文字輸入", message: "請輸入裝置ID", preferredStyle: .alert)
        
        alertController.addTextField {
            (textField: UITextField) -> Void in
             textField.placeholder = "請輸入裝置 ID 後六碼"
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "確認", style: .default) {_ in
            
            // textFields是一個陣列，取第一個textField的text，所以用first
            let deviceID = alertController.textFields?.first?.text ?? ""
            
            // 儲存裝置 ID
            UserPreferences.shared.transmitterDeviceID = deviceID
            print("Device ID: \(UserPreferences.shared.transmitterDeviceID ?? "")")
            
            let pairingVC = PairingTransmitterViewController()
            self.navigationController?.pushViewController(pairingVC, animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func btnBack(_ sender: Any) {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
        loginVC.navigationItem.hidesBackButton = true
        
        // 清除登入畫面的txfField的text
        loginVC.txfUserName?.text = ""
        loginVC.txfPassword?.text = ""
    }
    
    // MARK: - Function
    func startScanning() {
        // 初始化 AVCaptureSession
        captureSession = AVCaptureSession()
        // 設定相機的解析度
        captureSession?.sessionPreset = .high
        // 取得後置相機
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("No camera found")
            return
        }
        do {
            // 初始化 AVCaptureDeviceInput
            let input = try AVCaptureDeviceInput(device: backCamera)
            // 將 input 加到 captureSession
            captureSession?.addInput(input)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return
        }
        // 初始化 AVCaptureMetadataOutput
        let output = AVCaptureMetadataOutput()
        // 將 output 加到 captureSession
        captureSession?.addOutput(output)
        // 設定 output 的 delegate
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 設定 output 要擷取的資料類型
        output.metadataObjectTypes = [.qr]
        // 初始化 AVCaptureVideoPreviewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        // 設定 previewLayer 的填滿方式
        previewLayer?.videoGravity = .resizeAspectFill
        // 設定 previewLayer 的 frame
        previewLayer?.frame = vCamera.bounds
        // 將 previewLayer 加到 vCamera
        vCamera.layer.addSublayer(previewLayer!)
        // 開始擷取畫面
        captureSession?.startRunning()
    }
    
    @objc func closeCamera() {
        captureSession?.stopRunning()
        vCamera.isHidden = true
        self.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Metadata Output Delegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 停止擷取畫面
        captureSession?.stopRunning()
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let deviceID = metadataObject.stringValue {
            // 儲存裝置 ID
            UserPreferences.shared.transmitterDeviceID = deviceID
            print("Device ID: \(deviceID)")
            
            // 跳轉到配對發射器頁面
            goToPairingTransmitterPage()
        }
    }
    
    func goToPairingTransmitterPage() {
        // 假設 PairingTransmitterViewController 是配對發射器的視圖控制器
        let pairingVC = PairingTransmitterViewController()
        self.navigationController?.pushViewController(pairingVC, animated: true)
    }

}
