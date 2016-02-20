//
//  TeachersProviderTests.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import NUREAPI

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
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
}
