//
//  Receivable.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

protocol Receivable {

	typealias Received
	typealias AnError: ErrorType

	var completion: (Received -> Void) { get set }
	var error: (AnError -> Void) { get set }

}