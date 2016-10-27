//
//  ResultsViewController.swift
//  MonteCarloSimulator
//
//  Created by Shyam Kotak on 10/25/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    var userDict: [String:Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        print(userDict)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
