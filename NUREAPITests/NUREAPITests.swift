//
//  NUREAPITests.swift
//  NUREAPITests
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import NUREAPI

class NUREAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGroups() {
        let expectation = expectationWithDescription("Async group task")
        let provider = RemoteGroupsProvider() { groups in
            print(groups)
            for group in groups {
                print(group.name)
            }
            expectation.fulfill()
        }
        provider.error = { error in
            print(error)
        }
        provider.execute()
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testJSONRequest() {
        let expectation = expectationWithDescription("Async JSON task")
        let url = NSURL(string: "http://cist.nure.ua/ias/app/tt/P_API_DEPARTMENTS_JSON?p_id_faculty=1")!
        var request = JSONRequest(.GET, url: url) { jsonRespond in
            print(jsonRespond.data)
            expectation.fulfill()
        }
        request.error = { error in
            print(error)
        }
        request.execute()
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
