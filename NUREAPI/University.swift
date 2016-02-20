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

extension University: JSONObject {
    
    public var toJSON: JSON {
        var jTeachers = [JSON]()
        for teacher in teachers {
            let jTeacher = teacher.toJSON
            jTeachers.append(jTeacher)
        }
        var jGroups = [JSON]()
        for group in groups {
            let jGroup = group.toJSON
            jGroups.append(jGroup)
        }
        let uniJson = JSON(["groups": JSON(jGroups), "teachers": JSON(jTeachers)])
        return uniJson
    }
    
    public convenience init?(withJSON json: JSON) {
        var teachers = Array<Teacher.Extended>()
        var groups = [Group]()
        guard let jTeachers = json["teachers"].array, jGroups = json["groups"].array else {
            return nil
        }
        for jTeacher in jTeachers {
            if let teacher = Teacher.Extended(withJSON: jTeacher) {
                teachers.append(teacher)
            }
        }
        for jGroup in jGroups {
            if let group = Group(withJSON: jGroup) {
                groups.append(group)
            }
        }
        self.init(teachers: teachers, groups: groups)
    }
    
}