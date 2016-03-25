//
//  NURE.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

internal struct NURE {

    static let apiRoot = NSURL(string: "http://cist.nure.ua/ias/app/tt/")!
    static let apiGroupJson = NURE.apiRoot.URLByAppendingPathComponent("P_API_GROUP_JSON")
    static let apiTeachersJson = NURE.apiRoot.URLByAppendingPathComponent("P_API_PODR_JSON")

}

extension String {

    internal func containsOptionalString(other: String?) -> Bool {
        if let contains = other.map(containsString) {
            return contains
        }
        return true
    }

}
