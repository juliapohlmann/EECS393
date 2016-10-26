//
//  QueryParser.swift
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

private struct ISO8601DateFormatter {
    
    private static let formatter : NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    static func dateFromString(string : String) -> NSDate? {
        return formatter.dateFromString(string)
    }
    
}

internal struct QueryParser : JSONParsingType {
    typealias T = Query
    
    enum QueryError : ErrorType {
        case MissingCount
        case MissingCreated
        case MissingLang
        case MissingResults
    }
    
    static func parse(json: [String : AnyObject]) throws -> T {
        
        guard let count = json["count"] as? Int else {
            throw QueryError.MissingCount
        }
        
        guard let createdString = json["created"] as? String, created = ISO8601DateFormatter.dateFromString(createdString) else {
            throw QueryError.MissingCreated
        }
        
        guard let lang = json["lang"] as? String else {
            throw QueryError.MissingLang
        }
        
        guard let results = json["results"] as? [String : AnyObject] else {
            throw QueryError.MissingResults
        }
        
        return Query(count: count, created: created, lang: lang, results: results)
        
    }
    
}
