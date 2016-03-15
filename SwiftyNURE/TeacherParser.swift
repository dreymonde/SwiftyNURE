//
//  TeacherParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct TeacherParser: JSONCISTParser {

    static func parse(fromJSON json: JSON) -> Teacher? {
        guard let id = json["id"] as? Int,
            fullName = json["full_name"] as? String,
            shortName = json["short_name"] as? String else { return nil }
        return Teacher(fullName: fullName, shortName: shortName, id: id)
    }

}
