//
//  TeacherParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TeacherParser: JSONParser {
    
    static func parse(fromJSON json: JSON) -> Teacher? {
        guard let id = json["id"].int, fullName = json["full_name"].string, shortName = json["short_name"].string else {
            return nil
        }
        return Teacher(fullName: fullName, shortName: shortName, id: id)
    }
    
}