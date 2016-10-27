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
    
    //functions that need testing
    //+ means completed!
    
    //validEdit                           +
    //setStartingStockPercentages         +
    //findIndexOfTicker                   +
    //loadStocks
    //runSimulation                       +
    //backClick
    //isInputValid                        +
    //decrementUnallocatedPercentage
    //incrementUnallocatedPercentage
    //incrementStockPercentage
    //decrementStockPercentage
    //canDecrementStock
    //canIncrementStock
    //updateUnallocatedPercentageField
    
    
    
    
    func testFindIndexOfTicker() {
        //first
        XCTAssertEqual(0, helperFindIndexOfTicker("ABCD"))
        
        //middle
        XCTAssertEqual(1, helperFindIndexOfTicker("EFGH"))
        
        //last
        XCTAssertEqual(2, helperFindIndexOfTicker("IJKL"))
        
        //not in array
        XCTAssertEqual(-1, helperFindIndexOfTicker("Z"))
        
    }
    
    func helperFindIndexOfTicker(ticker: String) -> Int {
        class StockAllocationViewControllerMock: StockAllocationViewController {
            override func loadStocks() {
                stockTickers += ["ABCD", "EFGH", "IJKL"]
                setStartingStockPercentages()
            }
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        
        let controller = StockAllocationViewControllerMock()
        controller.loadStocks()
        
        return controller.findIndexOfTicker(ticker)
    }
    
    
    func testValidEditTrue() {
        //true
        helperValidEdit(true, ticker: "ABCD", oldValue: 1, newValue: 15)
    }
    
    func testValidEditFalse() {
        //false because newValue > 100
        helperValidEdit(false, ticker: "ABCD", oldValue: 25, newValue: 101)
        //false because newValue =  0
        helperValidEdit(false, ticker: "ABCD", oldValue: 25, newValue: 0)
        //false because newValue < 0
        helperValidEdit(false, ticker: "ABCD", oldValue: 25, newValue: -1)
        
        //false because (newValue - oldValue) > unallocatedPercentage
        helperValidEdit(false, ticker: "ABCD", oldValue: 1, newValue: 1000)
    }
    
    func helperValidEdit(expectedValue: Bool, ticker: String, oldValue: Int, newValue: Int) {
        class StockAllocationViewControllerMock: StockAllocationViewController {
            override func loadStocks() {
                stockTickers += ["ABCD", "EFGH", "IJKL"]
                setStartingStockPercentages()
            }
            
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationViewControllerMock()
        controller.loadStocks()
        
        let actualValue = controller.validEdit(ticker, oldValue: oldValue, newValue: newValue)
        
        XCTAssertEqual(expectedValue, actualValue)
    }
    
    func testIsInputValidFalse() {
        class StockAllocationViewControllerMock: StockAllocationViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationViewControllerMock()
        
        controller.unallocatedPercentage = -1
        let expectedIsValid = false
        XCTAssertEqual(expectedIsValid, controller.isInputValid())
        
        controller.unallocatedPercentage = 1
        XCTAssertEqual(expectedIsValid, controller.isInputValid())
        
    }

    func testIsInputValidTrue() {
        class StockAllocationViewControllerMock: StockAllocationViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationViewControllerMock()
        controller.unallocatedPercentage = 0
        let expectedIsValid = true
        XCTAssertEqual(expectedIsValid, controller.isInputValid())
    }
    
    
    func testSetStartingStockPercentagesOddNumberOfTickers() {
        class StockAllocationViewControllerMock: StockAllocationViewController {
            override func loadStocks() {
                
                stockTickers += ["ABCD", "EFGH", "IJKL"]
            }
            
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationViewControllerMock()
        helperSetStartingStockPercentages(controller, expectedStartingValue: 25, expectedUnallocatedPercentage: 25)
    }
    
    func testSetStartingStockPercentagesEvenNumberOfTickers() {
        class StockAllocationViewControllerMock: StockAllocationViewController {
            override func loadStocks() {
                
                stockTickers += ["ABCD", "EFGH", "IJKL", "MNOP"]
            }
            
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationViewControllerMock()
        helperSetStartingStockPercentages(controller, expectedStartingValue: 16, expectedUnallocatedPercentage: 36)
    }
    
    func helperSetStartingStockPercentages(controller : StockAllocationViewController, expectedStartingValue : Int, expectedUnallocatedPercentage : Int) {
        controller.loadStocks()
        controller.setStartingStockPercentages()
        
        let actualStockPercentages = controller.stockPercentages
        let actualUnallocatedPercentage = controller.unallocatedPercentage
        print("actualStockPercentages: \(actualStockPercentages)")
        print("actualUnallocatedPercentage: \(actualUnallocatedPercentage)")
        
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
    //
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measureBlock {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
