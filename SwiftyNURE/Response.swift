//
//  Response.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

internal struct Response<T> {
    internal init(data: T, response: NSHTTPURLResponse) {
        self.data = data
        self.response = response
    }
        
    internal var data: T
    internal var response: NSHTTPURLResponse
    internal var statusCode: Int {
        return response.statusCode
    }
    internal var headers: [NSObject: AnyObject] {
        return response.allHeaderFields
    }
}