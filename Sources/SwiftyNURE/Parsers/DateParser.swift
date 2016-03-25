//
//  DateParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

struct DateParser {

    static func parse(fromInt int: Int) -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(int))
    }

}
