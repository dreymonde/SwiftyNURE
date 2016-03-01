//
//  JSONProtocols.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 01.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public typealias JSON = [String: AnyObject]

public protocol JSONEncodable {
    
    var toJSON: JSON { get }
    
}

public protocol JSONDecodable {
    
    init?(withJSON json: JSON)
    
}

public protocol JSONObject: JSONEncodable, JSONDecodable {  }