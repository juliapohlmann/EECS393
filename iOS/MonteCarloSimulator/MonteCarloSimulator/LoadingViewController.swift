//
//  LoadingViewController.swift
//  MonteCarloSimulator
//
//  Created by Shyam Kotak on 11/14/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    var combinedDict: [String : Dictionary<String, AnyObject>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("yo")
        
        submitAction()
        
        print("yo2")

        performSegueWithIdentifier("loadingNext", sender: nil)
        
        print("yo3")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitAction() {
        
        do {
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(combinedDict, options: .PrettyPrinted)
            
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
                    
                } catch {
                    print("Error -> \(error)")
                }
            }
            
            task.resume()
            
        } catch {
            print(error)
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
