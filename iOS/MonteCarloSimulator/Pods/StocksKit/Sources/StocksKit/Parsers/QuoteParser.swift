//
//  QuoteParser.swift
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

private struct PercentNumberFormatter {
    
    private static let formatter : NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.generatesDecimalNumbers = true
        formatter.positivePrefix = "+"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()
    
    static func numberFromString(string : String) -> NSDecimalNumber? {
        return formatter.numberFromString(string) as? NSDecimalNumber
    }
    
}

internal struct QuoteParser : JSONParsingType {
    
    typealias T = Quote
    
    enum QuoteError : ErrorType {
        case MissingOrInvalidSymbol
        case MissingOrInvalidName
        case MissingOrInvalidStockExchange
        case MissingOrInvalidCurrency
        case MissingOrInvalidAskPrice
        case MissingOrInvalidBidPrice
        case MissingOrInvalidLastTradePrice
        case MissingOrInvalidChange
        case MissingOrInvalidPercentChange
    }
    
    static func parse(json: [String : AnyObject]) throws -> T {
    
        guard let symbol = json["symbol"] as? String else {
            throw QuoteError.MissingOrInvalidName
        }
        
        guard let name = json["Name"] as? String else {
            throw QuoteError.MissingOrInvalidName
        }
        
        guard let exchange = json["StockExchange"] as? String else {
            throw QuoteError.MissingOrInvalidStockExchange
        }
        
        guard let currency = json["Currency"] as? String else {
            throw QuoteError.MissingOrInvalidCurrency
        }
        
        guard let lastTradePrice = json["LastTradePriceOnly"] as? String else {
            throw QuoteError.MissingOrInvalidLastTradePrice
        }
        
        guard let change = json["Change"] as? String else {
            throw QuoteError.MissingOrInvalidChange
        }
        
        guard let percentChangeString = json["ChangeinPercent"] as? String, let percentChange = PercentNumberFormatter.numberFromString(percentChangeString) else {
            throw QuoteError.MissingOrInvalidPercentChange
        }
        
        return Quote(symbol: symbol, name: name, exchange: exchange, currency: currency, lastTradePrice: NSDecimalNumber(string: lastTradePrice), change: NSDecimalNumber(string: change), percentChange: percentChange)

    }
   
}
