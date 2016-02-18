//
//  TimetableProvider.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol TimetableProvider: Receivable {
    
	var completion: (Timetable -> Void) { get set }
	var error: (ErrorType -> Void)? { get set }

	init()

    func getTimetable(forGroupID groupId: Int, timeFrom: NSDate, timeTo: NSDate, completion: (Timetable -> Void)?)
    
}

enum ProviderError: ErrorType {
	case CantParseFromJSON
}

class CISTTimetableProvider: TimetableProvider {

	var completion: (Timetable -> Void)
	var error: (ErrorType -> Void)?

	init() {
		self.completion = { _ in
			print("Timetable received")
		}
		self.error = nil
	}

	func getTimetable(forGroupID groupId: Int, timeFrom: NSDate, timeTo: NSDate, completion: (Timetable -> Void)?) {
		self.completion = completion
		var url = //composeURL
		var request = JSONRequest(.GET, url: url) { jsonResponse in
			if let timetable = TimetableParser.parse(fromJSON: jsonResponse.data) {
				completion(timetable)
				return
			} else {
				self.error?(ProviderError.CantParseFromJSON)
			}
		}
		request.error = { error in
			self.error?(error)
		}
	}

}