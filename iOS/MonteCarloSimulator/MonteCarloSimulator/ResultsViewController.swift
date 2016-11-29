//
//  Created by Shyam Kotak on 10/25/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit
import Charts

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
        
        print(userDict)
        print(results)
        print(results["valueToPercent"] as? [String:AnyObject])
        
        convertGraphValues((results["valueToPercent"] as? [String:AnyObject])!)
        setLabels()
        setChart(sortedKeys, values: sortedValues)

        // Do any additional setup after loading the view.
    }
    
    func setChart(dataPoints: [String], values: [Float]) {
        
        //set data
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(value: Double(values[i]), xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Percent Reached")
        chartDataSet.axisDependency = .Left;
        chartDataSet.valueTextColor = UIColor.whiteColor()
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        
        //set colors
        chartDataSet.colors = ChartColorTemplates.joyful()
        self.barChartView.gridBackgroundColor = UIColor.whiteColor()
        
        //set animation
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        //set description
        barChartView.descriptionText = ""
        
        //set target
        let ll = ChartLimitLine(limit: (userDict["goalMoney"] as? Double)!, label: "Goal Value")
        barChartView.xAxis.addLimitLine(ll)
        
        //change x axis
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.setLabelsToSkip(2)
        barChartView.xAxis.labelTextColor = UIColor.blackColor()
        
        //change y axis
        barChartView.rightAxis.enabled = false;
        barChartView.leftAxis.enabled = true;
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.labelTextColor = UIColor.blackColor()
        
        //change label color
        barChartView.legend.textColor = UIColor.blackColor()
        
        barChartView.scaleXEnabled = false;
        barChartView.scaleYEnabled = false;
    }
    
    // the goal of this method is to populate
    // sorted keys and sorted values to graph
    func convertGraphValues(oldGraphValues: [String: AnyObject]) {
        
        var valuesDict: [Int: Float] = [:]
        
        // convert all values to ints
        for (key, value) in oldGraphValues {
            
            //if value.rangeOfString("E") != nil {
                
            //}
            valuesDict[Int(floor(Float(key)!))] = Float(value as! NSNumber)
            
        }
        
        print("convert")
        print(valuesDict)
        
        // sort the values
        // and recalculate percentages
        
        let unsortedKeys = Array(valuesDict.keys)
        let sortedKeys = unsortedKeys.sort(<)
        
        var total = Float(1.0)
        for key in sortedKeys {
            
            // multiply by 100 to get it into percentage form
            let valuePercent = (total - valuesDict[key]!) * 100
            total = valuesDict[key]!
            
            // keep max for the graph
            if(Int(ceil(valuePercent)) > max) {
                max = Int(ceil(valuePercent))
            }
            
            self.sortedValues.append(valuePercent)
            self.sortedKeys.append("$" + String(key))
        }
        
        print(sortedKeys)
        print(sortedValues)
        
    }
    
    func setLabels() {
        
        let minValue = results["minValue"] as? Int
        let maxValue = results["maxValue"] as? Int
        let percentReached = String(Int(results["percentGoalReached"]! as! NSNumber) * 100)
        
        self.minValue.text = "Min Value: $" + String(minValue!)
        self.maxValue.text = "Max Value: $" + String(maxValue!)
        self.percentReached.text = "Percent Goal Reached: " + percentReached + "%"
        
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
