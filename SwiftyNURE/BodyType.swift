//
//  BodyType.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

protocol BodyType {
    typealias Type
    
    var toData: NSData? { get }
    static func fromData(data: NSData) -> Type?
}

extension NSData: BodyType {
    public var toData: NSData? {
        return self
    }
    public static func fromData(data: NSData) -> NSData? {
        return data
    }
}