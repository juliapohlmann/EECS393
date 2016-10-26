//
//  StockAllocationTableViewCell.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/25/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class StockAllocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tickerField: UITextField!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var percentageField: UITextField!
    var previousPercentage : Int = 0
    var StockAllocationInstance : StockAllocationViewController = StockAllocationViewController()
    
    
    @IBAction func beginEditingPercentageField(sender: AnyObject) {
        previousPercentage = Int(percentageField.text!)!
        print("Previous percentage: \(previousPercentage)")
    }
    
    @IBAction func editPercentageField(sender: AnyObject) {
        print("New percentage: \(percentageField.text!)")
        print("OLD PERCENTAGE: \(String(previousPercentage))")
        let newValue = Int(percentageField.text!)!
        StockAllocationInstance.isValidChange(tickerField.text!, oldValue: previousPercentage, newValue: newValue)
        
    }
    
    
    
    
    @IBAction func minusClick(sender: AnyObject) {
        if(StockAllocationInstance.decrementStockPercentage(tickerField.text!)) {
            let currentPercentage = Int(percentageField.text!)
            percentageField.text = String(currentPercentage! - 1)
        }
    }
    
    @IBAction func plusClick(sender: AnyObject) {
        if(StockAllocationInstance.incrementStockPercentage(tickerField.text!)) {
            let currentPercentage = Int(percentageField.text!)
            percentageField.text = String(currentPercentage! + 1)
        }
    }
}