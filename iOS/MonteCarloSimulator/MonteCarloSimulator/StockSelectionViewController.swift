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
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: AnyObject) {
        performSegueWithIdentifier("stockSelectionBack", sender: sender)
    }
    
    @IBAction func nextClick(sender: AnyObject) {
        performSegueWithIdentifier("stockSelectionNext", sender: sender)
    }
}

