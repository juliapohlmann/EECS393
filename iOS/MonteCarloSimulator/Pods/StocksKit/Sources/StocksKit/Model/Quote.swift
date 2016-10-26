//
//  Quote.swift
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

public struct Quote {
    
    public let symbol : String
    public let name : String
    public let currency : String
    public let exchange : String
    public let lastTradePrice : NSDecimalNumber
    public let change : NSDecimalNumber
    public let percentChange : NSDecimalNumber
    
    public init(symbol: String, name: String, exchange: String, currency: String, lastTradePrice: NSDecimalNumber, change: NSDecimalNumber, percentChange: NSDecimalNumber) {
        self.symbol = symbol
        self.name = name
        self.exchange = exchange
        self.currency = currency
        self.lastTradePrice = lastTradePrice
        self.change = change
        self.percentChange = percentChange
    }
    
}

public extension Quote {
    
    public static func fetch(symbol : String, completionHandler: Result<[Quote], NSError> -> Void) -> NSURLSessionDataTask {
        return self.fetch([symbol], completionHandler: completionHandler)
    }
    
    public static func fetch(symbols : [String], completionHandler: Result<[Quote], NSError> -> Void) -> NSURLSessionDataTask {
        return NSURLSession.sharedSession().dataTaskWithRequest(Router.Quotes.Fetch(symbols).URLRequest, completionHandler: completionHandler)
    }
    
}

extension NSURLSession {
    
    public func dataTaskWithRequest(request: NSURLRequest, completionHandler: Result<[Quote], NSError> -> Void) -> NSURLSessionDataTask {
        return dataTaskWithRequest(request, responseSerializer: QuoteResponseSerializer.serializer(), completionHandler: completionHandler)
    }
    
}

extension CollectionType where Generator.Element: QuoteType {
    
    public var currencies: [String] {
        return Array(Set(self.map({$0.currency})))
    }
    
}

