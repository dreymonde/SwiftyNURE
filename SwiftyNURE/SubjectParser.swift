//
//  SubjectParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SubjectParser: JSONParser {
    
    static func parse(fromJSON json: JSON) -> Subject? {
        guard let name = json["title"].string, shortName = json["brief"].string, identifier = json["id"].int else {
            return nil
        }
        return Subject(name: name, shortName: shortName, id: identifier)
    }
    
}