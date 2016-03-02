//
//  GroupParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct GroupParser: JSONCISTParser {
        
    static func parse(fromJSON json: JSON) -> Group? {
        guard let id = json["id"] as? Int,
            name = json["name"] as? String else { return nil }
        return Group(name: name, id: id)
    }
    
}