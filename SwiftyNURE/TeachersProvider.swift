//
//  TeachersProvider.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import EezehRequests

public protocol TeachersProviderType: Receivable {
    
    typealias ATeacher = TeacherType
    
    var completion: ([ATeacher] -> Void) { get }
    var error: (ErrorType -> Void)? { get set }
    
    func execute() -> ()
    
}

public struct TeachersProvider {
    
    public class Remote: TeachersProviderType {
        
        public let completion: ([Teacher.Extended] -> Void)
        public var error: (ErrorType -> Void)?
        private let filter: String?
        
        public init(matching filter: String?, _ completion: ([Teacher.Extended] -> Void)) {
            self.filter = filter
            self.completion = completion
        }
        
        public convenience init(completion: ([Teacher.Extended] -> Void)) {
            self.init(matching: nil, completion)
        }
        
        public func execute() {
            let request = JSONRequest(.GET, url: NURE.apiTeachersJson) { jsonResponse in
                let json = jsonResponse.data
                if let teachers = TeachersCISTParser.parse(fromJSON: json) {
                    self.completion(teachers.filter({ $0.isConforming(toString: self.filter) }))
                    return
                }
                self.error?(RequestError.JsonParseNull)
            }
            request.error = pushError
            request.execute()
        }
    }
    
}

extension Teacher.Extended {
    
    func isConforming(toString filter: String?) -> Bool {
        return fullName.containsOptionalString(filter) || shortName.containsOptionalString(filter) || department.isConforming(filter) || faculty.isConforming(filter)
    }
    
}