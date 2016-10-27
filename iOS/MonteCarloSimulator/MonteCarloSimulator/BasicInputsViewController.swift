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
        print(userDict)
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
        if(isInputValid()) {
            userDict["duration"] = Int(durationInput.text!)
            userDict["initialValue"] = Int(initialValueInput.text!)
            userDict["goalValue"] = Int(goalValueInput.text!)
            performSegueWithIdentifier("basicInputsNext", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let navVC = segue.destinationViewController as! UINavigationController
            
        let destinationVC = navVC.viewControllers.first as! StockSelectionViewController
            
        destinationVC.userDict = userDict
        
    }

    func isInputValid() -> Bool {
        let duration : Int? = Int(durationInput.text!)
        let initialValue : Int? = Int(initialValueInput.text!)
        let goalValue : Int? = Int(goalValueInput.text!)
        
        
        
        let alert = UIAlertController(title: "Error", message: "test", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        
        if(duration == nil || duration <= 1 || duration >= 100) {
            
            alert.message = "Duration must be a number greater than one year and less than 100 years.";
            self.presentViewController(alert, animated: true, completion: nil)
            return false;
            
        }else if(initialValue == nil || initialValue < 1) {
            
            alert.message = "The initial portfolio value must be a number greater than $1"
            self.presentViewController(alert, animated: true, completion: nil)
            return false;
            
        }else if(goalValue == nil || goalValue < initialValue) {
            
            alert.message = "The goal portfolio value must be a number greater than the initial portfolio value";
            self.presentViewController(alert, animated: true, completion: nil)
            return false;
            
        }
        
        return true;
    }
    
    func showError(message: String) {
        //replace with error pop up
        print(message)
    }

}


