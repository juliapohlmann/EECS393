//
//  StockAllocationTableViewController.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/22/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit
class StockAllocationTableViewController: UITableViewController {
    
    //ba
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var runSimulation: UIButton!
    @IBOutlet weak var unallocatedPercentageField: UITextField!
    
    var stockTickers = [String]()
    var stockPercentages = [Int]()
    var unallocatedPercentage : Int = 100
    
    var userDict: [String:AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStartingStockPercentages()
    }
    
    // SERVER FUNCTIONS
    
    /// prepares information to send to the server
    func getReadyToSendToServer() {
        
        var stockDict: [String: Int] = [:]
        
        for (index, element) in stockTickers.enumerate()
        {
            stockDict[element] = stockPercentages[index]
        }
        
        userDict["tickerToAllocation"] = stockDict
        
        print(userDict)
    }
    
    //SETUP FUNCTIONS
    
    /// sets stockTickers to passed in array
    /// - parameters:
    ///   - [String]: array of stock tickers
    func loadStocks(tickers: [String]) {
        stockTickers = tickers
    }
    
    /// allocates a portion of the 100% to each stock
    func setStartingStockPercentages() {
        let startingValue = Int(floor(100.0 / Double(stockTickers.count)))
        for _ in stockTickers {
            stockPercentages += [startingValue]
            unallocatedPercentage -= startingValue
        }
        updateUnallocatedPercentageField()
    }
    
    //BUTTON FUNCTIONS
    
    /// IBAction when run simulation button is clicked
    /// - parameters:
    ///   - AnyObject: button object that was clicked
    @IBAction func runSimulation(sender: AnyObject) {
        if(isInputValid()) {
            performSegueWithIdentifier("stockAllocationNext", sender: sender)
            //run the simulation by passing JSON object to server
            //will be implemented for second demo
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        getReadyToSendToServer()
        
        let navVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navVC.viewControllers.first as! LoadingViewController
        
        destinationVC.userDict = userDict
        
    }
    
    /// IBAction when back button is clicked
    /// - parameters:
    ///   - AnyObject: button object that was clicked
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
        cell.setFieldTexts(stockTickers[indexPath.row], percentageText: String(stockPercentages[indexPath.row]))
        cell.StockAllocationInstance = self
        
        return cell
    }
    
    //VALIDITY FUNTIONS
    
    /// will be abstracted into common class next iteration cycle
    /// - parameters:
    ///   - String: message to be displayed
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /// checks whether the proposed newValue is a valid edit to the allocated percentage
    /// - parameters:
    ///   - String: ticker of proposed change
    ///   - Int: previous percentage value
    ///   - Int: proposed percentage value
    /// - returns: true if valid, false if not
    func validEdit(ticker: String, oldValue: Int, newValue: Int) -> Bool{
        let index = stockTickers.indexOf(ticker)
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
            stockPercentages[index!] = newValue
            updateUnallocatedPercentageField()
        } else {
            stockPercentages[index!] = oldValue
        }
        
        return isValid
    }
    
    /// checks that all percentages are allocated
    /// - parameters:
    ///   - String: message to be displayed
    /// - returns: true if valid, false if not
    func isInputValid() -> Bool {
        if(unallocatedPercentage == 0) {
            return true;
        } else {
            displayError("You must allocate all 100% percent")
            return false;
        }
        
    }
    
    /// updates the unallocatedPercentageField to the value of the unallocatedPercentage field
    func updateUnallocatedPercentageField() {
        unallocatedPercentageField.text = String(unallocatedPercentage)
    }
    
    /// checks if it is valid to decrement a stock percentage
    /// - parameters:
    ///   - Int: percentage values to check
    /// - returns: true if valid to decrement, false if not
    func canDecrementStock(percentage: Int) -> Bool {
        if(percentage > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    /// checks if it is valid to increment a stock percentage
    /// - parameters:
    ///   - Int: percentage values to check
    /// - returns: true if valid to increment, false if not
    func canIncrementStock() -> Bool {
        if(unallocatedPercentage > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    //UNALLOCATED PERCENTAGE FUNCTIONS
    
    /// decrements the unallocated percentage by 1
    func decrementUnallocatedPercentage() {
        unallocatedPercentage -= 1
        updateUnallocatedPercentageField()
    }
    
    /// increments the unallocated percentage by 1
    func incrementUnallocatedPercentage() {
        unallocatedPercentage += 1
        updateUnallocatedPercentageField()
    }
    
    //STOCK PERCENTAGE FUNCTIONS
    
    /// increments the percentage allocated to the given ticker by 1
    /// - parameters:
    ///   - String: Ticker to increment
    /// - returns: true if valid to increment, false if not
    func incrementStockPercentage(ticker: String) -> Bool {
        if(canIncrementStock()) {
            let index = stockTickers.indexOf(ticker)
            stockPercentages[index!] += 1
            decrementUnallocatedPercentage()
            return true
        } else {
            return false
        }
    }
    
    /// decrements the percentage allocated to the given ticker by 1
    /// - parameters:
    ///   - String: Ticker to increment
    /// - returns: true if valid to decrement, false if not
    func decrementStockPercentage(ticker: String) -> Bool {
        let index = stockTickers.indexOf(ticker)
        
        if(canDecrementStock(stockPercentages[index!])) {
            stockPercentages[index!] -= 1
            incrementUnallocatedPercentage()
            return true
        } else {
            return false
        }
    }
}

