//
//  StockSelectionTableViewCellTests.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 11/17/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class StockSelectionTableViewCellTests: XCTestCase {
    
    func testRemoveClick() {
        class StockSelectionTableViewCellMock: StockSelectionTableViewCell {}
        let controller = StockSelectionTableViewCellMock()
        class StockSelectionTableViewControllerMock : StockSelectionTableViewController {
            override func viewDidLoad() {
                //do nothing
            }
        }
        let selectionInstanceMock = StockSelectionTableViewControllerMock()
        selectionInstanceMock.stockTickers = ["ABCD"]
        selectionInstanceMock.stockValues = [123]
        controller.StockSelectionInstance = selectionInstanceMock
        controller.ticker = "ABCD"
        controller.removeClick(controller)
        XCTAssertFalse(controller.StockSelectionInstance.stockTickers.contains("ABCD"))
    }
}
