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
    
    func testApplicationWillResignActive() {
        class AppDelegateMock : AppDelegate {}
        let controller = AppDelegateMock()
        let app = UIApplication.sharedApplication()
        
        controller.applicationDidEnterBackground(app)
        //nothing to test explicitly
    }
    
    func testApplicationWillEnterForeground() {
        class AppDelegateMock : AppDelegate {}
        let controller = AppDelegateMock()
        let app = UIApplication.sharedApplication()
        
        controller.applicationWillEnterForeground(app)
        //nothing to test explicitly
    }
    
    func testApplicationDidBecomeActive() {
        class AppDelegateMock : AppDelegate {}
        let controller = AppDelegateMock()
        let app = UIApplication.sharedApplication()
        
        controller.applicationDidBecomeActive(app)
        //nothing to test explicitly
    }
    
    func testApplicationWillTerminate() {
        class AppDelegateMock : AppDelegate {
            var contextSaved = false
            override func saveContext() {
                contextSaved = true
            }
        }
        let controller = AppDelegateMock()
        let app = UIApplication.sharedApplication()
        
        controller.applicationWillTerminate(app)
        XCTAssertTrue(controller.contextSaved)
        //nothing to test explicitly
    }
    
    
    
    
}
