//
//  TeachersParser.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 02.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct TeachersCISTParser: JSONCISTParser {
    
    static func parse(fromJSON json: JSON) -> [Teacher.Extended]? {
        
        var teachers = Array<Teacher.Extended>()
        guard let university = json["university"] as? JSON,
            faculties = university["faculties"] as? [JSON] else { return nil }
        for faculty in faculties {
            guard let facultyFull = faculty["full_name"] as? String,
                facultyShort = faculty["short_name"] as? String else {
                    print("No faculty name")
                    continue
            }
            let facultyName = Teacher.Extended.FacultyName(full: facultyFull, short: facultyShort)
            guard let departments = faculty["departments"] as? [JSON] else { continue }
            for department in departments {
                guard let depFull = department["full_name"] as? String,
                    depShort = department["short_name"] as? String else {
                        print("No department name")
                        continue
                }
                let departmentName = Teacher.Extended.DepartmentName(full: depFull, short: depShort)
                guard let jTeachers = department["teachers"] as? [JSON] else { continue }
                for jTeacher in jTeachers {
                    if let stTeacher = TeacherParser.parse(fromJSON: jTeacher) {
                        let teacher = Teacher.Extended(teacher: stTeacher, department: departmentName, faculty: facultyName)
                        teachers.append(teacher)
                    }
                }
            }
        }
        return teachers
        
    }
    
}