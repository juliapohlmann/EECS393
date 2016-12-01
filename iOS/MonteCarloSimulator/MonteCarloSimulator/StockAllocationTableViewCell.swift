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
    @IBOutlet weak var percentageField: UILabel!
    
    var previousPercentage : Int = 0
    var StockAllocationInstance : StockAllocationTableViewController = StockAllocationTableViewController()
    
    func setPercentageFieldText(newValue: String) {
        let str = newValue + "%"
        percentageField.text = str
    }
    
    func getPercentageFieldValue() -> Int {
        let value = percentageField.text!
        return Int(String(value.characters.dropLast()))!
    }
    
    func setFieldTexts(tickerText: String, percentageText: String) {
        tickerField.text = tickerText
        setPercentageFieldText(percentageText)
    }
    
//    @IBAction func beginEditingPercentageField(sender: AnyObject) {
//        previousPercentage = getPercentageFieldValue()
//    }
//    
//    @IBAction func editPercentageField(sender: AnyObject) {
//        let newValue = getPercentageFieldValue()
//        if(!StockAllocationInstance.validEdit(tickerField.text!, oldValue: previousPercentage, newValue: newValue)) {
//            setPercentageFieldText(String(previousPercentage))
//        }
//    }
    
    @IBAction func minusClick(sender: AnyObject) {
        if(StockAllocationInstance.decrementStockPercentage(tickerField.text!)) {
            let currentPercentage = getPercentageFieldValue()
            setPercentageFieldText(String(currentPercentage - 1))
        }
    }
    
    @IBAction func plusClick(sender: AnyObject) {
        if(StockAllocationInstance.incrementStockPercentage(tickerField.text!)) {
            let currentPercentage = getPercentageFieldValue()
            setPercentageFieldText(String(currentPercentage + 1))
        }
    }
}
