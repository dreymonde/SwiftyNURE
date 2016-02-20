//
//  UniversityProviderTests.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
import Foundation
@testable import NUREAPI
import SwiftyJSON

class UniversityProviderTests: NURETests {

    func testProvide() {
        let expectation = expectationWithDescription("Async univer task")
        let provider = UniversityProvider.Remote() { university in
            print(university.groups.count, university.teachers.count)
            expectation.fulfill()
        }
        provider.error = defaultError
        provider.execute()
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testProvideSaveAndRecovery() {
        let expectation = expectationWithDescription("Async univer task")
        let provider = UniversityProvider.Remote() { university in
            print(university.groups.count, university.teachers.count)
            let univerJson = university.toJSON
            print(univerJson)
            if let newUniver = University(withJSON: univerJson) {
                XCTAssertEqual(newUniver.teachers.count, university.teachers.count)
                XCTAssertEqual(newUniver.groups.count, university.groups.count)
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