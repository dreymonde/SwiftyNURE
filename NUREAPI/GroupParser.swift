//
//  GroupParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GroupParser: JSONParser {
    
    static func parse(fromJSON json: JSON) -> Group? {
        guard let id = json["id"].int, name = json["name"].string else {
            return nil
        }
        return Group(name: name, id: id)
    }
    
}