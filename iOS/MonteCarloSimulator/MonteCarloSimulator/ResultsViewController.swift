//
//  ResultsViewController.swift
//  MonteCarloSimulator
//
//  Created by Shyam Kotak on 10/25/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit
import SwiftCharts

class ResultsViewController: UIViewController {

    var chart: Chart?
    
    var userDict: [String : AnyObject] = [:]
    var results: [String : AnyObject] = [:]

    @IBOutlet var minValue: UILabel!
    @IBOutlet var maxValue: UILabel!
    @IBOutlet var percentReached: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        setLabels()
        
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: 8, by: 2)
        )
        
        let chart = BarsChart(
            frame: CGRectMake(0, 70, 300, 500),
            chartConfig: chartConfig,
            xTitle: "X axis",
            yTitle: "Y axis",
            bars: [
                ("A", 2),
                ("B", 4.5),
                ("C", 3),
                ("D", 5.4),
                ("E", 6.8),
                ("F", 0.5)
            ],
            color: UIColor.redColor(),
            barWidth: 20
        )
        
        self.view.addSubview(chart.view)
        self.chart = chart
        
        // Do any additional setup after loading the view.
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
