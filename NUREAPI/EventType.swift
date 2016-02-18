//
//  EventTypeDesc.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct EventType {
    
    public enum Type {
        case Lecture
        case Practice
        case Lab
        case Consultation
        case Test
        case Exam
        case CourseWork
    }
    
    public init(id: Int, shortName: String, fullName: String, type: Type) {
        self.id = id
        self.shortName = shortName
        self.fullName = fullName
        self.type = type
    }
    
    public var id: Int
    public var shortName: String
    public var fullName: String
    public var type: Type
    
}