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
    
    var stocks = [String]()
    var startingValue : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleStocks()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSampleStocks() {
        stocks += ["AAPL", "ABCD", "EFGH"]
        startingValue = (100 / (stocks.count + (stocks.count / 2)))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StockAllocationTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StockAllocationTableViewCell
        
        cell.tickerField.text = stocks[indexPath.row]
        cell.percentageField.text = String(startingValue)
        
        // Configure the cell...
        
        
        return cell
    }
    
    
    @IBAction func runSimulation(sender: AnyObject) {
        if(isInputValid()) {
            performSegueWithIdentifier("stockAllocationNext", sender: sender)
        }
    }
    
    @IBAction func backClick(sender: AnyObject) {
        performSegueWithIdentifier("stockAllocationBack", sender: sender)
    }
    
    func isInputValid() -> Bool {
        return true;
    }
    
}

