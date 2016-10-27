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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    
    var userDict: [String:Int] = [:]
    var stockTickers = [String]()
    var stockValues = [NSDecimalNumber]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func backClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func nextClick(sender: AnyObject) {
        //if(isInputValid()) {
        performSegueWithIdentifier("stockSelectionNext", sender: sender)
        //} else {
//            displayError("You must select between 15 and 100 stocks")
//        }
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
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let ticker : String = searchBar.text!.uppercaseString
        self.view.userInteractionEnabled = false
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
    
    func findIndexOfTicker(ticker: String) -> Int {
        for i in 0..<stockTickers.count {
            if(ticker == stockTickers[i]) {
                return i
            }
        }
        return -1
    }
    
    func removeTicker(ticker: String) {
        let index = findIndexOfTicker(ticker)
        stockTickers.removeAtIndex(index)
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let navVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navVC.viewControllers.first as! StockAllocationViewController
        
        destinationVC.userDict = userDict
        destinationVC.stockTickers = stockTickers
    }
    
    func isInputValid() -> Bool {
        if(stockTickers.count > 15 && stockTickers.count < 100) {
            return true;
        } else {
            return false;
        }
        
    }
    
    
}
