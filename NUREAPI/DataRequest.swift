//
//  DataRequest.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct DataRequest: RequestType {
    
    public let method: Method
    public let URL: NSURL
    public var body: NSData?
    public var completion: (Response<NSData> -> Void)
    public var error: (RequestError -> Void)? = nil
    
    public init(_ method: Method, url: NSURL, _ completion: (Response<NSData> -> Void)) {
        self.method = method
        self.URL = url
        self.completion = completion
        self.error = nil
    }
    
    public func execute() -> () {
        let nRequest = NSMutableURLRequest(URL: URL)
        nRequest.HTTPMethod = method.rawValue
        nRequest.HTTPBody = body
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
            
            guard let data = data else {
                self.error?(.NoData)
                return
            }
            
            let responseStruct = Response(data: data, response: httpResponse)
            self.completion(responseStruct)
        }
        task.resume()
    }
    
}