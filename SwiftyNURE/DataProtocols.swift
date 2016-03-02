//
//  DataProtocols.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 21.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol DataEncodable {
    
    func toData() -> NSData?
    
}

public protocol DataDecodable {
    
    init?(withData data: NSData)
    
}

public protocol DataObject: DataEncodable, DataDecodable {  }