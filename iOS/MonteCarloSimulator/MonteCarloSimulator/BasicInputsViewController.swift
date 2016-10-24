//
//  BasicInputsViewController.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/22/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class BasicInputsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var durationInput: UITextField!
    @IBOutlet weak var initialValueInput: UITextField!
    @IBOutlet weak var goalValueInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: AnyObject) {
        performSegueWithIdentifier("basicInputsBack", sender: sender)
    }
    
    
    @IBAction func nextClick(sender: AnyObject) {
        if(isInputValid()) {
            performSegueWithIdentifier("basicInputsNext", sender: sender)
        }
    }
    
    func isInputValid() -> Bool {
        let duration : Int? = Int(durationInput.text!)
        let initialValue : Int? = Int(initialValueInput.text!)
        let goalValue : Int? = Int(goalValueInput.text!)
        
        if(duration == nil || duration <= 1 || duration >= 100) {
            showError("Duration must be a number greater than one year and less than 100 years.");
            return false;
        }
        
        if(initialValue == nil || initialValue < 1) {
            showError("The initial portfolio value must be a number greater than $1");
            return false;
        }
        
        if(goalValue == nil || goalValue < initialValue) {
            showError("The goal portfolio value must be a number greater than the initial portfolio value");
            return false;
        }
        
        return true;
    }
    
    func showError(message: String) {
        //replace with error pop up
        print(message)
    }
    
    
}

