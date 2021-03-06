//
//  GroupsProviderTests.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 19.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import SwiftyNURE

class GroupsProviderTests: NURETests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGroups() {
        let expectation = expectationWithDescription("Async group task")
        let provider = GroupsProvider.Remote() { groups in
            XCTAssertGreaterThan(groups.count, 1000)
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }

    func testPartGroups() {
        let expectation = expectationWithDescription("Async group task")
        let _ = GroupsProvider.Remote(matching: "14-1") { groups in
            groups.forEach { group in
                print(group.name)
                if !group.name.containsString("14-1") {
                    XCTFail("It needs to contain 14-1")
                    return
                }
            }
            expectation.fulfill()
            }.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }

}
