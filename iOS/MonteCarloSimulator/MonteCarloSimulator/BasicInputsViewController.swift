//
//  BasicInputsViewController.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/22/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class BasicInputsViewController: UIViewController {
    
    /// back button on nav bar to go to intro view controller
    @IBOutlet weak var backButton: UIBarButtonItem!
    /// next button to go to stock selection screen
    @IBOutlet weak var nextButton: UIButton!
    
    /// text field to put duration of years
    @IBOutlet weak var durationInput: UITextField!
    /// text field for initial value of investment ($)
    @IBOutlet weak var initialValueInput: UITextField!
    /// text field for goal value of investment ($)
    @IBOutlet weak var goalValueInput: UITextField!
    
    /// stores user information
    var userDict: [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /// Moves to IntroView screen
    /// - parameters:
    ///   - sender: current view controller
    @IBAction func backClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    /// Moves to StockSelection screen
    /// - parameters:
    ///   - sender: current view controller
    @IBAction func nextClick(sender: AnyObject) {
        if(isInputValid(getInputValues())) {
            userDict["duration"] = Int(durationInput.text!)
            userDict["initialValue"] = Int(initialValueInput.text!)
            userDict["goalValue"] = Int(goalValueInput.text!)
            performSegueWithIdentifier("basicInputsNext", sender: sender)
        }
    }
    
    /// Preprocessing before moving to next view
    /// - parameters:
    ///   - segue: segue using to move to view controller
    ///   - sender: current view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let navVC = segue.destinationViewController as! UINavigationController
        
        let destinationVC = navVC.viewControllers.first as! StockSelectionTableViewController
        
        destinationVC.userDict = userDict
        
    }
    
    /// Get values from user input fields
    /// - returns
    /// a tuple of integers with the duration, initial value, goal value (in that order)
    func getInputValues() -> (Int?, Int?, Int?) {
        let duration : Int? = Int(durationInput.text!)
        let initialValue : Int? = Int(initialValueInput.text!)
        let goalValue : Int? = Int(goalValueInput.text!)
        return (duration, initialValue, goalValue)
    }
    
    /// Returns whether input is valid
    /// - parameters:
    ///   - tuple: of ints with duration, initial value, goal value (in that order)
    /// - returns
    /// Bool: whether input is valid
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
    
    /// Displays an error - will be made a class later
    /// - parameters:
    ///   - String: message to be displayed
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: "test", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        alert.message = message;
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}


