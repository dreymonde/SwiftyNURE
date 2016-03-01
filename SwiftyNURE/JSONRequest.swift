//
//  JSONRequest.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

internal struct JSONRequest: RequestType {
    
    internal let method: Method
    internal let URL: NSURL
    internal var body: NSData?
    internal var completion: (Response<JSON> -> Void)
    internal var error: (RequestError -> Void)? = nil
    
    internal init(_ method: Method, url: NSURL, _ completion: (Response<JSON> -> Void)) {
        self.method = method
        self.URL = url
        self.completion = completion
        self.error = nil
    }
    
    internal func execute() {
        var request = DataRequest(.GET, url: URL) { response in
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: []) as? JSON {
                    let responseStruct = Response(data: json, response: response.response)
                    self.completion(responseStruct)
                }
                self.error?(.JsonParseNull)
            } catch {
                self.error?(.JsonParseNull)
            }
        }
        request.error = pushError
        request.execute()
    }
    
//    internal func oldexecute() {
//        var request = DataRequest(.GET, url: URL) { response in
//            var jsonResponse = JSON(data: response.data)
//            if jsonResponse == JSON.null {
//                guard let fixedData = self.fixFuckingCIST(response.data) else {
//                    self.error?(.JsonParseNull)
//                    return
//                }
//                jsonResponse = JSON(data: fixedData)
//                if jsonResponse == JSON.null {
//                    self.error?(.JsonParseNull)
//                    return
//                }
//            }
//            let responseStruct = Response(data: jsonResponse, response: response.response)
//            self.completion(responseStruct)
//        }
//        request.error = { error in
//            self.error?(error)
//        }
//        request.execute()
//    }
    
    private func fixFuckingCIST(data: NSData) -> NSData? {
        guard let received = String(data: data, encoding: NSWindowsCP1251StringEncoding) else {
            return nil
        }
        guard let dataFromString = received.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
            return nil
        }
        return dataFromString
    }
    
}