//
//  UniversityProvider.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import EezehRequests

public protocol UniversityProviderType: Receivable {

    var completion: (University -> Void) { get }
    var error: (ErrorType -> Void)? { get set }

    func execute() -> Void

}

public struct UniversityProvider {

    public class Remote: UniversityProviderType {

        public let completion: (University -> Void)
        public var error: (ErrorType -> Void)?

        public init(_ completion: (University -> Void)) {
            self.completion = completion
        }

        public func execute() {
            var cGroups: [Group]?
            var cTeachers: Array<Teacher.Extended>?

            let teachersProvider = TeachersProvider.Remote() { teachers in
                dispatch_async(dispatch_get_main_queue()) {
                    cTeachers = teachers
                    if let groups = cGroups, teachers = cTeachers {
                        let university = University(teachers: teachers, groups: groups)
                        self.completion(university)
                    }
                }
            }
            teachersProvider.error = pushError
            teachersProvider.execute()

            let groupsProvider = GroupsProvider.Remote() { groups in
                dispatch_async(dispatch_get_main_queue()) {
                    cGroups = groups
                    if let teachers = cTeachers, groups = cGroups {
                        let university = University(teachers: teachers, groups: groups)
                        self.completion(university)
                    }
                }
            }
            groupsProvider.error = pushError
            groupsProvider.execute()
        }

    }

}
