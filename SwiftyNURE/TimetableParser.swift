//
//  EventsParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

private struct TimetableInfo {
    let teachers: [Teacher]
    let groups: [Group]
    let subjects: [Subject]
    let types: [EventType]
}

internal struct TimetableParser: JSONCISTParser {

    internal static func parse(fromJSON json: JSON) -> Timetable? {
        guard let jGroups = json["groups"] as? [JSON],
            jTeachers = json["teachers"] as? [JSON],
            jSubjects = json["subjects"] as? [JSON],
            jTypes = json["types"] as? [JSON],
            jEvents = json["events"] as? [JSON] else { return nil }
        var events = [Event]()
        let timetableInfo = TimetableParser.constructTimetableInfo(jTeachers: jTeachers, jGroups: jGroups, jSubjects: jSubjects, jTypes: jTypes)
        for eventJSON in jEvents {
            if let event = TimetableParser.constructEvent(fromJSON: eventJSON, withInformedTimetableInfo: timetableInfo) {
                events.append(event)
            }
        }

        let timetable = Timetable(events: events)
        return timetable
    }

    private static func constructEvent(fromJSON json: JSON, withInformedTimetableInfo timetable: TimetableInfo) -> Event? {
        guard let startInt = json["start_time"] as? Int,
            endInt = json["end_time"] as? Int,
            subjectId = json["subject_id"] as? Int,
            typeId = json["type"] as? Int,
            pairNumber = json["number_pair"] as? Int,
            auditory = json["auditory"] as? String,
            jTeachers = json["teachers"] as? [Int],
            jGroups = json["groups"] as? [Int] else { return nil }

        let startDate = DateParser.parse(fromInt: startInt)
        let endDate = DateParser.parse(fromInt: endInt)
        guard let subject = timetable.subjects.filter({ $0.id == subjectId }).first else {
            return nil
        }
        let teachers = timetable.teachers.filter { jTeachers.contains($0.id) }
        let groups = timetable.groups.filter { jGroups.contains($0.id) }
        guard let type = timetable.types.filter({ $0.id == typeId }).first else {
            return nil
        }

        let event = Event(number: pairNumber, subject: subject, teachers: teachers, auditory: auditory, groups: groups, type: type, startDate: startDate, endDate: endDate)
        return event

    }
    
    private static func constructTimetableInfo(jTeachers jTeachers: [JSON], jGroups: [JSON], jSubjects: [JSON], jTypes: [JSON]) -> TimetableInfo {
        return TimetableInfo(teachers: TimetableParser.getTeachers(jTeachers),
            groups: TimetableParser.getGroups(jGroups),
            subjects: TimetableParser.getSubjects(jSubjects),
            types: TimetableParser.getTypes(jTypes)
        )
    }

    internal static func getGroups(jsons: [JSON]) -> [Group] {
        var groups = [Group]()
        for groupJSON in jsons {
            if let group = GroupParser.parse(fromJSON: groupJSON) {
                groups.append(group)
            }
        }
        return groups
    }

    internal static func getTeachers(jsons: [JSON]) -> [Teacher] {
        var teachers = [Teacher]()
        for teacherJSON in jsons {
            if let teacher = TeacherParser.parse(fromJSON: teacherJSON) {
                teachers.append(teacher)
            }
        }
        return teachers
    }

    internal static func getSubjects(json: [JSON]) -> [Subject] {
        var subjects = [Subject]()
        for subjectJSON in json {
            if let subject = SubjectParser.parse(fromJSON: subjectJSON) {
                subjects.append(subject)
            }
        }
        return subjects
    }

    internal static func getTypes(json: [JSON]) -> [EventType] {
        var types = [EventType]()
        for typeJSON in json {
            if let type = EventTypeParser.parse(fromJSON: typeJSON) {
                types.append(type)
            }
        }
        return types
    }

    internal static func eventType(fromID id: Int, inJSONArray json: [JSON]) -> EventType? {
        for typeJSON in json {
            if let typeID = typeJSON["id"] as? Int where typeID == id {
                return EventTypeParser.parse(fromJSON: typeJSON)
            }
        }
        return nil
    }

}
