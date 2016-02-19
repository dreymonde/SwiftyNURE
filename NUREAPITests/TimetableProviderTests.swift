//
//  TimetableProviderTests.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 19.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import NUREAPI

class TimetableProviderTests: XCTestCase {

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
        let provider = RemoteTimetableProvider(forGroupID: 4801986) { timetable in
            print(timetable)
            expectation.fulfill()
        }
        provider.error = { error in
            print(error)
            XCTFail()
        }
        provider.execute()
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testProvideIncorrect() {
        let expectation = expectationWithDescription("Async timetable task")
        let provider = RemoteTimetableProvider(forGroupID: 15) { timetable in
            XCTFail()
        }
        provider.error = { error in
            print(error)
            expectation.fulfill()
        }
        provider.execute()
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testProvideThisWeek() {
        let expectation = expectationWithDescription("Async timetable task")
        let today = NSDate()
        let nextWeek = today.dateByAddingTimeInterval(7 * 24 * 12 * 60 * 60)
        let provider = RemoteTimetableProvider(forGroupID: 4801986, fromDate: today, toDate: nextWeek) { timetable in
            print(timetable)
            expectation.fulfill()
        }
        provider.error = { error in
            print(error)
            XCTFail()
        }
        provider.execute()
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testProvideFullAndShowDay() {
        let expectation = expectationWithDescription("Async timetable task")
        let today = NSDate()
        let provider = RemoteTimetableProvider(forGroupID: 4801986) { timetable in
            let todayEvents = timetable.events(forDay: today)
            print(todayEvents)
            expectation.fulfill()
        }
        provider.error = { error in
            print(error)
        }
        provider.execute()
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
}
