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

	init(forGroupID groupId: Int, fromDate: NSDate, toDate: NSDate, completion: (Timetable -> Void))

	func execute() -> ()
    // func getTimetable(forGroupID groupId: Int, timeFrom: NSDate, timeTo: NSDate, completion: (Timetable -> Void)?)
    
}

enum ProviderError: ErrorType {
	case CantParseFromJSON
}

public class CISTTimetableProvider: TimetableProvider {

	public var completion: (Timetable -> Void)
	public lazy var error: (ErrorType -> Void)?
	private requestURL: NSURL

	public required init(forGroupID groupId: Int, fromDate: NSDate, toDate: NSDate, completion: (Timetable -> Void)) {
		self.completion = completion
		let url = NURE.apiRoot.URLByAppendingPathComponent("P_API_EVENT_JSON?timetable_id=\(groupId)&type_id=1&time_from=\(timeFrom.timeIntervalSince1970)&time_to=\(timeTo.timeIntervalSince1970)")
	}

	public func execute() {
		var request = JSONRequest(.GET, url: url) { jsonResponse in
			if let timetable = TimetableParser.parse(fromJSON: jsonResponse.data) {
				self.completion(timetable)
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