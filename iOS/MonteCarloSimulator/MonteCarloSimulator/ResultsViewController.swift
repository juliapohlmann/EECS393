//
//  Created by Shyam Kotak on 10/25/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit
import SwiftCharts
import Charts

class ResultsViewController: UIViewController {
    
    @IBOutlet var chartView: UIView!
    
    var chart: Chart?
    
    var userDict: [String : AnyObject] = [:]
    var results: [String : AnyObject] = [:]
    
    var graphValues: [Int: Float] = [:]
    var sortedKeys: [Int] = []
    
    var max:Int = 0
    
    @IBOutlet var minValue: UILabel!
    @IBOutlet var maxValue: UILabel!
    @IBOutlet var percentReached: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        print(results["valueToPercent"] as? [String:AnyObject])
        
        self.graphValues = convertGraphValues((results["valueToPercent"] as? [String:AnyObject])!)
        
        setLabels()
                
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: Double(max), by: Double(max)/4)
        )
        
        let chart = BarsChart(
            frame: CGRectMake(5, 5, 400, 400),
            chartConfig: chartConfig,
            xTitle: "$",
            yTitle: "Percent Reached",
            bars: [
                (String(sortedKeys[0]), Double(graphValues[sortedKeys[0]]!)),
                (String(sortedKeys[1]), Double(graphValues[sortedKeys[1]]!)),
                (String(sortedKeys[2]), Double(graphValues[sortedKeys[2]]!)),
                (String(sortedKeys[3]), Double(graphValues[sortedKeys[3]]!)),
                (String(sortedKeys[4]), Double(graphValues[sortedKeys[4]]!))
            ],
            color: UIColor.redColor(),
            barWidth: 30
        )
        
        self.chartView.addSubview(chart.view)
        self.chart = chart
        
        // Do any additional setup after loading the view.
    }
    
    func convertGraphValues(oldGraphValues: [String: AnyObject]) -> [Int: Float] {
        
        var valuesDict: [Int: Float] = [:]
        
        // convert all values to ints
        for (key, value) in oldGraphValues {
            
            valuesDict[Int(floor(Float(key)!))] = Float(value as! NSNumber)
            
        }
        
        print("convert")
        print(valuesDict)
        
        // sort the values
        // and recalculate percentages
        var valuesDictPercent: [Int: Float] = [:]
        
        let unsortedKeys = Array(valuesDict.keys)
        sortedKeys = unsortedKeys.sort(<)
        
        var total = Float(1.0)
        for key in sortedKeys {
            
            // multiply by 100 to get it into percentage form
            valuesDictPercent[key] = (total - valuesDict[key]!) * 100
            total = valuesDict[key]!
            
            // keep max for the graph
            if(Int(ceil(valuesDictPercent[key]!)) > max) {
                max = Int(ceil(valuesDictPercent[key]!))
            }
            
        }
        
        print(max)
        print("percentages")
        print(valuesDictPercent)
        
        return valuesDictPercent
        
    }
    
    func setLabels() {
        
        let minValue = "\(results["minValue"]!)"
        let maxValue = "\(results["maxValue"]!)"
        let percentReached = String(Int(results["percentGoalReached"]! as! NSNumber) * 100)
        
        self.minValue.text = "Min Value: " + minValue
        self.maxValue.text = "Max Value: " + maxValue
        self.percentReached.text = "Percent Goal Reached: " + percentReached
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if(segue.identifier == "rerun") {
            let navVC = segue.destinationViewController as! UINavigationController
            let destinationVC = navVC.viewControllers.first as! LoadingViewController
            
            destinationVC.userDict = userDict
            destinationVC.navigationItem.setHidesBackButton(true, animated: false)
        }else if(segue.identifier == "restart") {
            let navVC = segue.destinationViewController as! UINavigationController
            let destinationVC = navVC.viewControllers.first as! IntroViewController
            destinationVC.navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
