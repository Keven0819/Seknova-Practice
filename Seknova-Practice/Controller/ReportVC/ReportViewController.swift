//
//  ReportViewController.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/12/5.
//

import UIKit
import Charts

class ReportViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var segcChangeCharts: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var barCharView: BarChartView!
    @IBOutlet weak var segcChangeTime: UISegmentedControl!
    
    // MARK: - Property
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let randomData = generateBarChartRandomEntries()
        let dataEntries = (0..<4).map { _ in generateRandomEntries() }
        setupBarChart(with: randomData)
        setupLineChart(with: dataEntries)
        viewDidLoadTime()
        barCharView.isHidden = true
        lineChartView.isHidden = false
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "報表"
    }
    
    // MARK: - IBAction
    @IBAction func changeChart(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            barCharView.isHidden = true
            lineChartView.isHidden = false
        case 1:
            barCharView.isHidden = false
            lineChartView.isHidden = true
        default:
            break
        }
    }
    @IBAction func changeTime(_ sender: Any) {
        
        // 抓現在的時間
        let currentDate = Date()
        
        let caldendar = Calendar.current
        
        // 用選擇的段落更新日期範圍
        var startDate: Date
        var endDate: Date = currentDate
        
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            // 過去7天
            startDate = caldendar.date(byAdding: .day, value: -7, to: currentDate)!
            lbTime.text = "Data available for 7 of 30 days"
        case 1:
            // 過去14天
            startDate = caldendar.date(byAdding: .day, value: -14, to: currentDate)!
            lbTime.text = "Data available for 14 of 30 days"
        case 2:
            // 過去30天
            startDate = caldendar.date(byAdding: .day, value: -30, to: currentDate)!
            lbTime.text = "Data available for 30 of 30 days"
        default:
            startDate = currentDate
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        let dateRange = "\(startDateString) ~ \(endDateString)"
        lbTime.text = dateRange
        
        let randomEntries = generateBarChartRandomEntries()
        
        let dataEntries = (0..<4).map { _ in generateRandomEntries() }
        setupLineChart(with: dataEntries)
    }
    
    // MARK: - Function
    func setupBarChart(with entries: [BarChartDataEntry]) {
        // 創建資料集
        let dataSet = BarChartDataSet(entries: entries, label: "資料")
        
        // 設置每個柱狀圖的顏色
        dataSet.colors = [
            UIColor(red: 193/255, green: 15/255, blue: 36/255, alpha: 1),   // #C10F24
            UIColor(red: 243/255, green: 175/255, blue: 34/255, alpha: 1),  // #F3AF22
            UIColor(red: 87/255, green: 159/255, blue: 43/255, alpha: 1),   // #579F2B
            UIColor(red: 239/255, green: 89/255, blue: 49/255, alpha: 1)    // #EF5931
        ]
        
        // 設置資料標籤
        dataSet.drawValuesEnabled = true
        dataSet.valueFont = .systemFont(ofSize: 14) // 设置数据标签字体大小
        dataSet.valueTextColor = .black // 设置数据标签颜色
        
        // 創建 BarChartData
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.7 // 设置直方条宽度
        
        // 設置資料給 barChartView
        barCharView.data = data
        
        // 隱藏 X 軸與 Y 軸的網格線
        barCharView.xAxis.drawGridLinesEnabled = false
        barCharView.leftAxis.drawGridLinesEnabled = false
        barCharView.rightAxis.drawGridLinesEnabled = false
        barCharView.xAxis.drawAxisLineEnabled = false
        // 隱藏 Y 軸右邊的軸線
        barCharView.rightAxis.enabled = false
        
        barCharView.leftAxis.enabled = false
        
        // 隐藏顶部描述标签
        barCharView.chartDescription.enabled = false
        
        // 隐藏图例
        barCharView.legend.enabled = false
        
        // 設置 X 軸標籤
        let xAxis = barCharView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: [">240", "180-240", "70-180", "<70"])
        xAxis.granularity = 1
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 16) // 设置 X 轴标签字体大小
        
        // 更新圖表
        barCharView.notifyDataSetChanged()
    }
    
    func setupLineChart(with entries: [[ChartDataEntry]]) {
        // 創建多個資料集
        let colors: [UIColor] = [.blue, .blue, .blue, .blue]
        var dataSets: [LineChartDataSet] = []
        
        // 添加四條填滿的線
        for i in 0..<entries.count {
            let dataSet = LineChartDataSet(entries: entries[i], label: "資料集 \(i+1)")
            dataSet.colors = [colors[i]]
            dataSet.circleColors = [colors[i]] // 設定資料點顏色
            dataSet.circleRadius = 0
            dataSet.mode = .horizontalBezier
            dataSet.drawFilledEnabled = true
            dataSet.fillColor = colors[i]
            dataSet.fillAlpha = 0.5
            dataSet.valueFont = .systemFont(ofSize: 10)
            dataSet.valueTextColor = .clear
            dataSets.append(dataSet)
        }
        
        // 添加一條黑色粗線
        let thickLineDataSet = LineChartDataSet(entries: entries[0], label: "粗黑線")
        thickLineDataSet.colors = [.black]
        thickLineDataSet.circleRadius = 0
        thickLineDataSet.lineWidth = 3
        thickLineDataSet.mode = .horizontalBezier
        thickLineDataSet.drawFilledEnabled = false
        thickLineDataSet.valueTextColor = .clear
        dataSets.append(thickLineDataSet)
        
        let data = LineChartData(dataSets: dataSets)
        lineChartView.data = data
        
        // 設定 X 軸樣式
        let xAxis = lineChartView.xAxis
        let TimeArray = ["12am", "3am", "6am", "9am", "12pm", "3pm", "6pm", "9pm", "12am"]
        xAxis.valueFormatter = IndexAxisValueFormatter(values: TimeArray)
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 12)
        //xAxis.centerAxisLabelsEnabled = false  // 關閉居中標籤
        
        xAxis.setLabelCount(9, force: true)  // 確保顯示所有標籤
        xAxis.drawGridLinesEnabled = true  // 顯示網格線以對齊
        print("entries.count: \(entries.count)")
        print("TimeArray.count: \(TimeArray.count)")
        // 設定 Y 軸
        let yAxis = lineChartView.leftAxis
        yAxis.axisMinimum = 1
        yAxis.axisMaximum = 350
        yAxis.labelCount = 7
        yAxis.valueFormatter = DefaultAxisValueFormatter(formatter: numberFormatter())
        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.enabled = true
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.chartDescription.enabled = false
        lineChartView.notifyDataSetChanged()
    }
    
    func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.positiveFormat = "###"
        return formatter
    }
    
    func generateBarChartRandomEntries() -> [BarChartDataEntry] {
        let values: [Double] = [3.1, 6.2, 12.5, 0.0, 9.4, 15.6, 31.2, 50.0, 25.0, 34.4, 28.1, 43.8, 37.5, 18.8, 40.6, 53.1, 59.4, 56.2, 40.6, 71.9]
        var entries: [BarChartDataEntry] = []
        
        for i in 0..<4 {
            let randomIndex = Int.random(in: 0..<values.count)
            let entry = BarChartDataEntry(x: Double(i), y: values[randomIndex])
            entries.append(entry)
        }
        return entries
    }
    
    func generateRandomEntries() -> [ChartDataEntry] {
        let values: [Double] = [3.1, 6.2, 12.5, 0.0, 9.4, 15.6, 31.2, 50.0, 25.0, 34.4, 28.1, 43.8, 37.5, 18.8, 40.6, 53.1, 59.4, 56.2, 40.6, 71.9]
        var entries: [ChartDataEntry] = []
        for i in 0..<9 {
            let randomIndex = Int.random(in: 0..<values.count)
            let entry = ChartDataEntry(x: Double(i), y: values[randomIndex] * 4)
            entries.append(entry)
        }
        return entries
    }
    
    func viewDidLoadTime() {
        // 直接设定7天的日期范围
        let currentDate = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        
        // 格式化日期
        let formattedStartDate = dateFormatter.string(from: startDate)
        let formattedEndDate = dateFormatter.string(from: currentDate)
        
        // 显示7天的日期范围
        lbTime.text = "\(formattedStartDate) - \(formattedEndDate)"
        
        // 设置 segmented control 默认选中为 7 天
        segcChangeTime.selectedSegmentIndex = 0
    }
}

// MARK: - Extensions
