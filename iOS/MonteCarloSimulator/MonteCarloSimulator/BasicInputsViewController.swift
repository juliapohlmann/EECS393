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
    
    var userDict: [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func nextClick(sender: AnyObject) {
        if(isInputValid(getInputValues())) {
            userDict["duration"] = Int(durationInput.text!)
            userDict["initialValue"] = Int(initialValueInput.text!)
            userDict["goalValue"] = Int(goalValueInput.text!)
            performSegueWithIdentifier("basicInputsNext", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let navVC = segue.destinationViewController as! UINavigationController
        
        let destinationVC = navVC.viewControllers.first as! StockSelectionTableViewController
        
        destinationVC.userDict = userDict
        
    }
    
    func getInputValues() -> (Int?, Int?, Int?) {
        let duration : Int? = Int(durationInput.text!)
        let initialValue : Int? = Int(initialValueInput.text!)
        let goalValue : Int? = Int(goalValueInput.text!)
        return (duration, initialValue, goalValue)
    }
    
    func isInputValid(values: (Int?, Int?, Int?)) -> Bool {
        let (duration, initialValue, goalValue) = values
        
        if(duration == nil || duration <= 1 || duration >= 100) {
            displayError("Duration must be a number greater than one year and less than 100 years.")
            return false
            
        }else if(initialValue == nil || initialValue < 1) {
            displayError("The initial portfolio value must be a number greater than $1")
            return false
            
        }else if(goalValue == nil || goalValue < initialValue) {
            displayError("The goal portfolio value must be a number greater than the initial portfolio value")
            return false
            
        }
        
        return true;
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: "test", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        alert.message = message;
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}


