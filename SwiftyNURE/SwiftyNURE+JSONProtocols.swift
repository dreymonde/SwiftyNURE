//
//  SwiftyNURE+JSONProtocols.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 02.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

extension Group: JSONObject {

    public func toJSON() -> JSON {
        let jsonDict: [String: AnyObject] = [
            "id": id,
            "name": name
        ]
        return jsonDict
    }

    public init?(withJSON json: JSON) {
        guard let id = json["id"] as? Int,
            name = json["name"] as? String
            else { return nil }
        self.init(name: name, id: id)
    }

}

extension Subject: JSONObject {

    public func toJSON() -> JSON {
        let jsonDict: JSON = [
            "id": id,
            "name": name,
            "short_name": shortName
        ]
        return jsonDict
    }

    public init?(withJSON json: JSON) {
        guard let id = json["id"] as? Int,
            name = json["name"] as? String,
            shortName = json["short_name"] as? String
            else { return nil }
        self.init(name: name, shortName: shortName, id: id)
    }

}

extension Teacher: JSONObject {

    public func toJSON() -> JSON {
        let jsonDict: JSON = [
            "id": id,
            "full_name": fullName,
            "short_name": shortName
        ]
        return jsonDict
    }

    public init?(withJSON json: JSON) {
        guard let id = json["id"] as? Int,
            fullName = json["full_name"] as? String,
            shortName = json["short_name"] as? String
            else { return nil }
        self.init(fullName: fullName, shortName: shortName, id: id)
    }

}

extension Teacher.Extended: JSONObject {

    public func toJSON() -> JSON {
        var jsonDict = self.teacher.toJSON()
        jsonDict["faculty_full_name"] = faculty.full
        jsonDict["faculty_short_name"] = faculty.short
        jsonDict["department_full_name"] = department.full
        jsonDict["department_short_name"] = department.short
        return jsonDict
    }

    public init?(withJSON json: JSON) {
        guard let teacher = Teacher(withJSON: json),
            facultyFull = json["faculty_full_name"] as? String,
            facultyShort = json["faculty_short_name"] as? String,
            departmentFull = json["department_full_name"] as? String,
            departmentShort = json["department_short_name"] as? String
            else { return nil }
        let facultyName = FacultyName(full: facultyFull, short: facultyShort)
        let departmentName = DepartmentName(full: departmentFull, short: departmentShort)
        self.init(teacher: teacher, department: departmentName, faculty: facultyName)
    }

}

extension EventType: JSONObject {

    public func toJSON() -> JSON {
        let jsonDict: JSON = [
            "id": id,
            "short_name": shortName,
            "full_name": fullName,
            "type": type.rawValue
        ]
        return jsonDict
    }

    public init?(withJSON json: JSON) {
        guard let typeString = json["type"] as? String, type = Type(rawValue: typeString),
            id = json["id"] as? Int,
            shortName = json["short_name"] as? String,
            fullName = json["full_name"] as? String
            else { return nil }
        self.init(id: id, shortName: shortName, fullName: fullName, type: type)
    }

}

extension Event: JSONObject {

    public func toJSON() -> JSON {
        let jsonDict: JSON = [
            "number": number,
            "subject": subject.toJSON(),
            "teachers": teachers.map { $0.toJSON() },
            "auditory": auditory,
            "groups": groups.map { $0.toJSON() },
            "type": type.toJSON(),
            "date": [
                "start": Int(startDate.timeIntervalSince1970),
                "end": Int(endDate.timeIntervalSince1970)
            ]
        ]
        return jsonDict
    }

    public init?(withJSON json: JSON) {
        guard let number = json["number"] as? Int,
            jSubject = json["subject"] as? JSON, subject = Subject(withJSON: jSubject),
            jTeachers = json["teachers"] as? [JSON],
            auditory = json["auditory"] as? String,
            jGroups = json["groups"] as? [JSON],
            jType = json["type"] as? JSON, type = EventType(withJSON: jType),
            date = json["date"] as? JSON,
            startDateInterval = date["start"] as? Int,
            endDateInterval = date["end"] as? Int
            else { return nil }
        let teachers = jTeachers.flatMap({ Teacher(withJSON: $0) })
        let groups = jGroups.flatMap({ Group(withJSON: $0) })
        let startDate = NSDate(timeIntervalSince1970: Double(startDateInterval))
        let endDate = NSDate(timeIntervalSince1970: Double(endDateInterval))
        self.init(number: number, subject: subject, teachers: teachers, auditory: auditory, groups: groups, type: type, startDate: startDate, endDate: endDate)
    }

}

extension Timetable: JSONObject {

    public func toJSON() -> JSON {
        let jsonDict: JSON = [
            "events": events.flatMap({ $0.toJSON() })
        ]
        return jsonDict
    }

    public init?(withJSON json: JSON) {
        guard let jEvents = json["events"] as? [JSON] else { return nil }
        let events = jEvents.flatMap { Event(withJSON: $0) }
        self.init(events: events)
    }

}

extension University: JSONObject {

    public func toJSON() -> JSON {
        let jsonDict: JSON = [
            "teachers": teachers.map({ $0.toJSON() }),
            "groups": groups.map({ $0.toJSON() })
        ]
        return jsonDict
    }

    public init?(withJSON json: JSON) {
        guard let jTeachers = json["teachers"] as? [JSON],
            jGroups = json["groups"] as? [JSON]
            else { return nil }
        let teachers = jTeachers.flatMap({ Teacher.Extended(withJSON: $0) })
        let groups = jGroups.flatMap({ Group(withJSON: $0) })
        self.init(teachers: teachers, groups: groups)
    }

}
