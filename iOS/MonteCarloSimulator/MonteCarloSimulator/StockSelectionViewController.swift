//
//  StockSelectionViewController.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/22/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class StockSelectionViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    
    var userDict: [String:Int] = [:]
    var stockTickers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func nextClick(sender: AnyObject) {
        //if(isInputValid()) {
            performSegueWithIdentifier("stockSelectionNext", sender: sender)
        //} else {
//            let alert = UIAlertController(title: "Error", message: "You must select between 15 and 100 stocks", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
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
    
//    func getQuoteForAPPL() {
//        Quote.fetch(["AAPL"]) { result in
//            
//            switch result {
//            case .Success(let quotes):
//                print(quotes[0].lastTradePrice)
//                // do something with the quotes
//                break
//            case .Failure(let error):
//                // handle the error
//                print("ERROR")
//                break
//            }
//            
//            }.resume()
//
//    }
}

