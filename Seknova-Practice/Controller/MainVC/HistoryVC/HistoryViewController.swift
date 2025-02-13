//
//  HistoryViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit
import Charts
import RealmSwift

class HistoryViewController: UIViewController, ChartViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vEventDetails: UIView!
    @IBOutlet weak var vChart: LineChartView!
    @IBOutlet weak var segcHr: UISegmentedControl!
    @IBOutlet weak var btnFullScreen: UIButton!
    @IBOutlet weak var btnLastData: UIButton!
    @IBOutlet weak var imgFullScreen: UIImageView!
    @IBOutlet weak var imgLastData: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    
    // MARK: - Property
    var number = Int.random(in: 55...400)
    var timer: Timer?
    var chartEntries: [ChartDataEntry] = []
    var xAxisLabels: [String] = []
    var timeAxisEntries: [ChartDataEntry] = []
    var labelInterval: TimeInterval = 12 * 60
    var events: [LifeEvents] = []
    let realm = try! Realm()
    var isFullScreen = false
    
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEventsFromRealm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vEventDetails.isHidden = true
        startRandomNumberUpdate()
        setupChart()
        XAxisUpdate()
        events = Array(realm.objects(LifeEvents.self))
        segcHr.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        loadEventsFromRealm() // 讀取事件
        
        vChart.delegate = self // 設定代理
    }
    
    // MARK: - UI Settings
    
    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        let hours = [1, 3, 6, 12, 24][sender.selectedSegmentIndex]
        updateChartForTimeInterval(hours: hours)
    }
    
    func setupChart() {
        vChart.rightAxis.enabled = false
        vChart.xAxis.labelPosition = .bottom
        vChart.xAxis.drawGridLinesEnabled = true
        vChart.leftAxis.drawGridLinesEnabled = true
        vChart.rightAxis.drawGridLinesEnabled = true
        vChart.xAxis.drawAxisLineEnabled = true
        
        vChart.legend.enabled = false
        vChart.chartDescription.enabled = false
        
        let yAxis = vChart.leftAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 400
        yAxis.granularity = 100
        yAxis.labelCount = 5
        
        vChart.setVisibleXRange(minXRange: 0, maxXRange: 5 * labelInterval)
        vChart.setExtraOffsets(left: 0, top: 10, right: 0, bottom: 10)
        
        setInitialXAxisLabels()
    }
    
    func loadEventsFromRealm() {
        let realm = try! Realm()
        events = Array(realm.objects(LifeEvents.self).sorted(byKeyPath: "timestamp", ascending: true)) // 依時間排序
        updateChartWithEvents()
    }
    
    func updateChartWithEvents() {
        chartEntries.removeAll()
        
        for event in events {
            let timestamp = event.timestamp
            let icon = getEventIcon(event.eventId, eventValue: event.eventValue)?.resize(to: CGSize(width: 30, height: 30)) // 🔹 設定圖示大小
            
            let newEntry = ChartDataEntry(x: timestamp, y: 20, icon: icon) // 🔹 y 設為 0 避免產生曲線
            chartEntries.append(newEntry)
        }

        let dataSet = LineChartDataSet(entries: chartEntries)
        dataSet.drawIconsEnabled = true
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = false
        dataSet.highlightEnabled = false
        dataSet.colors = [.clear]

        let chartData = LineChartData(dataSet: dataSet)
        vChart.data = chartData
        vChart.notifyDataSetChanged()
    }

    
    func getEventIcon(_ eventId: Int, eventValue: Int) -> UIImage? {
        switch eventId {
        case 0:
            switch eventValue {
            case 0:
                return UIImage(named: "breakfast")
            case 1:
                return UIImage(named: "launch")
            case 2:
                return UIImage(named: "dinner")
            case 3:
                return UIImage(named: "snacks")
            case 4:
                return UIImage(named: "dinrks")
            default:
                break
            }
        case 1:
            switch LifeEvents().eventValue {
            case 0:
                return UIImage(named: "high_motion")
            case 1:
                return UIImage(named: "mid_motion")
            case 2:
                return UIImage(named: "low_motion")
            default:
                break
            }
        case 2:
            return UIImage(named: "insulin")
        case 3:
            return UIImage(named: "awaken")
        case 4:
            return UIImage(named: "bath")
        case 5:
            return UIImage(named: "other")
        default:
            break
        }
        return nil
    }

    // MARK: - IBAction
    @IBAction func fullScreen(_ sender: Any) {
        let fullVC = HorizontalHistoryViewController()
        self.navigationController?.pushViewController(fullVC, animated: true)
    }
    
    // MARK: - Function
    func updateChartForTimeInterval(hours: Int) {
        labelInterval = TimeInterval(hours) * 12 * 60
        vChart.xAxis.granularity = labelInterval
        
        timeAxisEntries.removeAll()
        createTimeAxisEntries(currentTime: Date())
        generateXAxisLabels()
        setInitialXAxisLabels()
        
        vChart.setVisibleXRange(minXRange: 0, maxXRange: 5 * labelInterval)
    }
    
    func startRandomNumberUpdate() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateRandomNumber()
        }
    }
    
    @objc func updateRandomNumber() {
        number = Int.random(in: 55...400)
        let currentTime = Date()
        addDataPoint(i: Double(number), currentTime: currentTime)
        createTimeAxisEntries(currentTime: currentTime)
    }
    
    func addDataPoint(i: Double, currentTime: Date) {
        guard !i.isNaN else { return }
        
        let timestamp = currentTime.timeIntervalSince1970
        let newEntry = ChartDataEntry(x: timestamp, y: i)
        chartEntries.append(newEntry)
        
        let dataSet = LineChartDataSet(entries: chartEntries)
        configureDataSet(dataSet)
        
        let timeAxisDataSet = LineChartDataSet(entries: timeAxisEntries)
        configureTimeAxisDataSet(timeAxisDataSet)
        
        let chartData = LineChartData(dataSets: [dataSet, timeAxisDataSet])
        vChart.data = chartData
        
        updateChartVisibleRange()
    }
    
    func configureDataSet(_ dataSet: LineChartDataSet) {
        dataSet.colors = [.red]
        dataSet.circleColors = [.systemRed]
        dataSet.circleRadius = 2.0
        dataSet.drawValuesEnabled = false
    }
    
    func configureTimeAxisDataSet(_ dataSet: LineChartDataSet) {
        dataSet.colors = [.clear]
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
    }
    
    func updateChartVisibleRange() {
        vChart.xAxis.granularity = labelInterval
        vChart.setVisibleXRange(minXRange: 0, maxXRange: 5 * labelInterval)
    }
    
    func createTimeAxisEntries(currentTime: Date) {
        timeAxisEntries.removeAll()
        for i in 0..<6 {
            let futureTime = currentTime.addingTimeInterval(Double(i - 5) * labelInterval)
            let timeEntry = ChartDataEntry(x: futureTime.timeIntervalSince1970, y: 0)
            timeAxisEntries.append(timeEntry)
        }
    }
    
    func XAxisUpdate() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.generateXAxisLabels()
        }
    }
    
    func generateXAxisLabels() {
        xAxisLabels.removeAll()
        let currentTime = Date()
        
        for i in 0..<6 {
            let pastTime = currentTime.addingTimeInterval(Double(i - 5) * labelInterval)
            let formattedTime = formatTime(pastTime)
            xAxisLabels.append(formattedTime)
        }
        
        vChart.xAxis.setLabelCount(6, force: true)
        vChart.xAxis.valueFormatter = self
        vChart.notifyDataSetChanged()
    }
    
    func setInitialXAxisLabels() {
        xAxisLabels = generateTimeLabelsFromCurrentTime()
        vChart.xAxis.setLabelCount(6, force: true)
        vChart.xAxis.valueFormatter = self
        vChart.notifyDataSetChanged()
    }
    
    func generateTimeLabelsFromCurrentTime() -> [String] {
        var labels: [String] = []
        let currentTime = Date()
        
        for i in 0..<6 {
            let pastTime = currentTime.addingTimeInterval(Double(i - 5) * labelInterval)
            labels.append(formatTime(pastTime))
        }
        return labels
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
    func updateChartData() {
        generateXAxisLabels()
        vChart.notifyDataSetChanged()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let selectedEvent = events.first(where: { $0.timestamp == entry.x }) else {
            return
        }
        
        lbTitle.text = selectedEvent.event  // 事件名稱
        lbTime.text = selectedEvent.displayTime // 事件時間
        
        if selectedEvent.eventId == 0 {
            lbName.text = selectedEvent.mealName + " " + selectedEvent.mealNum // 用餐名稱
        } else if selectedEvent.eventId == 1 {
            lbName.text = selectedEvent.exeName + " " + selectedEvent.exeTime // 運動名稱
        } else if selectedEvent.eventId == 2 {
            lbName.text = selectedEvent.sleepTime // 睡眠時間
        } else if selectedEvent.eventId == 3 {
            lbName.text = selectedEvent.doseG // 胰島素劑量
        } else {
            lbName.text = "" // 其他
        }
        vEventDetails.isHidden = false      // 顯示事件資訊 View
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        vEventDetails.isHidden = true // 點擊空白區域時隱藏
    }
}

// MARK: - Extensions
extension HorizontalHistoryViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let timestamp = Date(timeIntervalSince1970: value)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: timestamp)
    }
}
