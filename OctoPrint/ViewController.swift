//  ViewController.swift
//  OctoPrint
//
//  Created by Mario on 22/06/15.
//  Copyright (c) 2015 Mario. All rights reserved.
//
import Charts
import UIKit

class ViewController: UIViewController {

    let API = OctoPrint()
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [2.0,4.5,3.2,10.9,4,3.3,0.0,0.0,0.0,0.0,0.0,0] as [Float]
        setChart(months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Float]) {
        lineChartView.noDataText = "You need to be connected in order to see something here"
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        lineChartView.data = chartData
        lineChartView.rightAxis.enabled = false
//        lineChartView.xAxis.drawLabelsEnabled = false
//        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.enabled = false
    }
    
    @IBAction func home() {
        API.home()
    }
    
    @IBAction func getTemp() {
        API.getTemp()
    }

    @IBAction func uploadFile() {
        API.uploadFile("test.gcode", destinationPath: "local")
    }
}

