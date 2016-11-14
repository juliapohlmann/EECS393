//
//  IntroViewControllerTest.swift
//  MonteCarloSimulator
//
//  Created by Shyam Kotak on 10/26/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class IntroViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //tests for IntroViewController
    
    //startButtonclick       +
    
    func testStartButtonClick() {
        //mock IntroViewController
        class IntroViewControllerMock: IntroViewController {
            var segueIdentifier: NSString?
            
            override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
                segueIdentifier = identifier
            }
        }
        
        let controller = IntroViewControllerMock()
        controller.startButtonClick(self)
        
        if let identifier = controller.segueIdentifier {
            XCTAssertEqual("startSimulation", identifier)
        }
        else {
            XCTFail("Segue should be performed")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
