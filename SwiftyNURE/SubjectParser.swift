//
//  SubjectParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct SubjectParser: JSONCISTParser {

    static func parse(fromJSON json: JSON) -> Subject? {
        guard let name = json["title"] as? String,
            shortName = json["brief"] as? String,
            identifier = json["id"] as? Int else { return nil }
        return Subject(name: name, shortName: shortName, id: identifier)
    }

}
