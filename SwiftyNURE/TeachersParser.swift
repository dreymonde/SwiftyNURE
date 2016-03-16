//
//  TeachersParser.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 02.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct TeachersCISTParser: JSONCISTParser {

    static func imperativeParse(fromJSON json: JSON) -> [Teacher.Extended]? {

        var teachers = Array<Teacher.Extended>()
        guard let university = json["university"] as? JSON,
            faculties = university["faculties"] as? [JSON] else { return nil }
        for faculty in faculties {
            guard let facultyFull = faculty["full_name"] as? String,
                facultyShort = faculty["short_name"] as? String else {
                    print("No faculty name")
                    continue
            }
            let facultyName = FacultyName(full: facultyFull, short: facultyShort)
            guard let departments = faculty["departments"] as? [JSON] else { continue }
            for department in departments {
                guard let depFull = department["full_name"] as? String,
                    depShort = department["short_name"] as? String else {
                        print("No department name")
                        continue
                }
                let departmentName = DepartmentName(full: depFull, short: depShort)
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
    
    static func parse(fromJSON json: JSON) -> [Teacher.Extended]? {
        guard let university = json["university"] as? JSON,
            faculties = university["faculties"] as? [JSON] else {
            return nil
        }
        typealias DepartmentInfo = (department: JSON, faculty: FacultyName)
        typealias TeacherInfo = (teacher: JSON, faculty: FacultyName, department: DepartmentName)
        let departments = faculties.flatMap { faculty -> [DepartmentInfo]? in
            guard let full = faculty["full_name"] as? String,
                    short = faculty["short_name"] as? String else {
                    return nil
            }
            let name = FacultyName(full: full, short: short)
            let facultyDepartments = faculty["departments"] as? [JSON]
            return facultyDepartments?.flatMap { DepartmentInfo(department: $0, faculty: name) }
        }.flatten()
        let jteachers = departments.flatMap { departmentInfo -> [TeacherInfo]? in
            guard let full = departmentInfo.department["full_name"] as? String,
                short = departmentInfo.department["short_name"] as? String else {
                    return nil
            }
            let departmentName = DepartmentName(full: full, short: short)
            let departmentTeachers = departmentInfo.department["teachers"] as? [JSON]
            return departmentTeachers?.flatMap { TeacherInfo(teacher: $0,
                faculty: departmentInfo.faculty,
                department: departmentName) }
        }.flatten()
        let teachers = jteachers.flatMap { jteacher -> Teacher.Extended? in
            let regTeacher = TeacherParser.parse(fromJSON: jteacher.teacher)
            return regTeacher.flatMap { Teacher.Extended(teacher: $0, department: jteacher.department, faculty: jteacher.faculty) }
        }
        return teachers
    }

}
