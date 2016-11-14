//
//  StockSelectionTableViewController.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/26/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit
import StocksKit

class StockSelectionTableViewController: UITableViewController, UISearchBarDelegate {
    
    /// search bar to be displayed on screen
    @IBOutlet weak var searchBar: UISearchBar!
    /// back button to be displayed on nav bar
    @IBOutlet weak var backButton: UIBarButtonItem!
    /// next button to be displayed at bottom of the screen
    @IBOutlet weak var nextButton: UIButton!
    
    /// stores user information
    var userDict: [String:Int] = [:]
    /// stores tickers of stocks
    var stockTickers = [String]()
    /// stores values of stocks
    var stockValues = [NSDecimalNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    /// Moves to IntroView screen
    /// - parameters:
    ///   - sender: current view controller
    @IBAction func backClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    /// Moves to StockSelection screen
    /// - parameters:
    ///   - sender: current view controller
    @IBAction func nextClick(sender: AnyObject) {
        if(isInputValid()) {
            performSegueWithIdentifier("stockSelectionNext", sender: sender)
        }
    }
    
    //TABLE VIEW FUNCTIONS
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockTickers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StockSelectionTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StockSelectionTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let stockInfoText = stockTickers[indexPath.row] + " (" + String(stockValues[indexPath.row]) + ")"
        cell.StockInfo.text = stockInfoText
        cell.StockSelectionInstance = self
        cell.ticker = stockTickers[indexPath.row]
        cell.StockInfo.enabled = false
        
        return cell
    }
    
    /// From SearchBar delegate, check if search button has been clicked
    /// - parameters:
    ///   - UISearchBar: current search bar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let ticker : String = searchBar.text!.uppercaseString
        self.view.userInteractionEnabled = false
        
        // the code below is making use of the StocksKit Cocoapod
        // we pass in the ticker value and it returns a result with 
        // either success or failure, and we use the successful return
        // to get the lastTradePrice, which is the most recent price the
        // stock has been trading at
        Quote.fetch([ticker]) { result in
            
            switch result {
            
            case .Success(let quotes):
                self.view.userInteractionEnabled = true
                searchBar.text = ""
                if(self.stockTickers.contains(ticker)) {
                    self.displayError("This stock is already added")
                } else {
                    self.stockTickers += [ticker]
                    self.stockValues += [quotes[0].lastTradePrice]
                    self.tableView.reloadData()
                }
                break
            case .Failure(_):
                self.view.userInteractionEnabled = true
                self.displayError("Not a valid stock ticker")
                break
            }
            
            }.resume()
    }

    /// removes ticker if user clicks "Remove" button
    /// - parameters:
    ///   - String: ticker to remove!
    func removeTicker(ticker: String) {
        let index = stockTickers.indexOf((ticker))
        stockTickers.removeAtIndex(index!)
        stockValues.removeAtIndex(index!)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let navVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navVC.viewControllers.first as! StockAllocationTableViewController
        
        destinationVC.userDict = userDict
        destinationVC.loadStocks(stockTickers)
    }
    
    /// checks if between 15 and 100 stocks have been added
    /// - return:
    /// Bool indicating whether the input is valid
    func isInputValid() -> Bool {
        if(stockTickers.count >= 15 && stockTickers.count <= 100) {
            return true;
        } else {
            displayError("You must select between 15 and 100 stocks")
            return false;
        }
    }
    
    /// Displays an error - will be made a class later
    /// - parameters:
    ///   - String: message to be displayed
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
