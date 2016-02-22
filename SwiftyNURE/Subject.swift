//
//  Subject.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct Subject {
    
    public var id: Int
    public var name: String
    public var shortName: String
    
    public init(name: String, shortName: String, id: Int) {
        self.name = name
        self.shortName = shortName
        self.id = id
    }
    
}