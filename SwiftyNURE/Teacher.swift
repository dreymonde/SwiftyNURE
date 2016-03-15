//
//  Teacher.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol Name {
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
            public let full: String
            public let short: String
        }

        public struct DepartmentName: Name {
            public let full: String
            public let short: String
        }

        public let id: Int
        public let shortName: String
        public let fullName: String
        public let department: DepartmentName
        public let faculty: FacultyName

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

    public let id: Int
    public let shortName: String
    public let fullName: String

    public init(fullName: String, shortName: String, id: Int) {
        self.id = id
        self.fullName = fullName
        self.shortName = shortName
    }

}
