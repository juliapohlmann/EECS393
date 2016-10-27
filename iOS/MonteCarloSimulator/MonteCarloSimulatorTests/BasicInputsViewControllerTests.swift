//
//  BasicInputsViewControllerTests.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/26/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class BasicInputsViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //functions that need testing
    //+ means completed!
    
    //isInputValid      +
    //backClick
    //nextClick
    //displayError
    //getInputValues
    
    func testIsInputValid() {
        testValid()
        testDurationInvalid()
        testInitialValueInvalid()
        testGoalValueInvalid()
    }
    
    func testDurationInvalid() {
        //duration == nil
        XCTAssertEqual(false, helperIsInputValid((nil, 50, 55)))
        //duration < 1
        XCTAssertEqual(false, helperIsInputValid((0, 50, 55)))
        //duration == 1
        XCTAssertEqual(false, helperIsInputValid((1, 50, 55)))
        //duration == 100
        XCTAssertEqual(false, helperIsInputValid((100, 50, 55)))
        //duration > 100
        XCTAssertEqual(false, helperIsInputValid((101, 50, 55)))
    }
    
    func testInitialValueInvalid() {
        //initial == nil
        XCTAssertEqual(false, helperIsInputValid((50, nil, 55)))
        //initial < 1
        XCTAssertEqual(false, helperIsInputValid((50, 0, 55)))
    }
    
    func testGoalValueInvalid() {
        //goal == nil
        XCTAssertEqual(false, helperIsInputValid((50, 50, nil)))
        //goal < initial
        XCTAssertEqual(false, helperIsInputValid((50, 50, 45)))
    }
    
    func testValid() {
        XCTAssertEqual(true, helperIsInputValid((50, 50, 55)))
    }
    
    func helperIsInputValid(values:(Int?, Int?, Int?)) -> Bool {
        class BasicInputsViewControllerMock: BasicInputsViewController {}
        let controller = BasicInputsViewControllerMock()
        return controller.isInputValid(values)
    }
    
}
