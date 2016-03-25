//
//  Timetable.swift
//  CocoaNURE
//
//  Created by Oleg Dreyman on 12.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public struct Timetable {

    public let events: [Event]

    public init(events: [Event] = []) {
        self.events = events
    }

    public func eventsForDay(date: NSDate) -> [Event] {
        return events.filter({ NSCalendar.currentCalendar().isDate(date, inSameDayAsDate: $0.startDate) }).sort { $0.number < $1.number }
    }

    public var startDate: NSDate? {
        if !events.isEmpty {
            let minInterval = events.map({ $0.startDate.timeIntervalSince1970 }).minElement()
            guard let interval = minInterval else {
                return nil
            }
            return NSDate(timeIntervalSince1970: interval)
        }
        return nil
    }

    public var endDate: NSDate? {
        if !events.isEmpty {
            guard let maxInterval = events.map({ $0.endDate.timeIntervalSince1970 }).maxElement() else {
                return nil
            }
            return NSDate(timeIntervalSince1970: maxInterval)
        }
        return nil
    }

}
