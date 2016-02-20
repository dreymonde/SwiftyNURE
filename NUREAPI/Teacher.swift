//
//  Teacher.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol TeacherType {
    
    var id: Int { get }
    var shortName: String { get }
    var fullName: String { get }
    
}

public struct Teacher: TeacherType {
    
    public var id: Int
    public var shortName: String
    public var fullName: String
    
    public init(fullName: String, shortName: String, id: Int) {
        self.id = id
        self.fullName = fullName
        self.shortName = shortName
    }
    
}

public struct TeacherExtended: TeacherType {
    
    public var id: Int
    public var shortName: String
    public var fullName: String
    public var department: String
    public var faculty: String
    
    public init(fullName: String, shortName: String, department: String, faculty: String, id: Int) {
        self.id = id
        self.fullName = fullName
        self.shortName = shortName
        self.department = department
        self.faculty = faculty
    }
    
    public init(teacher: Teacher, department: String, faculty: String) {
        self.init(fullName: teacher.fullName, shortName: teacher.shortName, department: department, faculty: faculty, id: teacher.id)
    }
    
    public var teacher: Teacher {
        return Teacher(fullName: fullName, shortName: shortName, id: id)
    }
    
}