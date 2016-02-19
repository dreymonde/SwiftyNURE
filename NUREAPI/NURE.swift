//
//  NURE.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

struct NURE {
    
    static let apiRoot = NSURL(string: "http://cist.nure.ua/ias/app/tt/")!
    static let apiGroupJson = NURE.apiRoot.URLByAppendingPathComponent("P_API_GROUP_JSON")

}

extension String {
    
    func containsOptionalString(other: String?) -> Bool {
        if let string = other {
            return self.containsString(string)
        }
        return true
    }
    
}