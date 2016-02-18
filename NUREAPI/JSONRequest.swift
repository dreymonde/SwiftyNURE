//
//  JSONRequest.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON: BodyType {
    
    public var toData: NSData {
        do {
            return try self.rawData()
        } catch {
            print("Can't get rawData")
            return NSData()
        }
    }
    
    public static func fromData(data: NSData) -> JSON? {
        return JSON(data: data)
    }
    
}

public struct JSONRequest: RequestType {
    
    public let method: Method
    public let URL: NSURL
    public var body: JSON?
    public var completion: (Response<JSON> -> Void)
    public var error: (RequestError -> Void)? = nil
    
    public init(_ method: Method, url: NSURL, completion: (Response<JSON> -> Void)) {
        self.method = method
        self.URL = url
        self.completion = completion
        self.error = nil
    }
    
    public func execute() {
        let nRequest = NSMutableURLRequest(URL: URL)
        nRequest.HTTPMethod = method.rawValue
        nRequest.HTTPBody = body?.toData
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(nRequest) { data, response, error in
            guard error == nil else {
                self.error?(.NetworkError(info: error!.description))
                return
            }
            
            guard let httpResponse = response as? NSHTTPURLResponse else {
                self.error?(.NetworkError(info: "Response is not HTTPURLResponse"))
                return
            }
            
            guard let data = data, jsonResponse = JSON.fromData(data) else {
                self.error?(.NoData)
                return
            }

            let responseStruct = Response(data: jsonResponse, response: httpResponse)
            self.completion(responseStruct)
        }
        task.resume()
    }
    
}