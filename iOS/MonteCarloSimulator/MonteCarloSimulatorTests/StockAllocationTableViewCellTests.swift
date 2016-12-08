//
//  StockAllocationTableViewCellTests.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 11/17/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class StockAllocationTableViewCellTests: XCTestCase {
    
    func testSetPercentageFieldText() {
        class StockAllocationTableViewCellMock: StockAllocationTableViewCell {}
        let controller = StockAllocationTableViewCellMock()
        controller.percentageField = UILabel(frame: CGRectZero)
        controller.percentageField.text = "123"
        controller.setPercentageFieldText("abc")
        print(controller.percentageField.text)
        XCTAssertEqual("abc%", controller.percentageField.text)
    }
    
    func testSetFieldTests() {
        class StockAllocationTableViewCellMock: StockAllocationTableViewCell {}
        let controller = StockAllocationTableViewCellMock()
        controller.percentageField = UILabel(frame: CGRectZero)
        controller.tickerField = UITextField()
        
        controller.setFieldTexts("ABCD", percentageText: "1234")
        XCTAssertEqual("ABCD", controller.tickerField.text)
        XCTAssertEqual("1234%", controller.percentageField.text)
    }
    
    func testMinusClickValid() {
        class StockAllocationTableViewCellMock: StockAllocationTableViewCell {}
        let controller = StockAllocationTableViewCellMock()
        class StockAllocationTableViewControllerMock : StockAllocationTableViewController {
            override func decrementStockPercentage(ticker: String) -> Bool {
                return true
            }
        }
        controller.StockAllocationInstance = StockAllocationTableViewControllerMock()
        controller.percentageField = UILabel(frame: CGRectZero)
        controller.tickerField = UITextField()
        controller.percentageField.text = "33%"
        controller.minusClick(controller)
        XCTAssertEqual("32%", controller.percentageField.text)
    }

    func testMinusClickInvalid() {
        class StockAllocationTableViewCellMock: StockAllocationTableViewCell {}
        let controller = StockAllocationTableViewCellMock()
        class StockAllocationTableViewControllerMock : StockAllocationTableViewController {
            override func decrementStockPercentage(ticker: String) -> Bool {
                return false
            }
        }
        controller.StockAllocationInstance = StockAllocationTableViewControllerMock()
        controller.percentageField = UILabel(frame: CGRectZero)
        controller.tickerField = UITextField()
        controller.percentageField.text = "33%"
        controller.minusClick(controller)
        XCTAssertEqual("33%", controller.percentageField.text)
    }
    
    func testPlusClickValid() {
        class StockAllocationTableViewCellMock: StockAllocationTableViewCell {}
        let controller = StockAllocationTableViewCellMock()
        class StockAllocationTableViewControllerMock : StockAllocationTableViewController {
            override func incrementStockPercentage(ticker: String) -> Bool {
                return true
            }
        }
        controller.StockAllocationInstance = StockAllocationTableViewControllerMock()
        controller.percentageField = UILabel(frame: CGRectZero)
        controller.tickerField = UITextField()
        controller.percentageField.text = "33%"
        controller.plusClick(controller)
        XCTAssertEqual("34%", controller.percentageField.text)
    }

    func testPlusClickInvalid() {
        class StockAllocationTableViewCellMock: StockAllocationTableViewCell {}
        let controller = StockAllocationTableViewCellMock()
        class StockAllocationTableViewControllerMock : StockAllocationTableViewController {
            override func incrementStockPercentage(ticker: String) -> Bool {
                return false
            }
        }
        controller.StockAllocationInstance = StockAllocationTableViewControllerMock()
        controller.percentageField = UILabel(frame: CGRectZero)
        controller.tickerField = UITextField()
        controller.percentageField.text = "33%"
        controller.plusClick(controller)
        XCTAssertEqual("33%", controller.percentageField.text)
    }
    
}
