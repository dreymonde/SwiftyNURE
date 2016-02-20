//
//  NURETests.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 20.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest

class NURETests: XCTestCase {

    let defaultError: (ErrorType -> Void) = { error in
        print(error)
        XCTFail()
    }
    
    let timeout = 5.0

}
