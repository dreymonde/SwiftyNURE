//
//  TeachersProvider.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

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
            print(NURE.apiTeachersJson)
            var request = JSONRequest(.GET, url: NURE.apiTeachersJson) { jsonResponse in
                let json = jsonResponse.data
                var teachers = Array<Teacher.Extended>()
                for faculty in json["university"]["faculties"].arrayValue {
                    guard let facultyName = faculty["full_name"].string else {
                        print("No faculty name")
                        continue
                    }
                    for department in faculty["departments"].arrayValue {
                        guard let departmentName = department["full_name"].string else {
                            print("No dep name")
                            continue
                        }
                        for teacherJSON in department["teachers"].arrayValue {
                            if let steacher = TeacherParser.parse(fromJSON: teacherJSON) {
                                let teacher = Teacher.Extended(teacher: steacher, department: departmentName, faculty: facultyName)
                                teachers.append(teacher)
                            }
                        }
                    }
                }
                self.completion(teachers)
            }
            request.error = { error in
                self.error?(error)
            }
            request.execute()
        }
    }
    
}