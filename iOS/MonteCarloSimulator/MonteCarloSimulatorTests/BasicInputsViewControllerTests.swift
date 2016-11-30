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
    
    //isInputValid      +
    //backClick
    //nextClick
    //displayError
    //getInputValues    +
    
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
    
    func testGetInputValues() {
        class BasicInputsViewControllerMock: BasicInputsViewController {}
        let controller = BasicInputsViewControllerMock()
        controller.durationInput = UITextField()
        controller.durationInput.text = "22"
        controller.initialValueInput = UITextField()
        controller.initialValueInput.text = "33"
        controller.goalValueInput = UITextField()
        controller.goalValueInput.text = "55"
        
        let (durationValue, initialValue, goalValue) = controller.getInputValues()
        
        XCTAssertEqual(22, durationValue)
        XCTAssertEqual(33, initialValue)
        XCTAssertEqual(55, goalValue)
    }
    
    func testDisplayError() {
        class BasicInputsViewControllerMock: BasicInputsViewController {
            var alert: UIAlertController!
            
            override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
                alert = viewControllerToPresent as! UIAlertController
            }
            
        }
        let controller = BasicInputsViewControllerMock()
        controller.displayError("ABC")
        XCTAssertEqual("ABC", controller.alert.message)
        XCTAssertEqual("Error", controller.alert.title)
    }
    
}
