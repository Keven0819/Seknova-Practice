//
//  InstantBloodSugarViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/11/21.
//

import UIKit
import SwiftUI
import CoreBluetooth
import Network
import Charts

class InstantBloodSugarViewController: UIViewController, CBCentralManagerDelegate {
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgvBluetooth: UIImageView!
    @IBOutlet weak var imgvNetwork: UIImageView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var myView: LineChartView!
    
    // MARK: - Property
    var centralManager: CBCentralManager?
    var number: Int = 0
    var timer = Timer()
    
    var chartEntries: [ChartDataEntry] = []
    var xAxisLabels: [String] = []
    var timeAxisEntries: [ChartDataEntry] = []  // Store the fixed time axis data
    let labelInterval: TimeInterval = 12 * 60  // 12-minute interval (in seconds)
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化 centralManager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        checkWiFiStatus()
        
        test()
        // 折線圖
        setupChart()
        XAxisUpdate()
    }
    
    // MARK: - UI Settings
    
    // Bluetooth 狀態處理
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            imgvBluetooth.image = UIImage(named: "bluetooth-check")
        case .poweredOff:
            imgvBluetooth.image = UIImage(named: "bluetooth-false")
        case .unauthorized:
            print("Bluetooth permissions not granted.")
        case .unsupported:
            print("Bluetooth is not supported on this device.")
        default:
            print("Unknown Bluetooth state.")
        }
    }
    
    func checkWiFiStatus() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")

        // 檢查網路狀態
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        self.imgvNetwork.image = UIImage(named: "network-check")
                    } else {
                        self.imgvNetwork.image = UIImage(named: "network-false")
                    }
                } else {
                    self.imgvNetwork.image = UIImage(named: "network-false")
                }
            }
        }

        // 啟動監視器
        monitor.start(queue: queue)

        // 檢查初始網路狀態
        DispatchQueue.global().async {
            let path = monitor.currentPath
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        self.imgvNetwork.image = UIImage(named: "network-check")
                    } else {
                        self.imgvNetwork.image = UIImage(named: "network-false")
                    }
                } else {
                    self.imgvNetwork.image = UIImage(named: "network-false")
                }
            }
        }
    }
    // MARK: - IBAction
    
    @objc func timerAction() {
        number = Int.random(in: 55...400)
        lbValue.text = "\(number)"
        
        let currentTime = Date()
        
        addDataPoint(i: Double(number), currentTime: currentTime)
        createTimeAxisEntries(currentTime: currentTime)
        
        if myView.data == nil {
            print("Chart data is empty!")
        }
    }
    
    @objc func updateXaxis() {
       generateXAxisLabels()
    }
    
    // MARK: - Function
    func test () {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func XAxisUpdate() {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateXaxis), userInfo: nil, repeats: true)
    }
    
    func generateXAxisLabels() {
        // 清空現有的 X 軸標籤
        xAxisLabels.removeAll()
        
        // 取得現在的時間
        let currentTime = Date()
        
        // 生成六個標籤，每個標籤間隔12分鐘
        for i in 0..<6 {
            let futureTime = currentTime.addingTimeInterval(Double(i) * 12 * 60 )  // 每 12 分鐘一個標籤
            let formattedTime = formatTime(futureTime)  // 格式化時間為 HH:mm
            print("Generated time for index \(i): \(formattedTime)")
            
            xAxisLabels.append(formattedTime)  // 將格式化後的時間加入 xAxisLabels
        }
        
        // 設定圖表的 X 軸顯示的標籤
        myView.xAxis.labelCount = 6  // 更新 X 軸標籤數量
        myView.xAxis.valueFormatter = self  // 設定時間格式化
        myView.notifyDataSetChanged()  // 通知圖表更新
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"  // 設置時間顯示格式
        return formatter.string(from: date)
    }
    
    func addDataPoint(i: Double, currentTime: Date) {
            // Ensure the value is a valid number and not NaN
            guard !i.isNaN else {
                print("Invalid data value (NaN), skipping this entry")
                return
            }
            
            // Use the passed currentTime to get the timestamp
            let timestamp = currentTime.timeIntervalSince1970
            let newEntry = ChartDataEntry(x: timestamp, y: i)
            chartEntries.append(newEntry)
            
            // Create the data set for random number line
            let dataSet = LineChartDataSet(entries: chartEntries)
            dataSet.colors = [.red]  // Red line for the random data
            dataSet.circleColors = [.systemRed]
            dataSet.circleRadius = 2.0
            dataSet.drawValuesEnabled = false  // Disable the data labels on the chart
            
            // Create the time axis dataset (hidden)
            let timeAxisDataSet = LineChartDataSet(entries: timeAxisEntries)
            timeAxisDataSet.colors = [.clear]  // Make this dataset clear, so it's hidden
            timeAxisDataSet.drawCirclesEnabled = false
            timeAxisDataSet.drawValuesEnabled = false
            
            // Add both datasets to the chart data
            let chartData = LineChartData(dataSets: [dataSet, timeAxisDataSet])
            myView.data = chartData
            
            // Update the visible range based on 12-minute intervals
            myView.xAxis.granularity = 12 * 60
            myView.setVisibleXRange(minXRange: 0, maxXRange: 12 * 5 * 60)
    }
    
    func setInitialXAxisLabels() {
        let initialLabels = generateTimeLabelsFromCurrentTime()
        xAxisLabels = initialLabels
        //            myView.xAxis.labelCount = 6
        myView.xAxis.setLabelCount(6, force: true)
        myView.xAxis.valueFormatter = self
        myView.notifyDataSetChanged()
    }
    
    func generateTimeLabelsFromCurrentTime() -> [String] {
        var labels: [String] = []
        let currentTime = Date()
        
        for i in 0..<6 {
            let futureTime = currentTime.addingTimeInterval(Double(i) * 12 * 60)
            let formattedTime = formatTime(futureTime)
            labels.append(formattedTime)
        }
        return labels
    }
    
    func setupChart() {
        myView.rightAxis.enabled = false
        myView.xAxis.labelPosition = .bottom
        myView.xAxis.drawGridLinesEnabled = true
        myView.leftAxis.drawGridLinesEnabled = true
        myView.rightAxis.drawGridLinesEnabled = true
        myView.xAxis.drawAxisLineEnabled = true
        
        myView.legend.enabled = false
        myView.chartDescription.enabled = false
        myView.leftAxis.axisMinimum = 0
        myView.leftAxis.axisMaximum = 400
        
        let yAxis = myView.leftAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 400
        yAxis.granularity = 100
        yAxis.labelCount = 5
        
        myView.xAxis.granularity = 12 * 60
        myView.setVisibleXRange(minXRange: 0, maxXRange: 12 * 5 * 60)
        //myView.setScaleEnabled(true)
        // Setting the X axis labels initially
        for i in 80...200 {
            let fillLine = ChartLimitLine(limit: Double(i))
            fillLine.lineWidth = 1
            fillLine.lineColor = UIColor.systemOrange.withAlphaComponent(0.3)
            myView.leftAxis.addLimitLine(fillLine)
        }
        setInitialXAxisLabels()

    }
    
    func createTimeAxisEntries(currentTime: Date) {
        if timeAxisEntries.isEmpty {
            for i in 0..<7 {
                let futureTime = currentTime.addingTimeInterval(Double(i) * labelInterval)
                let timeEntry = ChartDataEntry(x: futureTime.timeIntervalSince1970, y: 0)  // 隱藏的時間軸數據
                timeAxisEntries.append(timeEntry)
            }
        }
    }
}

// MARK: - Extensions
extension InstantBloodSugarViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let timestamp = Date(timeIntervalSince1970: value)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp)
    }
}
