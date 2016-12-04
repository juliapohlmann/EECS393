//
//  ResultsViewControllerTests.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/27/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class ResultsViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHandleE() {
        //mock ResultsViewController
        class ResultsViewControllerMock: ResultsViewController {
            
        }
        
        let controller = ResultsViewControllerMock()
        let expected = String(1000000)
        XCTAssertEqual(expected, controller.handleE("10E5"))
        XCTAssertEqual(expected, controller.handleE("1000000"))
        
    }
    
    func testSetLabels() {
        //mock ResultsViewController
        class ResultsViewControllerMock: ResultsViewController {
            
            func setResults() {
                
                results = ["minValue": "10", "maxValue": "15", "percentGoalReached": ".9"]
                
            }
            
            
        }
        
        let controller = ResultsViewControllerMock()
        controller.setResults()
        controller.setLabels()
        XCTAssertEqual(controller.minValue.text, controller.handleE("Min Value: $10"))
        XCTAssertEqual(controller.maxValue.text, controller.handleE("Max Value: $15"))
        XCTAssertEqual(controller.percentReached.text, controller.handleE("Goal Reached: 90% of simulations"))
    }
    
    //tests for ResultsViewController
    
    
}
