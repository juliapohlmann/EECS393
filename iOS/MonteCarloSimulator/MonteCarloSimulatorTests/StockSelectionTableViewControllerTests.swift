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
    
    func generateStockValues(stockTickers : [String]) -> [NSDecimalNumber] {
        var stockValues = [NSDecimalNumber]()
        for ticker in stockTickers {
            stockValues.append(NSDecimalNumber.init(string: ticker))
        }
        return stockValues
    }
    
    //tests for StockSelectionTableViewControllerTests
    
    //displayError
    //backClick
    //nextClick
    //tableView -> Int
    //numberOfSectionsInTableView
    //tableView -> Cell
    //searchBarSearchButtonClicked      +
    //getStockQuote
    //removeTicker                      +
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
    
    func testRemoveTicker() {
        class StockSelectionTableViewControllerMock: StockSelectionTableViewController {
            override func reloadData() {
                //do nothing
            }
        }
        let controller = StockSelectionTableViewControllerMock()
        controller.stockTickers.appendContentsOf(generateStockTickers(15))
        controller.stockValues.appendContentsOf(generateStockValues(controller.stockTickers))
        
        //remove first
        controller.removeTicker(controller.stockTickers[0])
        XCTAssertEqual(14, controller.stockValues.count)
        XCTAssertEqual(14, controller.stockTickers.count)
        
        //remove middle
        controller.removeTicker(controller.stockTickers[controller.stockTickers.count/2])
        XCTAssertEqual(13, controller.stockValues.count)
        XCTAssertEqual(13, controller.stockTickers.count)
        
        //remove last
        controller.removeTicker(controller.stockTickers[controller.stockTickers.count - 1])
        XCTAssertEqual(12, controller.stockValues.count)
        XCTAssertEqual(12, controller.stockTickers.count)
    }
    
    func testSearchBarSearchButtonClicked() {
        class StockSelectionTableViewControllerMock: StockSelectionTableViewController {
            var errorMessage: String? = ""
            var tickerValue: String?

            override func getStockQuote(ticker: String, searchBar: UISearchBar) {
                tickerValue = ticker
            }
            override func displayError(message: String) {
                errorMessage = message
            }
            override func setUserInteraction(value: Bool) {
                //do nothing
            }
            
        }
        var controller = StockSelectionTableViewControllerMock()
        class UISearchBarMock: UISearchBar {}
        let searchBar = UISearchBarMock()
        
        //check that when getStockQuote is called it passes text all capitalized
        searchBar.text = "AbcD"
        controller.searchBarSearchButtonClicked(searchBar)
        XCTAssertEqual("ABCD", controller.tickerValue)
        
        
        //check that if stock ticker already in tickers, won't call getStockQuote
        controller = StockSelectionTableViewControllerMock()
        controller.stockTickers.append("ABCD")
        searchBar.text = "AbcD"
        controller.searchBarSearchButtonClicked(searchBar)
        XCTAssertEqual("This stock has already been added", controller.errorMessage)
    }
    
    
    
//    
//    func testSearchBarSearchButtonClickedValidTicker() {
//        class StockSelectionTableViewControllerMock: StockSelectionTableViewController {
//            var tickerValue: String?
//            var reloadedData: Bool? = false
//            var disableInteractions: Bool? = false
//            var errorMessage: String? = ""
//            override func getStockQuote(ticker: String, searchBar: UISearchBar) {
//                tickerValue = ticker
//            }
//            override func displayError(message: String) {
//                errorMessage = message
//            }
//            override func reloadData() {
//                reloadedData = true
//            }
//            override func setUserInteraction(value: Bool) {
//                disableInteractions = true
//            }
//        }
//        var controller = StockSelectionTableViewControllerMock()
//        
//        class UISearchBarMock: UISearchBar {}
//        let searchBar = UISearchBarMock()
//        
//        //VALID STOCK TICKER
//        searchBar.text = "AbcD"
//        controller.searchBarSearchButtonClicked(searchBar)
//        XCTAssertEqual("ABCD", controller.tickerValue)
//        
//        //Already added stock ticker
//        controller = StockSelectionTableViewControllerMock()
//        controller.stockTickers.append("AAAA")
//        searchBar.text = "aaaa"
//        controller.searchBarSearchButtonClicked(searchBar)
//        XCTAssertEqual(controller.errorMessage, "This stock is already added")
//        XCTAssertEqual(controller.reloadedData, false)
//        XCTAssertEqual(controller.disableInteractions, true)
//
//    }
//    
//    func testSearchBarSearchButtonClickedInvalidTicker() {
//        class StockSelectionTableViewControllerMock: StockSelectionTableViewController {
//            var tickerValue: String?
//            var reloadedData: Bool? = false
//            var disableInteractions: Bool? = false
//            var errorMessage: String? = ""
//            override func getStockQuote(ticker: String, searchBar: UISearchBar) {
//                tickerValue = ticker
//            }
//            override func displayError(message: String) {
//                errorMessage = message
//            }
//            override func reloadData() {
//                reloadedData = true
//            }
//            override func setUserInteraction(value: Bool) {
//                disableInteractions = true
//            }
//        }
//        let controller = StockSelectionTableViewControllerMock()
//        
//        class UISearchBarMock: UISearchBar {}
//        let searchBar = UISearchBarMock()
//        
//        //INVALID STOCK TICKER
//        searchBar.text = "Qe"
//        controller.searchBarSearchButtonClicked(searchBar)
//        XCTAssertEqual("QE", controller.tickerValue)
//        XCTAssertEqual(controller.reloadedData, false)
//        XCTAssertEqual(controller.disableInteractions, true)
//        XCTAssertEqual(controller.errorMessage, "Not a valid stock ticker")
//    }

//    func testGetStockQuote() {
//        class StockSelectionTableViewControllerMock: StockSelectionTableViewController {
//            override func setUserInteraction(value: Bool) {
//                //do nothing
//            }
//        }
//        let controller = StockSelectionTableViewControllerMock()
//        
//        let result = controller.getStockQuote("MSFT")
//        XCTAssertEqual(result, false)
//    }
    
    
    
}
