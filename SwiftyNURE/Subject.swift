//
//  Subject.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct Subject {
    
    public let id: Int
    public let name: String
    public let shortName: String
    
    public init(name: String, shortName: String, id: Int) {
        self.name = name
        self.shortName = shortName
        self.id = id
    }
    
}