//
//  Group.swift
//  CocoaNURE
//
//  Created by Oleg Dreyman on 12.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol EventProtocol {

    var subject: Subject { get }
    var teachers: [Teacher] { get }
    var auditory: String { get }
    var groups: [Group] { get }
    var type: EventType { get }
    var number: Int { get }

    var startDate: NSDate { get }
    var endDate: NSDate { get }

}

public struct Event: EventProtocol {

    public let number: Int
    public let subject: Subject
    public let teachers: [Teacher]
    public let auditory: String
    public let groups: [Group]
    public let type: EventType

    public let startDate: NSDate
    public let endDate: NSDate

    public init(number: Int, subject: Subject, teachers: [Teacher], auditory: String, groups: [Group], type: EventType, startDate: NSDate, endDate: NSDate) {
        self.number = number
        self.subject = subject
        self.teachers = teachers
        self.auditory = auditory
        self.groups = groups
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
    }

}
