//
//  TimetableProviderTests.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 19.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import SwiftyNURE

class TimetableProviderTests: NURETests {
    
    let groupID = 4801986

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProvide() {
        let expectation = expectationWithDescription("Async timetable task")
        let provider = TimetableProvider.Remote(forGroupID: groupID) { timetable in
            print(timetable)
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testProvideIncorrect() {
        let expectation = expectationWithDescription("Async timetable task")
        let provider = TimetableProvider.Remote(forGroupID: 15) { timetable in
            XCTFail()
        }
        provider.error = { error in
            print(error)
            expectation.fulfill()
        }
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testProvideThisWeek() {
        let expectation = expectationWithDescription("Async timetable task")
        let today = NSDate()
        let nextWeek = today.dateByAddingTimeInterval(7 * 24 * 60 * 60)
        let provider = TimetableProvider.Remote(forGroupID: groupID, fromDate: today, toDate: nextWeek) { timetable in
            print(timetable)
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testProvideFullAndShowDay() {
        let expectation = expectationWithDescription("Async timetable task")
        let today = NSDate()
        let provider = TimetableProvider.Remote(forGroupID: groupID) { timetable in
            let todayEvents = timetable.events(forDay: today)
            print(todayEvents)
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testRawRemoteProvider() {
        let expectation = expectationWithDescription("Async timetable task")
        let today = NSDate()
        let nextWeek = today.dateByAddingTimeInterval(7 * 24 * 60 * 60)
        let rawProvider = TimetableProvider.RawRemote(forGroupID: groupID, fromDate: today, toDate: nextWeek) { timetable in }
        rawProvider.error = defaultError
        rawProvider.raw = { json in
            print(json)
            if let events = json["events"].array {
                print(events.count)
            }
            expectation.fulfill()
        }
        rawProvider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testProvideAndRestore() {
        let expectation = expectationWithDescription("Async timetable task")
        let today = NSDate()
        let nextWeek = today.dateByAddingTimeInterval(7 * 24 * 60 * 60)
        let provider = TimetableProvider.Remote(forGroupID: groupID, fromDate: today, toDate: nextWeek) { timetable in
            let timetableJson = timetable.toJSON
            if let newTimetable = Timetable(withJSON: timetableJson) {
                XCTAssertEqual(newTimetable.events.count, timetable.events.count)
                XCTAssertEqual(newTimetable.toJSON, timetableJson)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
}
