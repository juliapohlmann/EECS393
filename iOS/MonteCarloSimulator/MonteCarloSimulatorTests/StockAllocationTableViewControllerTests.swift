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
    //runSimulation                       +
    //isInputValid                        +
    //canDecrementStock                   +
    //canIncrementStock                   +
    //incrementStockPercentage            +
    //decrementStockPercentage            +
    //decrementUnallocatedPercentage      +
    //incrementUnallocatedPercentage      +
    //updateUnallocatedPercentageField
    //backClick
    //loadStocks
    //numberOfSectionsInTableView
    //tableView -> Int
    //tableView -> Cell
    //displayError

    func testIncrementUnallocatedPercentage() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        
        let controller = StockAllocationTableViewControllerMock()
        controller.unallocatedPercentage = 15
        controller.incrementUnallocatedPercentage()
        let expected = 16
        XCTAssertEqual(expected, controller.unallocatedPercentage)
    }
    
    func testDecrementUnallocatedPercentage() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        
        let controller = StockAllocationTableViewControllerMock()
        controller.unallocatedPercentage = 15
        controller.decrementUnallocatedPercentage()
        let expected = 14
        XCTAssertEqual(expected, controller.unallocatedPercentage)
    }
    
    func testDecrementStockPercentage() {
        testDecrementStockPercentageTrue()
        testDecrementStockPercentageFalse()
    }
    
    func testDecrementStockPercentageTrue() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        
        let controller = StockAllocationTableViewControllerMock()
        controller.loadStocks(["ABCD", "EFGH", "IJKL"])
        controller.setStartingStockPercentages()
        
        controller.decrementStockPercentage("ABCD")
        let expected = 24
        XCTAssertEqual(expected, controller.stockPercentages[0])
    }
    
    func testDecrementStockPercentageFalse() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func canDecrementStock(percentage: Int) -> Bool {
                return false
            }
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        
        let controller = StockAllocationTableViewControllerMock()
        controller.loadStocks(["ABCD", "EFGH", "IJKL"])
        controller.setStartingStockPercentages()
        
        controller.decrementStockPercentage("ABCD")
        let expected = 25
        XCTAssertEqual(expected, controller.stockPercentages[0])
    }
    
    func testIncrementStockPercentage() {
        testIncrementStockPercentageTrue()
        testIncrementStockPercentageFalse()
    }
    
    func testIncrementStockPercentageTrue() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        
        let controller = StockAllocationTableViewControllerMock()
        controller.loadStocks(["ABCD", "EFGH", "IJKL"])
        controller.setStartingStockPercentages()
        
        controller.incrementStockPercentage("ABCD")
        let expected = 26
        XCTAssertEqual(expected, controller.stockPercentages[0])
    }
    
    func testIncrementStockPercentageFalse() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func canIncrementStock() -> Bool {
                return false
            }
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        
        let controller = StockAllocationTableViewControllerMock()
        controller.loadStocks(["ABCD", "EFGH", "IJKL"])
        controller.setStartingStockPercentages()
        
        controller.incrementStockPercentage("ABCD")
        let expected = 25
        XCTAssertEqual(expected, controller.stockPercentages[0])
    }
    
    
    func testCanIncrementStock() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {}
        let controller = StockAllocationTableViewControllerMock()
        controller.unallocatedPercentage = 1
        
        //true
        var expected = true
        XCTAssertEqual(expected, controller.canIncrementStock())
        
        //false
        controller.unallocatedPercentage = 0
        expected = false
        XCTAssertEqual(expected, controller.canIncrementStock())
    }
    
    func testCanDecrementStock() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {}
        let controller = StockAllocationTableViewControllerMock()
        
        //true
        var expected = true
        XCTAssertEqual(expected, controller.canDecrementStock(1))
        
        //false
        expected = false
        XCTAssertEqual(expected, controller.canDecrementStock(0))
    }
    
    
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
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        
        let controller = StockAllocationTableViewController()
        controller.loadStocks(["ABCD", "EFGH", "IJKL"])
        
        return controller.findIndexOfTicker(ticker)
    }
    
    func testValidEdit() {
        testValidEditTrue()
        testValidEditFalse()
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
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationTableViewControllerMock()
        controller.loadStocks(["ABCD", "EFGH", "IJKL"])
        controller.setStartingStockPercentages()
        
        let actualValue = controller.validEdit(ticker, oldValue: oldValue, newValue: newValue)
        
        XCTAssertEqual(expectedValue, actualValue)
    }
    
    func testIsInputValid() {
        testIsInputValidFalse()
        testIsInputValidTrue()
    }
    
    func testIsInputValidFalse() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationTableViewControllerMock()
        controller.loadStocks(["ABCD", "EFGH", "IJKL"])
        controller.setStartingStockPercentages()
        
        controller.unallocatedPercentage = -1
        let expectedIsValid = false
        XCTAssertEqual(expectedIsValid, controller.isInputValid())
        
        controller.unallocatedPercentage = 1
        XCTAssertEqual(expectedIsValid, controller.isInputValid())
        
    }
    
    func testIsInputValidTrue() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationTableViewControllerMock()
        controller.unallocatedPercentage = 0
        let expectedIsValid = true
        XCTAssertEqual(expectedIsValid, controller.isInputValid())
    }
    
    func testSetStartingStockPercentages() {
        testSetStartingStockPercentagesEvenNumberOfTickers()
        testSetStartingStockPercentagesOddNumberOfTickers()
    }
    
    func testSetStartingStockPercentagesOddNumberOfTickers() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationTableViewControllerMock()
        controller.loadStocks(["ABCD", "EFGH", "IJKL"])
        helperSetStartingStockPercentages(controller, expectedStartingValue: 25, expectedUnallocatedPercentage: 25)
    }
    
    func testSetStartingStockPercentagesEvenNumberOfTickers() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            override func updateUnallocatedPercentageField() {
                //do nothing
            }
        }
        let controller = StockAllocationTableViewControllerMock()
        controller.loadStocks(["ABCD", "EFGH", "IJKL", "MNOP"])
        helperSetStartingStockPercentages(controller, expectedStartingValue: 16, expectedUnallocatedPercentage: 36)
    }
    
    func helperSetStartingStockPercentages(controller : StockAllocationTableViewController, expectedStartingValue : Int, expectedUnallocatedPercentage : Int) {
        controller.setStartingStockPercentages()
        
        let actualStockPercentages = controller.stockPercentages
        let actualUnallocatedPercentage = controller.unallocatedPercentage
        
        XCTAssertEqual(expectedUnallocatedPercentage, actualUnallocatedPercentage)
        for percentage in actualStockPercentages {
            XCTAssertEqual(expectedStartingValue, percentage)
        }
        
    }
    
    func testRunSimulation() {
        class StockAllocationTableViewControllerMock: StockAllocationTableViewController {
            var segueIdentifier: NSString?
            
            override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
                segueIdentifier = identifier
            }
            
            override func isInputValid() -> Bool {
                return true
            }
        }
        
        let controller = StockAllocationTableViewControllerMock()
        
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