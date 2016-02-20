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

public protocol RawReceivable: Receivable {
    
    typealias ABodyType = BodyType
    
    var raw: (ABodyType -> Void)? { get set }
    
}