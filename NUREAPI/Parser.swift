//
//  Parser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONParser {
    
    typealias ParseTo
    
    static func parse(fromJSON json: JSON) -> ParseTo?
    
}

