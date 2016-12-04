//
//  LoadingViewController.swift
//  MonteCarloSimulator
//
//  Created by Shyam Kotak on 11/14/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit
import Gifu

class LoadingViewController: UIViewController {

    var userDict: [String : AnyObject] = [:]
    var results: [String : AnyObject] = [:]
    
    @IBOutlet weak var gifView: AnimatableImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitAction()
        gifView.animateWithImage(named: "money.gif")

        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let navVC = segue.destinationViewController as! UINavigationController
        let destinationVC = navVC.viewControllers.first as! ResultsViewController
        
        destinationVC.userDict = userDict
        destinationVC.results = results
    }
    
    func submitAction() {
        
        do {
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(userDict, options: .PrettyPrinted)
            
            // create post request
            let url = NSURL(string: "http://acm-people.case.edu:4567/simulation")!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            // insert json data to the request
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = jsonData
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                    
                    print("Result -> \(result)")
                    self.results = result!
                    self.performSegueWithIdentifier("loadingNext", sender: nil)
                    
                } catch {
                    print("Error -> \(error)")
                }
            }
            
            task.resume()
            
        } catch {
            print(error)
        }
        
    }
}
