//
//  TeachersProviderTests.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import SwiftyNURE

class TeachersProviderTests: NURETests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProvide() {
        let expectation = expectationWithDescription("Async teacher task")
        let provider = TeachersProvider.Remote() { teachers in
            for teacher in teachers {
                print("\(teacher.fullName) | \(teacher.department.short) | \(teacher.faculty.short)")
            }
            XCTAssertGreaterThanOrEqual(teachers.count, 800)
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testFilteredNameProvide() {
        let expectation = expectationWithDescription("Async teacher task")
        let provider = TeachersProvider.Remote(matching: "Каук") { teachers in
            for teacher in teachers {
                print("\(teacher.fullName) | \(teacher.department.short) | \(teacher.faculty.short)")
            }
            XCTAssertGreaterThanOrEqual(teachers.count, 1)
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testFilteredDepProvide() {
        let expectation = expectationWithDescription("Async teacher task")
        let provider = TeachersProvider.Remote(matching: "Кафедра програмної інженерії") { teachers in
            for teacher in teachers {
                print("\(teacher.fullName) | \(teacher.department.short) | \(teacher.faculty.short)")
            }
            print(teachers.count)
            XCTAssertGreaterThanOrEqual(teachers.count, 1)
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
}
