//
//  StockSelectionTableViewCell.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/26/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class StockSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var StockInfo: UITextField!
    @IBOutlet weak var removeButton: UIButton!
    
    var StockSelectionInstance : StockSelectionTableViewController = StockSelectionTableViewController()
    var ticker : String = ""

    @IBAction func removeClick(sender: AnyObject) {
        StockSelectionInstance.removeTicker(ticker)
    }
    
    
    
}