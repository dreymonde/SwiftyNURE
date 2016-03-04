//
//  EventTypeDesc.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct EventType {
    
    public init(id: Int, shortName: String, fullName: String, type: Type) {
        self.id = id
        self.shortName = shortName
        self.fullName = fullName
        self.type = type
    }
    
    public let id: Int
    public let shortName: String
    public let fullName: String
    public let type: Type
    
}

public enum Type: String {
    case Lecture
    case Practice
    case Lab
    case Consultation
    case Test
    case Exam
    case CourseWork
}