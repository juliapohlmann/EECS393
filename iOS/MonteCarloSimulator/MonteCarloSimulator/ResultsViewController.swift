//
//  Created by Shyam Kotak on 10/25/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit
import Charts
import CoreGraphics

class ResultsViewController: UIViewController {
    
    @IBOutlet var barChartView: BarChartView!
    
    var userDict: [String : AnyObject] = [:]
    var results: [String : AnyObject] = [:]
    
    var sortedKeys: [String] = []
    var sortedValues: [Float] = []
    
    var max:Int = 0
    
    @IBOutlet var minValue: UILabel!
    @IBOutlet var maxValue: UILabel!
    @IBOutlet var percentReached: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        convertGraphValues((results["valueToPercent"] as? [String:AnyObject])!)
        setLabels()
        setChart(sortedKeys, values: sortedValues)

        // Do any additional setup after loading the view.
    }
    
    /// Handles large numbers (1.6E15) from the server
    /// - parameters:
    ///   - String: string to be converted
    func handleE(s: String) -> String {
        
        if(s.containsString("E")) {
            let nums = s.characters.split{$0 == "E"}.map(String.init)
            let total = Float(nums[0])! * pow(10, Float(nums[1])!)
            return String(total)
        } else {
            return s
        }
    }
    
    
    /// Sets the data to be used in the chart
    /// - parameters:
    ///   - [Float]: values to set as data
    /// - returns
    /// [BarChartDataEntry]: data to be graphed
    func setDataHelper(values: [Float]) -> [BarChartDataEntry] {
        var dataEntries : [BarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(value: Double(values[i]), xIndex: i)
            dataEntries.append(dataEntry)
        }
        return dataEntries
    }
    
    func setAxesHelper(bcView: BarChartView, percentFormatter: NSNumberFormatter) -> BarChartView {
        //change x axis
        bcView.xAxis.labelPosition = .Bottom
        bcView.xAxis.drawGridLinesEnabled = false
        bcView.xAxis.setLabelsToSkip(2)
        bcView.xAxis.labelTextColor = UIColor.blackColor()
        
        //change y axis
        bcView.rightAxis.enabled = false
        bcView.leftAxis.enabled = true
        bcView.leftAxis.valueFormatter = percentFormatter
        bcView.leftAxis.drawGridLinesEnabled = false
        bcView.rightAxis.labelTextColor = UIColor.blackColor()
        
        bcView.scaleXEnabled = false
        bcView.scaleYEnabled = false
        
        return bcView
    }
    
    func setBasicChartFeatures(bcView: BarChartView) -> BarChartView {
        bcView.gridBackgroundColor = UIColor.whiteColor()
        
        //set animation
        bcView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        //set description
        bcView.descriptionText = ""
        
        //change label color
        bcView.legend.enabled = false
        
        return bcView
    }
    
    /// Sets the chart of the results page
    /// - parameters:
    ///   - [String]: x axis data
    ///   - [Float]: y axis data
    func setChart(dataPoints: [String], values: [Float]) {
        
        //set data
        let dataEntries = setDataHelper(values)
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Percent Reached")
        chartDataSet.axisDependency = .Left;
        chartDataSet.valueTextColor = UIColor.whiteColor()
        //set colors
        chartDataSet.colors = ChartColorTemplates.joyful()
        
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView = setBasicChartFeatures(barChartView)
        
        let percentFormatter = NSNumberFormatter()
        percentFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        barChartView = setAxesHelper(barChartView, percentFormatter: percentFormatter)
    }
    
    /// the goal of this method is to populate sorted keys and sorted values to graph. The data is converted from the server to a cleaner format
    /// - parameters:
    ///   - [String: AnyObject]: JSON from the server
    func convertGraphValues(oldGraphValues: [String: AnyObject]) {
        
        print(oldGraphValues)
        
        var valuesDict: [Int: Float] = [:]
        
        // convert all values to ints
        for (key, value) in oldGraphValues {
            
            let updatedKey = handleE(key)
            
            valuesDict[Int(floor(Float(updatedKey)!))] = Float(value as! NSNumber)
        }

        // sort the values
        // and recalculate percentages
        
        let unsortedKeys = Array(valuesDict.keys)
        let sortedKeys = unsortedKeys.sort(<)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        var total = Float(1.0)
        for key in sortedKeys {
            
            // store percents for each dollar value
            let valuePercent = (total - valuesDict[key]!)
            total = valuesDict[key]!
            
            // keep max for the graph
            if(Int(ceil(valuePercent)) > max) {
                max = Int(ceil(valuePercent))
            }
            
            self.sortedValues.append(valuePercent)
            self.sortedKeys.append(formatter.stringFromNumber(key as NSNumber)!)
        }
        
    }
    
    /// Sets the labels for min/max/percent reached on the results page.
    func setLabels() {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        let minValue = formatter.stringFromNumber(results["minValue"] as! NSNumber)
        let maxValue = formatter.stringFromNumber(results["maxValue"] as! NSNumber)
        let percentReached = Int(results["percentGoalReached"]! as! Double * 100)
        
        self.minValue.text = "Min Value: " + minValue!
        self.maxValue.text = "Max Value: " + maxValue!
        self.percentReached.text = "Goal Reached: " + String(percentReached) + "% of simulations"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if(segue.identifier == "rerun") {
            let navVC = segue.destinationViewController as! UINavigationController
            let destinationVC = navVC.viewControllers.first as! LoadingViewController
            
            destinationVC.userDict = userDict
            destinationVC.navigationItem.setHidesBackButton(true, animated: false)
        } else if(segue.identifier == "restart") {
            let navVC = segue.destinationViewController as! UINavigationController
            let destinationVC = navVC.viewControllers.first as! IntroViewController
            destinationVC.navigationItem.setHidesBackButton(true, animated: false)
        }
        
    }
    
}
