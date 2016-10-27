//
//  StockAllocationViewController.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/22/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class StockAllocationViewController: UITableViewController {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var runSimulation: UIButton!
    @IBOutlet weak var unallocatedPercentageField: UITextField!
    
    var stockTickers = [String]()
    var stockPercentages = [Int]()
    var unallocatedPercentage : Int = 100
    
    var userDict: [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleStocks()
        print(userDict)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSampleStocks() {
        stockTickers += ["AAPL", "ABCD", "EFGH"]
        let startingValue = (100 / (stockTickers.count + (stockTickers.count / 2)))
        stockPercentages += [startingValue, startingValue, startingValue]
        
        for percentage in stockPercentages {
            unallocatedPercentage -= percentage
        }
        updateUnallocatedPercentage()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockTickers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StockAllocationTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StockAllocationTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.tickerField.text = stockTickers[indexPath.row]
        cell.percentageField.text = String(stockPercentages[indexPath.row])
        cell.StockAllocationInstance = self
        
        return cell
    }
    
    
    @IBAction func runSimulation(sender: AnyObject) {
        if(isInputValid()) {
            performSegueWithIdentifier("stockAllocationNext", sender: sender)
        }
    }
    
    @IBAction func backClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func isInputValid() -> Bool {
        if(unallocatedPercentage == 0) {
            return true;
        } else {
            let alert = UIAlertController(title: "Error", message: "You must allocate all 100% percent", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false;
        }
        
    }
    
    func decrementUnallocatedPercentage() {
        unallocatedPercentage -= 1
        updateUnallocatedPercentage()
    }
    
    func incrementUnallocatedPercentage() {
        unallocatedPercentage += 1
        updateUnallocatedPercentage()
    }
    
    func incrementStockPercentage(ticker: String) -> Bool {
        if(canIncrementStock()) {
            let index = findIndexOfTicker(ticker)
        
            stockPercentages[index] += 1
            decrementUnallocatedPercentage()
            return true
        } else {
            return false
        }
    }
    
    func decrementStockPercentage(ticker: String) -> Bool {
        let index = findIndexOfTicker(ticker)
        
        if(canDecrementStock(stockPercentages[index])) {
            stockPercentages[index] -= 1
            incrementUnallocatedPercentage()
            return true
        } else {
            return false
        }
    }
    
    func canDecrementStock(percentage: Int) -> Bool {
        if(percentage > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    func canIncrementStock() -> Bool {
        if(unallocatedPercentage > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    func findIndexOfTicker(ticker: String) -> Int {
        for i in 0..<stockTickers.count {
            if(ticker == stockTickers[i]) {
                return i
            }
        }
        return -1
    }
    
    func updateUnallocatedPercentage() {
        unallocatedPercentageField.text = String(unallocatedPercentage)
    }
    
    func validEdit(ticker: String, oldValue: Int, newValue: Int) -> Bool{
        let index = findIndexOfTicker(ticker)
        var isValid = true
        
        if(newValue <= 0 || newValue > 100) {
            isValid = false
        } else if((newValue - oldValue) > unallocatedPercentage) {
            isValid = false
        } else{
            unallocatedPercentage += oldValue - newValue
        }
        
        if(isValid) {
            stockPercentages[index] = newValue
            updateUnallocatedPercentage()
        } else {
            stockPercentages[index] = oldValue
            let alert = UIAlertController(title: "Error", message: "You cannot allocate more than 100% percent", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        return isValid
    }
    
}

