//
//  LoadingViewControllerTests.swift
//  MonteCarloSimulator
//
//  Created by Shyam Kotak on 12/3/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class LoadingViewControllerTests: XCTestCase {
    
    
    func testSubmitAction() {
        
        class LoadingViewControllerMock: LoadingViewController {
            
            func setUserDict() {
                
                userDict = ["years": 12, "startingMoney": 123, "tickerToAllocation": ["H": 6, "D": 6, "L": 6, "B": 6, "K": 6, "F": 6, "I": 6, "O": 6, "M": 6, "A": 16, "C": 6, "N": 6, "G": 6, "P": 6, "E": 6], "goalMoney": 1234]
                
            }
            
            func setUserDictWrong() {
                userDict = ["years": 12, "startingMoney": 123, "tickerToAllocation": ["D": 6, "L": 6, "B": 6, "K": 6, "F": 6, "I": 6, "O": 6, "M": 6, "A": 16, "C": 6, "N": 6, "G": 6, "P": 6, "E": 6], "goalMoney": 1234]
            }
            
            override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
                // do nothing
            }
            
        }
        
        let controller = LoadingViewControllerMock()
        controller.setUserDictWrong()
        controller.submitAction()
        sleep(10)
        XCTAssertEqual(controller.results.count, 0)
        
        
        controller.setUserDict()
        controller.submitAction()
        sleep(20)
        XCTAssertEqual(controller.results.count, 4)
        
        
    }
    
    
}
