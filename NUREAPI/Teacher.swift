//
//  Teacher.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct Teacher {
    
    public var id: Int
    public var shortName: String
    public var fullName: String
    
    public init(fullName: String, shortName: String, id: Int) {
        self.id = id
        self.fullName = fullName
        self.shortName = shortName
    }
    
}