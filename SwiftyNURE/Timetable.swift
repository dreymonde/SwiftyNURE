//
//  Timetable.swift
//  CocoaNURE
//
//  Created by Oleg Dreyman on 12.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Timetable {
    
    public var events: [Eventable] = [Eventable]()
    internal var teachers: [Teacher] = [Teacher]()
    internal var groups: [Group] = [Group]()
    internal var subjects: [Subject] = [Subject]()
    internal var types: [EventType] = [EventType]()
    
    func events(forDay date: NSDate) -> [Eventable] {
        return events.filter({ NSCalendar.currentCalendar().isDate(date, inSameDayAsDate: $0.startDate) }).sort{ $0.number < $1.number }
    }
    
}

extension Timetable: JSONObject {
    
    public var toJSON: JSON {
        let jEvents = events.flatMap{ ($0 as? Event)?.toJSON }
        return JSON(jEvents)
    }

    public init?(withJSON json: JSON) {
        guard let jEvents = json.array else {
            return nil
        }
        print(jEvents.count)
        self.events = jEvents.flatMap{ Event(withJSON: $0) }
    }
    
}