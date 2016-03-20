//
//  TeachersParser.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 02.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct TeachersCISTParser: JSONCISTParser {
    
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
