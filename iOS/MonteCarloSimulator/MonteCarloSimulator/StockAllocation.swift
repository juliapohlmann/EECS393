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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func runSimulation(sender: AnyObject) {
        performSegueWithIdentifier("stockAllocationNext", sender: sender)
    }
    
    @IBAction func backClick(sender: AnyObject) {
        performSegueWithIdentifier("stockAllocationBack", sender: sender)
    }
}

