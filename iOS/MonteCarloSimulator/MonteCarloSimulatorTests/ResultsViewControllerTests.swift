//
//  ResultsViewControllerTests.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 10/27/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
import Charts
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
    
    func testSetBasicChartFeatures() {
        class ResultsViewControllerMock: ResultsViewController {}
        let controller = ResultsViewControllerMock()
        
        let actual = controller.setBasicChartFeatures(BarChartView())
        
        XCTAssertEqual(UIColor.whiteColor(), actual.gridBackgroundColor)
        XCTAssertEqual("", actual.descriptionText)
        XCTAssertFalse(actual.legend.enabled)
    }
    
    func testSetAxesHelper() {
        class ResultsViewControllerMock: ResultsViewController {}
        let controller = ResultsViewControllerMock()
        let percentFormatter = NSNumberFormatter()
        percentFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        let actual = controller.setAxesHelper(BarChartView(), percentFormatter: percentFormatter)
        
        XCTAssertFalse(actual.xAxis.drawGridLinesEnabled)
        XCTAssertFalse(actual.leftAxis.drawGridLinesEnabled)
        XCTAssertFalse(actual.rightAxis.enabled)
        XCTAssertFalse(actual.scaleYEnabled)
        XCTAssertFalse(actual.scaleXEnabled)
        XCTAssertTrue(actual.leftAxis.enabled)
        XCTAssertEqual(UIColor.blackColor(), actual.xAxis.labelTextColor)
        XCTAssertEqual(UIColor.blackColor(), actual.rightAxis.labelTextColor)
        XCTAssertEqual(percentFormatter, actual.leftAxis.valueFormatter)
    }
    
    func testSetDataHelper() {
        class ResultsViewControllerMock: ResultsViewController {}
        let controller = ResultsViewControllerMock()
        let values : [Float] = [2.0, 3.0, 4.0]
        
        let entry1 = BarChartDataEntry(value: 2.0, xIndex: 0)
        let entry2 = BarChartDataEntry(value: 3.0, xIndex: 1)
        let entry3 = BarChartDataEntry(value: 4.0, xIndex: 2)
        
        let expected : [BarChartDataEntry] = [entry1, entry2, entry3]
        let actual = controller.setDataHelper(values)
        print("ACTUAL: ")
        print(actual)
        XCTAssertEqual(expected, actual)

    }
    
    func testHandleE() {
        //mock ResultsViewController
        class ResultsViewControllerMock: ResultsViewController {}
        
        let controller = ResultsViewControllerMock()
        
        XCTAssertEqual(Optional("1e+06"), controller.handleE("10E5"))
        XCTAssertEqual("1000000", controller.handleE("1000000"))
        
    }
    
    func testSetLabels() {
        //mock ResultsViewController
        class ResultsViewControllerMock: ResultsViewController {
            func setResults() {
                results = ["maxValue": 15.2340, "percentGoalReached": 0.90, "minValue": 10.2340]
            }
        }
        
        let controller = ResultsViewControllerMock()
        controller.minValue = UILabel()
        controller.maxValue = UILabel()
        controller.percentReached = UILabel()
        controller.setResults()
        controller.setLabels()
        XCTAssertEqual(controller.minValue.text, controller.handleE("Min Value: $10.23"))
        XCTAssertEqual(controller.maxValue.text, controller.handleE("Max Value: $15.23"))
        XCTAssertEqual(controller.percentReached.text, controller.handleE("Goal Reached: 90% of simulations"))
    }
    
    func testConvertGraphValues() {
        //mock ResultsViewController
        class ResultsViewControllerMock: ResultsViewController {
            
        }
        
        let controller = ResultsViewControllerMock()
        let oldGraphValues = ["222.07745818183218": 0.5111, "259.18770902169445": 0.2317, "203.52233276190108": 0.6909999999999999, "249.91014631172885": 0.2892, "277.7428344416255": 0.15, "231.35502089179775": 0.4307, "212.79989547186665": 0.6016, "240.63258360176332": 0.356, "194.24477005193555": 0.7761, "268.46527173166": 0.1869]
        
        controller.convertGraphValues(oldGraphValues)
        
        let keys = ["$194.00", "$203.00", "$212.00", "$222.00", "$231.00", "$240.00", "$249.00", "$259.00", "$268.00", "$277.00"]
        
        
        XCTAssertEqual(controller.sortedKeys, keys)
        // can't test if floating point arrays are equal in iOS??
        // let values = [0.2239, 0.0851, 0.08939999, 0.0905, 0.08039999, 0.0747, 0.0668, 0.0575, 0.0448, 0.0369]
        // XCTAssertEqual(controller.sortedValues, values)
    }
    
    //tests for ResultsViewController
    
    
}
