//
//  Request.swift
//  CocoaNURE
//
//  Created by Oleg Dreyman on 17.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

protocol RequestType {
    
    typealias ABodyType: BodyType
    
    var method: Method { get }
    var URL: NSURL { get }
    var body: NSData? { get set }
    var completion: (Response<ABodyType> -> Void) { get set }
    var error: (RequestError -> Void)? { get set }
    
    func execute() -> ()
    
}

enum Method: String {
    case GET, POST
}

public enum RequestError: ErrorType {
    case NetworkError(info: String)
    case NoData
    case JsonParseNull
}