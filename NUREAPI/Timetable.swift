//
//  Timetable.swift
//  CocoaNURE
//
//  Created by Oleg Dreyman on 12.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct Timetable {
    
    public var events: [Eventable] = [Eventable]()
    public var teachers: [Teacher] = [Teacher]()
    public var groups: [Group] = [Group]()
    public var subjects: [Subject] = [Subject]()
    public var types: [EventType] = [EventType]()
    
}