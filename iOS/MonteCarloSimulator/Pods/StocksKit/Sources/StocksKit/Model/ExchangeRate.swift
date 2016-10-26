//
//  ExchangeRate.swift
//  StocksKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Alexander Edge
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

public struct ExchangeRate {
    
    public let identifier: String
    public let from: String
    public let to: String
    public let rate: NSDecimalNumber
    public let date: NSDate
    
}

public extension ExchangeRate {
    
    public static func fetch(pair : String, completionHandler: Result<[ExchangeRate], NSError> -> Void) -> NSURLSessionDataTask {
        return self.fetch([pair], completionHandler: completionHandler)
    }
    
    public static func fetch(pair : [String], completionHandler: Result<[ExchangeRate], NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(Router.ExchangeRates.Fetch(pair).URLRequest, completionHandler: completionHandler)
    }
    
}

extension NSURLSession {
    
    public func dataTaskWithRequest(request: NSURLRequest, completionHandler: Result<[ExchangeRate], NSError> -> Void) -> NSURLSessionDataTask {
        return dataTaskWithRequest(request, responseSerializer: ExchangeRateResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}