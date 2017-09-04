//
//  DataViewController.swift
//  Vibration Watcher
//
//  Created by Jakk Sut on 11/2/2559 BE.
//  Copyright © 2559 Jakk. All rights reserved.
//

import UIKit
import Charts

class DataViewController: UIViewController, ChartViewDelegate {
    
    var times: [String] = []
    var totals: [Double] = []
    
    var readings: [Reading]?
    
    let ll = ChartLimitLine(limit: 10.0, label: "Target")
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var vibrationLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView! {
        didSet {
            barChartView.noDataTextColor = UIColor.orange
            barChartView.noDataText = "No data received"
            barChartView.chartDescription?.text = "Vibration Data"
            barChartView.xAxis.labelPosition = .bottom
            barChartView.rightAxis.addLimitLine(ll)
            //barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
            barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        }
    }

    @IBAction func saveChart(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(barChartView.getChartImage(transparent: false)!, nil, nil, nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vibrationLabel.text = "Tap chart for info"
        timeLabel.text = " "
        
        axisFormatDelegate = self
        barChartView.delegate = self
        

        for i in 0..<100 {
            totals.append(Double(readings![i].total)!)
            times.append(readings![i].timestamp)
        }
 
        setChart(dataPoints: times, values: totals)
    }
    
    // MARK: - Char Methods
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), yValues: [values[i]], label: times[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Vibration")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        chartDataSet.colors = ChartColorTemplates.joyful()

        barChartView.data = chartData
        
        let xAxis = barChartView.xAxis
        xAxis.valueFormatter = axisFormatDelegate
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("\(entry.x.description) in \(entry)")
        vibrationLabel.text = "\(entry.y)"
        timeLabel.text = "\(times[Int(entry.x)])"
    }
}

// MARK: axisFormatDelegate
extension DataViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
    
}
