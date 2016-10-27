//
//  StockSelectionViewController.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/22/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit
import StocksKit

class StockSelectionViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userDict: [String:Int] = [:]
    var stockTickers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let ticker : String = searchBar.text!.uppercaseString
        self.view.userInteractionEnabled = false
        Quote.fetch([ticker]) { result in
            
            switch result {
        
                case .Success(_):
                    self.view.userInteractionEnabled = true
                    searchBar.text = ""
                    print(searchBar.text)
                    if(self.stockTickers.contains(ticker)) {
                        self.displayError("This stock is already added")
                    } else {
                        self.stockTickers.append(ticker)
                    }
                    break
                case .Failure(_):
                    self.view.userInteractionEnabled = true
                    self.displayError("Not a valid stock ticker")
                    break
            }
            
        }.resume()
        
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

