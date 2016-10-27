//
//  StockAllocationViewControllerTests.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/26/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class StockAllocationViewControllerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetStartingStockPercentagesOddNumberOfTickers() {
        class StockAllocationViewControllerMock: StockAllocationViewController {
            
            
            override func loadStocks() {
                stockTickers += ["AAPL", "ABCD", "EFGH"]
            }
            
            override func updateUnallocatedPercentage() {
                //do nothing
            }
            
        }
        
        let controller = StockAllocationViewControllerMock()
        controller.loadStocks()
        controller.setStartingStockPercentages()
        
        let actualStockPercentages = controller.stockPercentages
        let actualUnallocatedPercentage = controller.unallocatedPercentage
        
        let expectedStartingValue = 25
        let expectedUnallocatedPercentage = 25
        
        XCTAssertEqual(expectedUnallocatedPercentage, actualUnallocatedPercentage)
        
        for percentage in actualStockPercentages {
            XCTAssertEqual(expectedStartingValue, percentage)
        }
        
    }
    
    func testRunSimulation() {
        class StockAllocationViewControllerMock: StockAllocationViewController {
            var segueIdentifier: NSString?
            
            override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
                segueIdentifier = identifier
            }
            
            override func isInputValid() -> Bool {
                return true
            }
        }
        
        let controller = StockAllocationViewControllerMock()
        
        controller.runSimulation(self)
        
        if let identifier = controller.segueIdentifier {
            XCTAssertEqual("stockAllocationNext", identifier)
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
