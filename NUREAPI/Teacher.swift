//
//  Teacher.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

protocol Name {
    var full: String { get }
    var short: String { get }
}

extension Name {
    func isConforming(string: String?) -> Bool {
        return full.containsOptionalString(string) || short.containsOptionalString(string)
    }
}

public protocol TeacherType {
    
    var id: Int { get }
    var shortName: String { get }
    var fullName: String { get }
    
}

public struct Teacher: TeacherType {
    
    public struct Extended: TeacherType {
        
        public struct FacultyName: Name {
            var full: String
            var short: String
        }
        
        public struct DepartmentName: Name {
            var full: String
            var short: String
        }
        
        public var id: Int
        public var shortName: String
        public var fullName: String
        public var department: DepartmentName
        public var faculty: FacultyName
        
        public init(fullName: String, shortName: String, department: DepartmentName, faculty: FacultyName, id: Int) {
            self.id = id
            self.fullName = fullName
            self.shortName = shortName
            self.department = department
            self.faculty = faculty
        }
        
        public init(teacher: Teacher, department: DepartmentName, faculty: FacultyName) {
            self.init(fullName: teacher.fullName, shortName: teacher.shortName, department: department, faculty: faculty, id: teacher.id)
        }
        
        public var teacher: Teacher {
            return Teacher(fullName: fullName, shortName: shortName, id: id)
        }
        
    }
    
    public var id: Int
    public var shortName: String
    public var fullName: String
    
    public init(fullName: String, shortName: String, id: Int) {
        self.id = id
        self.fullName = fullName
        self.shortName = shortName
    }
    
}