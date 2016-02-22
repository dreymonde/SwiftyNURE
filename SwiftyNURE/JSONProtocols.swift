//
//  JSONProtocols.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol JSONEncodable: DataEncodable {
    
    var toJSON: JSON { get }
    
}

extension JSONEncodable {
    
    public var toData: NSData? {
        do {
            let data = try self.toJSON.rawData()
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
}

public protocol JSONDecodable: DataDecodable {
    
    init?(withJSON json: JSON)
    
}

extension JSONDecodable {
    
    public init?(withData data: NSData) {
        let json = JSON(data: data)
        self.init(withJSON: json)
    }
    
}

protocol JSONObject: JSONEncodable, JSONDecodable { }

extension Teacher.Extended: JSONObject {
    
    public var toJSON: JSON {
        var teacherJson = JSON(["id": nil, "short_name": nil, "full_name": nil, "faculty_short": nil, "faculty_full": nil, "department_short": nil, "department_full": nil])
        teacherJson["id"].int = id
        teacherJson["short_name"].string = shortName
        teacherJson["full_name"].string = fullName
        teacherJson["faculty_short"].string = faculty.short
        teacherJson["faculty_full"].string = faculty.full
        teacherJson["department_short"].string = department.short
        teacherJson["department_full"].string = department.full
        return teacherJson
    }
    
    public init?(withJSON json: JSON) {
        guard let id = json["id"].int, shortName = json["short_name"].string, fullName = json["full_name"].string, facShort = json["faculty_short"].string, facFull = json["faculty_full"].string, depShort = json["department_short"].string, depFull = json["department_full"].string else {
            return nil
        }
        self.id = id
        self.shortName = shortName
        self.fullName = fullName
        self.faculty = FacultyName(full: facFull, short: facShort)
        self.department = DepartmentName(full: depFull, short: depShort)
    }
    
}

extension Group: JSONObject {
    
    public var toJSON: JSON {
        var groupJson = JSON(["id": nil, "name": nil])
        groupJson["id"].int = id
        groupJson["name"].string = name
        return groupJson
    }
    
    public init?(withJSON json: JSON) {
        guard let id = json["id"].int, name = json["name"].string else {
            return nil
        }
        self.id = id
        self.name = name
    }
    
}

extension Subject: JSONObject {
    
    public var toJSON: JSON {
        var subjectJson = JSON(["id": nil, "name": nil, "short_name": nil])
        subjectJson["id"].int = id
        subjectJson["name"].string = name
        subjectJson["short_name"].string = shortName
        return subjectJson
    }
    
    public init?(withJSON json: JSON) {
        guard let id = json["id"].int, name = json["name"].string, shortName = json["short_name"].string else {
            return nil
        }
        self.id = id
        self.name = name
        self.shortName = shortName
    }
    
}

extension EventType: JSONObject {
    
    public var toJSON: JSON {
        var typeJson = JSON(["id": nil, "full_name": nil, "short_name": nil, "type": nil])
        typeJson["id"].int = id
        typeJson["full_name"].string = fullName
        typeJson["short_name"].string = shortName
        typeJson["type"].string = type.rawValue
        return typeJson
    }

    public init?(withJSON json: JSON) {
        guard let id = json["id"].int, shortName = json["short_name"].string, fullName = json["full_name"].string, rawType = json["type"].string else {
            return nil
        }
        guard let type = Type(rawValue: rawType) else {
            return nil
        }
        self.id = id
        self.fullName = fullName
        self.shortName = shortName
        self.type = type
    }
    
}

extension Teacher: JSONObject {
    
    public var toJSON: JSON {
        var teacherJson = JSON(["id": nil, "full_name": nil, "short_name": nil])
        teacherJson["id"].int = id
        teacherJson["full_name"].string = fullName
        teacherJson["short_name"].string = shortName
        return teacherJson
    }
    
    public init?(withJSON json: JSON) {
        guard let id = json["id"].int, shortName = json["short_name"].string, fullName = json["full_name"].string else {
            return nil
        }
        self.id = id
        self.shortName = shortName
        self.fullName = fullName
    }
    
}

extension Event: JSONObject {
    
    public var toJSON: JSON {
        var eventJson = JSON(["number": nil, "subject": nil, "teachers": nil, "auditory": nil, "groups": nil, "type": nil, "time": nil])
        eventJson["number"].int = number
        eventJson["subject"] = subject.toJSON
        eventJson["teachers"] = JSON(teachers.map({ $0.toJSON }))
        eventJson["auditory"].string = auditory
        eventJson["groups"] = JSON(groups.map({ $0.toJSON }))
        eventJson["type"] = type.toJSON
        eventJson["time"] = JSON(["start": nil, "end": nil])
        eventJson["time"]["start"].uInt64 = UInt64(floor(startDate.timeIntervalSince1970))
        eventJson["time"]["end"].uInt64 = UInt64(floor(endDate.timeIntervalSince1970))
        return eventJson
    }
    
    public init?(withJSON json: JSON) {
        guard let number = json["number"].int, jTeachers = json["teachers"].array, auditory = json["auditory"].string, jGroups = json["groups"].array, startDateInterval = json["time"]["start"].uInt64, endDateInterval = json["time"]["end"].uInt64 else {
            return nil
        }
        guard let subject = Subject(withJSON: json["subject"]) else {
            return nil
        }
        guard let type = EventType(withJSON: json["type"]) else {
            return nil
        }
        self.number = number
        self.subject = subject
        self.teachers = jTeachers.flatMap{ Teacher(withJSON: $0) }
        self.auditory = auditory
        self.groups = jGroups.flatMap{ Group(withJSON: $0) }
        self.type = type
        self.startDate = NSDate(timeIntervalSince1970: Double(startDateInterval))
        self.endDate = NSDate(timeIntervalSince1970: Double(endDateInterval))
    }
    
}

