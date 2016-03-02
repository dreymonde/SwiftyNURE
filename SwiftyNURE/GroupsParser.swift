//
//  GroupsParser.swift
//  SwiftyNURE
//
//  Created by Oleg Dreyman on 02.03.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct GroupsCISTParser: JSONCISTParser {
    
    static func parse(fromJSON json: JSON) -> [Group]? {
        
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
    
    internal static func groups(fromJSONArray jsons: [JSON], existingGroups groups: [Group]) -> [Group] {
        var newGroups = [Group]()
        for json in jsons {
            if let group = GroupParser.parse(fromJSON: json) where !groups.contains(group) {
                newGroups.append(group)
            }
        }
        return newGroups
    }
    
}