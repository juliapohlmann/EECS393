//
//  StockSelectionTableViewControllerTests.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/27/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class StockSelectionTableViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func generateStockTickers(count: Int) -> [String] {
        var stockTickers = [String]()
        for i in  1...count {
            stockTickers.append(String(i))
        }
        return stockTickers
    }
    
    //tests for StockSelectionTableViewControllerTests
    
    //displayError
    //backClick
    //nextClick
    //tableView -> Int
    //numberOfSectionsInTableView
    //tableView -> Cell
    //searchBarSearchButtonClicked
    //findIndexOfTicker
    //removeTicker
    //prepareForSegue
    //isInputValid                      +
    
    func testIsInputValid() {
        testIsInputValidTrue()
        testIsInputValidFalse()
    }
    
    func testIsInputValidTrue() {
        class StockSelectionTableViewControllerMock: StockSelectionTableViewController {}
        let controller = StockSelectionTableViewControllerMock()
        
        //15 stocks
        controller.stockTickers.appendContentsOf(generateStockTickers(15))
        XCTAssertTrue(controller.isInputValid())
        
        //50 stocks
        controller.stockTickers.appendContentsOf(generateStockTickers(35))
        XCTAssertTrue(controller.isInputValid())
        
        //100 stocks
        controller.stockTickers.appendContentsOf(generateStockTickers(50))
        XCTAssertTrue(controller.isInputValid())
    }
    
    func testIsInputValidFalse() {
        class StockSelectionTableViewControllerMock: StockSelectionTableViewController {
            override func displayError(message:String) {
                //do nothing
            }
        }
        let controller = StockSelectionTableViewControllerMock()
        
        //14 stocks
        controller.stockTickers.appendContentsOf(generateStockTickers(14))
        XCTAssertFalse(controller.isInputValid())
        
        //101 stocks
        controller.stockTickers.appendContentsOf(generateStockTickers(87))
        XCTAssertFalse(controller.isInputValid())
    }
    
    
}
