//
//  ResponseSerializer.swift
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

internal protocol ResponseSerializerType {
    typealias T
    
    func serializeResponse(data: NSData?, response: NSURLResponse?, error: NSError?) throws -> T
    
}

internal struct ResponseSerializer<T>: ResponseSerializerType {
    
    typealias SerializationBlock = (NSData?, NSURLResponse?, NSError?) throws -> T
    
    let serializationBlock: SerializationBlock
    
    init(serializationBlock: SerializationBlock) {
        self.serializationBlock = serializationBlock
    }
    
    func serializeResponse(data: NSData?, response: NSURLResponse?, error: NSError?) throws -> T {
        return try serializationBlock(data, response, error)
    }
    
}

extension NSURLSession {
    
    internal func dataTaskWithRequest<T>(request: NSURLRequest, responseSerializer: ResponseSerializer<[T]>,completionHandler: Result<[T], NSError> -> Void) -> NSURLSessionDataTask {
        return dataTaskWithRequest(request) { data, response, error in
            do {
                let objects = try responseSerializer.serializeResponse(data, response: response, error: error)
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(.Success(objects))
                }
            } catch {
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(.Failure(error as NSError))
                }
            }
        }
    }
    
}