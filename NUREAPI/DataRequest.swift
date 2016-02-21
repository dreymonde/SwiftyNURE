//
//  DataRequest.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

internal struct DataRequest: RequestType {
    
    internal let method: Method
    internal let URL: NSURL
    internal var body: NSData?
    internal var completion: (Response<NSData> -> Void)
    internal var error: (RequestError -> Void)? = nil
    
    internal init(_ method: Method, url: NSURL, _ completion: (Response<NSData> -> Void)) {
        self.method = method
        self.URL = url
        self.completion = completion
        self.error = nil
    }
    
    internal func execute() -> () {
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