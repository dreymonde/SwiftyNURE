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
    
    internal var toData: NSData {
        do {
            return try self.rawData()
        } catch {
            print("Can't get rawData")
            return NSData()
        }
    }
    
    internal static func fromData(data: NSData) -> JSON? {
        let json = JSON(data: data)
        return json
    }
    
}

internal struct JSONRequest: RequestType {
    
    internal let method: Method
    internal let URL: NSURL
    internal var body: NSData?
    internal var JSONBody: JSON? {
        get {
            if let body = body {
                return JSON(data: body)
            }
            return nil
        }
        set {
            guard let newValue = newValue else {
                return
            }
            do {
                self.body = try newValue.rawData()
            } catch {
                return
            }
        }
    }
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
            var jsonResponse = JSON(data: response.data)
            if jsonResponse == JSON.null {
                guard let fixedData = self.fixFuckingCIST(response.data) else {
                    self.error?(.JsonParseNull)
                    return
                }
                jsonResponse = JSON(data: fixedData)
                if jsonResponse == JSON.null {
                    self.error?(.JsonParseNull)
                    return
                }
            }
            let responseStruct = Response(data: jsonResponse, response: response.response)
            self.completion(responseStruct)
        }
        request.error = { error in
            self.error?(error)
        }
        request.execute()
    }
    
    /**
     Deprecated
     */
    private func oldExecute() {
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
            
            guard let data = data else {
                self.error?(.NoData)
                return
            }
            var jsonResponse = JSON(data: data)
            if jsonResponse == JSON.null {
                guard let fixedData = self.fixFuckingCIST(data) else {
                    self.error?(.JsonParseNull)
                    return
                }
                jsonResponse = JSON(data: fixedData)
                if jsonResponse == JSON.null {
                    self.error?(.JsonParseNull)
                    return
                }
            }
            let responseStruct = Response(data: jsonResponse, response: httpResponse)
            self.completion(responseStruct)
        }
        task.resume()
    }
    
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