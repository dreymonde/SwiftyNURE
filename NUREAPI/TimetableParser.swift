//
//  EventsParser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TimetableParser: JSONParser {
    
    static func parse(fromJSON json: JSON) -> Timetable? {
        guard let jGroups = json["groups"].array, jTeachers = json["teachers"].array, jSubjects = json["subjects"].array, jTypes = json["types"].array, jEvents = json["events"].array else {
            return nil
        }
        var timetable = Timetable()
        timetable.groups = TimetableParser.getGroups(jGroups)
        timetable.teachers = TimetableParser.getTeachers(jTeachers)
        timetable.subjects = TimetableParser.getSubjects(jSubjects)
        timetable.types = TimetableParser.getTypes(jTypes)
        
        for eventJSON in jEvents {
            if let event = TimetableParser.constructEvent(fromJSON: eventJSON, withInformedTimetable: timetable) {
                timetable.events.append(event)
            }
        }
        
        return timetable
    }
    
    static func constructEvent(fromJSON json: JSON, withInformedTimetable timetable: Timetable) -> Event? {
        guard let startInt = json["start_time"].int, endInt = json["end_time"].int, subjectId = json["subject_id"].int, typeId = json["type"].int, pairNumber = json["number_pair"].int, auditory = json["auditory"].string, jTeachers = json["teachers"].arrayObject as? [Int], jGroups = json["groups"].arrayObject as? [Int] else {
            return nil
        }
        
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
    
    static func getGroups(json: [JSON]) -> [Group] {
        var groups = [Group]()
        for groupJSON in json {
            if let group = GroupParser.parse(fromJSON: groupJSON) {
                groups.append(group)
            }
        }
        return groups
    }
    
    static func getTeachers(json: [JSON]) -> [Teacher] {
        var teachers = [Teacher]()
        for teacherJSON in json {
            if let teacher = TeacherParser.parse(fromJSON: teacherJSON) {
                teachers.append(teacher)
            }
        }
        return teachers
    }
    
    static func getSubjects(json: [JSON]) -> [Subject] {
        var subjects = [Subject]()
        for subjectJSON in json {
            if let subject = SubjectParser.parse(fromJSON: subjectJSON) {
                subjects.append(subject)
            }
        }
        return subjects
    }
    
    static func getTypes(json: [JSON]) -> [EventType] {
        var types = [EventType]()
        for typeJSON in json {
            if let type = EventTypeParser.parse(fromJSON: typeJSON) {
                types.append(type)
            }
        }
        return types
    }
    
    static func eventType(fromID id: Int, inJSONArray json: [JSON]) -> EventType? {
        for typeJSON in json {
            if typeJSON["id"].int == id {
                return EventTypeParser.parse(fromJSON: typeJSON)
            }
        }
        return nil
    }
    
}