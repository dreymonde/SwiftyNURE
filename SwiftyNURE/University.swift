//
//  University.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct University {
    
    public let teachers: [Teacher.Extended]
    public let groups: [Group]
    
    public init(teachers: [Teacher.Extended], groups: [Group]) {
        self.teachers = teachers
        self.groups = groups
    }
    
    public init() {
        self.init(teachers: [], groups: [])
    }
    
}