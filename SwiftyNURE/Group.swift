//
//  Group.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct Group {

    public let id: Int
    public let name: String

    public init(name: String, id: Int) {
        self.id = id
        self.name = name
    }

}

extension Group: Equatable {  }

public func == (lhs: Group, rhs: Group) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}
