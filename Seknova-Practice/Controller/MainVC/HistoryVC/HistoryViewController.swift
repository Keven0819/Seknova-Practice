//
//  HistoryViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/3.
//

import UIKit
import Charts
import RealmSwift

class HistoryViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vEventDetails: UIView!
    @IBOutlet weak var vChart: LineChartView!
    @IBOutlet weak var segcHr: UISegmentedControl!
    @IBOutlet weak var btnFullScreen: UIButton!
    @IBOutlet weak var btnLastData: UIButton!
    @IBOutlet weak var imgFullScreen: UIImageView!
    @IBOutlet weak var imgLastData: UIImageView!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vEventDetails.isHidden = true
        startRandomNumberUpdate()
        setupChart()
        XAxisUpdate()
        events = Array(realm.objects(LifeEvents.self))
        segcHr.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
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
