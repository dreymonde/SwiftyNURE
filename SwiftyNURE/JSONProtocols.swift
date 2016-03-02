//
//  JSONProtocols.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 01.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public typealias JSON = [String: AnyObject]

public protocol JSONEncodable: DataEncodable {
    
    func toJSON() -> JSON
    
}

public protocol JSONDecodable {
    
    init?(withJSON json: JSON)
    
}

public protocol JSONObject: JSONEncodable, JSONDecodable {  }

extension JSONEncodable {
    
    public func toData() -> NSData? {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(self.toJSON(), options: [])
            return data
        } catch {
            print("Can't convert JSON to NSData, \(error)")
            return nil
        }
    }
    
}

extension JSONDecodable {
    
    public init?(withData data: NSData) {
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSON {
                self.init(withJSON: json)
            }
        } catch {
            print("Can't get JSON from NSData")
            return nil
        }
    }
    
}