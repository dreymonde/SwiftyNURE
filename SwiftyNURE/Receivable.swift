//
//  Receivable.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol Receivable {

	typealias Received
    typealias AnError = ErrorType

	var completion: (Received -> Void) { get }
	var error: (AnError -> Void)? { get set }

	func execute() -> ()

}

extension Receivable {
    
    var pushError: (AnError -> Void) {
        return { error in
            self.error?(error)
        }
    }
    
}