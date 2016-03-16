//
//  GroupsParser.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 02.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct GroupsCISTParser: JSONCISTParser {

    /// Deprecated
    static func imperativeParse(fromJSON json: JSON) -> [Group]? {
        var groups = [Group]()
        guard let university = json["university"] as? JSON,
            faculties = university["faculties"] as? [JSON] else { return nil }
        for faculty in faculties {
            if let directions = faculty["directions"] as? [JSON] {
                for direction in directions {
                    // Groups
                    if let jGroups = direction["groups"] as? [JSON] {
                        groups.appendContentsOf(GroupsCISTParser.groups(fromJSONArray: jGroups, existingGroups: groups))
                    }

                    // Specializations
                    if let specialities = direction["specialities"] as? [JSON] {
                        for speciality in specialities {
                            if let jGroups = speciality["groups"] as? [JSON] {
                                groups.appendContentsOf(GroupsCISTParser.groups(fromJSONArray: jGroups, existingGroups: groups))
                            }
                        }
                    }
                }
            }
        }
        return groups

    }
    
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
