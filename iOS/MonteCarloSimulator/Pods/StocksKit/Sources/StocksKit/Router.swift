//
//  Router.swift
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

public protocol URLRequestConvertible {
    var URLRequest: NSURLRequest { get }
}

enum Method: String {
    case GET
}

struct Router {
    
    private static var baseURL : NSURL {
        return NSURL(string : "https://query.yahooapis.com")!
    }
    
    enum Quotes : URLRequestConvertible {
        case Fetch([String])
        
        var path : String {
            switch self {
            case .Fetch:
                return "/v1/public/yql"
            }
        }
        
        var URLRequest: NSURLRequest {
            switch self {
            case .Fetch(let symbols):
                var params = [String : String]()
                params["q"] = "select * from yahoo.finance.quotes where symbol=\"\(symbols.joinWithSeparator(","))\""
                params["format"] = "json"
                params["env"] = "store://datatables.org/alltableswithkeys"
                let URLComponents = NSURLComponents(URL: NSURL(string: path, relativeToURL: Router.baseURL)!, resolvingAgainstBaseURL: true)!
                URLComponents.queryItems = params.map({NSURLQueryItem(name: $0, value: $1)})
                let url = URLComponents.URL!
                return NSURLRequest(URL: url)
            }
        }
    }
    
    enum ExchangeRates : URLRequestConvertible {
        case Fetch([String])
        
        var path : String {
            switch self {
            case .Fetch:
                return "/v1/public/yql"
            }
        }
        
        var URLRequest: NSURLRequest {
            switch self {
            case .Fetch(let pairs):
                var params = [String : String]()
                let pairsInCommas = pairs.map({"\"\($0)\""})
                params["q"] = "select * from yahoo.finance.xchange where pair in (\(pairsInCommas.joinWithSeparator(",")))"
                params["format"] = "json"
                params["env"] = "store://datatables.org/alltableswithkeys"
                let URLComponents = NSURLComponents(URL: NSURL(string: path, relativeToURL: Router.baseURL)!, resolvingAgainstBaseURL: true)!
                URLComponents.queryItems = params.map({NSURLQueryItem(name: $0, value: $1)})
                let url = URLComponents.URL!
                return NSURLRequest(URL: url)
            }
        }
    }
}

