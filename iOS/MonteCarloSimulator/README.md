To view the MonteCarloSimulator project, open the file named "MonteCarloSimulator.xcworkspace". 

The Swift version we used is older than 2.3, but if you update the code to 2.3 automatically when opening xcode, it still functions as expected. 

It is important that you open this file and not the file named "MonteCarloSimulator.xcodeproj" as we are utilizing CocoaPods and the CocoaPod set-up is specified in the .xcworkspace file. 

To view the storyboard, make sure to change the settings at the bottom bar to w="Compact" h="Regular"

To build, use ⌘ + B
To run, use an iPhone 6 simulator and use ⌘ + R
To test, use ⌘ + U

All code written is our own, some is generated from Storyboard in which we matched the designs submitted in the design document to the best of our ability. 

The only exception is in StockSelectionTableViewController.swift where we utilize the StocksKit CocoaPod method to get the real time value of a stock from Yahoo Finance. More can be found about this CocoaPod at https://cocoapods.org/pods/StocksKit
