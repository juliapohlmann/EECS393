//
//  StockAllocationTableViewController.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/22/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class StockAllocationTableViewController: UITableViewController {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var runSimulation: UIButton!
    @IBOutlet weak var unallocatedPercentageField: UITextField!
    
    var stockTickers = [String]()
    var stockPercentages = [Int]()
    var unallocatedPercentage : Int = 100
    
    var userDict: [String:Int] = [:]
    var combinedDict: [String : Dictionary<String, AnyObject>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //change to just setStartingStockPercentages after stock selection works
        setStartingStockPercentages()
    }
    
    // SERVER FUNCTIONS
    func getReadyToSendToServer() {
        
        var stockDict: [String: Int] = [:]
        
        for (index, element) in stockTickers.enumerate()
        {
            stockDict[element] = stockPercentages[index]
        }
        
        combinedDict["userData"] = userDict
        combinedDict["stockData"] = stockDict
        
    }
    
//    //SETUP FUNCTIONS
//    func loadStocks() {
//        stockTickers += ["AAPL", "ABCD", "EFGH", "IJKL"]
//        setStartingStockPercentages()
//    }
    
    func setStartingStockPercentages() {
        let startingValue = (100 / (stockTickers.count + (stockTickers.count / 2)))
        for _ in stockTickers {
            stockPercentages += [startingValue]
            unallocatedPercentage -= startingValue
        }
        updateUnallocatedPercentageField()
    }
    
    //BUTTON FUNCTIONS
    @IBAction func runSimulation(sender: AnyObject) {
        if(isInputValid()) {
            performSegueWithIdentifier("stockAllocationNext", sender: sender)
        }
    }
    
    @IBAction func backClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //TABLE VIEW FUNCTIONS
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
    
    //VALIDITY FUNTIONS
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func validEdit(ticker: String, oldValue: Int, newValue: Int) -> Bool{
        let index = findIndexOfTicker(ticker)
        var isValid = true
        
        if(newValue <= 0 || newValue >= 100) {
            isValid = false
            displayError("Allocation for a stock must be between 0 and 100 percent")
        } else if((newValue - oldValue) > unallocatedPercentage) {
            isValid = false
            displayError("You cannot allocate more than 100% percent")
        } else{
            unallocatedPercentage += oldValue - newValue
        }
        
        if(isValid) {
            stockPercentages[index] = newValue
            updateUnallocatedPercentageField()
        } else {
            stockPercentages[index] = oldValue
        }
        
        return isValid
    }
    
    func isInputValid() -> Bool {
        if(unallocatedPercentage == 0) {
            return true;
        } else {
            displayError("You must allocate all 100% percent")
            return false;
        }
        
    }
    
    func updateUnallocatedPercentageField() {
        unallocatedPercentageField.text = String(unallocatedPercentage)
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
    
    //UNALLOCATED PERCENTAGE FUNCTIONS
    
    func decrementUnallocatedPercentage() {
        unallocatedPercentage -= 1
        updateUnallocatedPercentageField()
    }
    
    func incrementUnallocatedPercentage() {
        unallocatedPercentage += 1
        updateUnallocatedPercentageField()
    }
    
    //STOCK PERCENTAGE FUNCTIONS
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
    
    func findIndexOfTicker(ticker: String) -> Int {
        for i in 0..<stockTickers.count {
            if(ticker == stockTickers[i]) {
                return i
            }
        }
        return -1
    }
    
}

