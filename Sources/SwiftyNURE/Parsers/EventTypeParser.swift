//
//  EventTypeParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

struct EventTypeParser: JSONCISTParser {

    static func parse(fromJSON json: JSON) -> EventType? {
        guard let type = json["type"] as? String,
            id = json["id"] as? Int,
            shortName = json["short_name"] as? String,
            fullName = json["full_name"] as? String else { return nil }

        switch type {
        case "lecture":
            return EventType(id: id, shortName: shortName, fullName: fullName, type: .Lecture)
        case "practice":
            return EventType(id: id, shortName: shortName, fullName: fullName, type: .Practice)
        case "laboratory":
            return EventType(id: id, shortName: shortName, fullName: fullName, type: .Lab)
        case "consultation":
            return EventType(id: id, shortName: shortName, fullName: fullName, type: .Consultation)
        case "test":
            return EventType(id: id, shortName: shortName, fullName: fullName, type: .Test)
        case "exam":
            return EventType(id: id, shortName: shortName, fullName: fullName, type: .Exam)
        case "course_work":
            return EventType(id: id, shortName: shortName, fullName: fullName, type: .CourseWork)
        default:
            return nil
        }
    }

}
