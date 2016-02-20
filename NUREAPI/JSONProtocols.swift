//
//  JSONProtocols.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONEncodable {
    
    var toJSON: JSON { get }
    
}

protocol JSONDecodable {
    
    init?(withJSON json: JSON)
    
}

protocol JSONObject: JSONEncodable, JSONDecodable { }

extension Teacher.Extended: JSONObject {
    
    var toJSON: JSON {
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
    
    init?(withJSON json: JSON) {
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
    
    var toJSON: JSON {
        var groupJson = JSON(["id": nil, "name": nil])
        groupJson["id"].int = id
        groupJson["name"].string = name
        return groupJson
    }
    
    init?(withJSON json: JSON) {
        guard let id = json["id"].int, name = json["name"].string else {
            return nil
        }
        self.id = id
        self.name = name
    }
    
}