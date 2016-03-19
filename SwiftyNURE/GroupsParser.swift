//
//  GroupsParser.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 02.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct GroupsCISTParser: JSONCISTParser {
    
    static func parse(fromJSON json: JSON) -> [Group]? {
        guard let university = json["university"] as? JSON,
            faculties = university["faculties"] as? [JSON] else {
            return nil
        }
        let directions = faculties.flatMap({ $0["directions"] as? [JSON] }).flatten()
        let specialities = directions.flatMap({ $0["specialities"] as? [JSON] }).flatten()
        let jgroups = Array(directions.flatMap({ $0["groups"] as? [JSON] }).flatten())
            + Array(specialities.flatMap({ $0["groups"] as? [JSON] }).flatten())
        // TODO: Ugly
        let groups = Set(jgroups.flatMap({ GroupParser.parse(fromJSON: $0) }))
        return Array(groups)
    }

    internal static func groups(fromJSONArray jsons: [JSON], existingGroups groups: [Group]) -> [Group] {
        let newGroups = jsons.flatMap { (json: JSON) -> Group? in
            if let group = GroupParser.parse(fromJSON: json) where !groups.contains(group) {
                return group
            }
            return nil
        }
        return newGroups
    }

}
