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
    
    func eventsForDay(date: NSDate) -> [Eventable] {
        return events.filter({ NSCalendar.currentCalendar().isDate(date, inSameDayAsDate: $0.startDate) }).sort{ $0.number < $1.number }
    }
    
    var startDate: NSDate? {
        if events.count > 0 {
            let minInterval = events.map({ $0.startDate.timeIntervalSince1970 }).minElement()
            guard let interval = minInterval else {
                return nil
            }
            return NSDate(timeIntervalSince1970: interval)
        }
        return nil
    }
    
    var endDate: NSDate? {
        if events.count > 0 {
            guard let maxInterval = events.map({ $0.endDate.timeIntervalSince1970 }).maxElement() else {
                return nil
            }
            return NSDate(timeIntervalSince1970: maxInterval)
        }
        return nil
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