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

	var completion: (Received -> Void) { get }
	var error: (ErrorType -> Void)? { get set }

	func execute() -> ()

}

extension Receivable {
    
    var pushError: (ErrorType -> Void) {
        return { error in
            self.error?(error)
        }
    }
    
}

internal protocol RawReceivable: Receivable {
    
    typealias ABodyType = BodyType
    
    var raw: (ABodyType -> Void)? { get set }
    
}