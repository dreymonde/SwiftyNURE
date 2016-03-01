//
//  University.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class University {
    
    public var teachers: [Teacher.Extended] = []
    public var groups: [Group] = []
    
    public init(teachers: [Teacher.Extended], groups: [Group]) {
        self.teachers = teachers
        self.groups = groups
    }
    
    public convenience init() {
        self.init(teachers: [], groups: [])
    }
    
}