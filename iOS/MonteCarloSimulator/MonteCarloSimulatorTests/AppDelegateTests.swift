//
//  AppDelegateTests.swift
//  MonteCarloSimulator
//
//  Created by Julia Pohlmann on 11/18/16.
//  Copyright © 2016 EECS393. All rights reserved.
//

import XCTest
@testable import MonteCarloSimulator

class AppDelegateTests: XCTestCase {
    
    func testApplication() {
        class AppDelegateMock : AppDelegate {}
        let controller = AppDelegateMock()
        let app = UIApplication.sharedApplication()

        XCTAssertTrue(controller.application(app, didFinishLaunchingWithOptions: [NSObject:AnyObject]()))
    }
}
