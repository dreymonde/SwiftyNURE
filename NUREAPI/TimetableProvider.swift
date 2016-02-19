//
//  TimetableProvider.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol TimetableProvider: Receivable {
    
	var completion: (Timetable -> Void) { get }
	var error: (ErrorType -> Void)? { get set }

	init(forGroupID groupId: Int, fromDate: NSDate, toDate: NSDate, completion: (Timetable -> Void))
	init(forGroupID groupId: Int, completion: (Timetable -> Void))

	func execute() -> ()
    
}

enum ProviderError: ErrorType {
	case CantParseFromJSON
}

public class RemoteTimetableProvider: TimetableProvider {

	public let completion: (Timetable -> Void)
	public var error: (ErrorType -> Void)?
	private let requestURL: NSURL

	public required init(forGroupID groupId: Int, fromDate: NSDate, toDate: NSDate, completion: (Timetable -> Void)) {
		self.completion = completion
		requestURL = NURE.apiRoot.URLByAppendingPathComponent("P_API_EVENT_JSON?timetable_id=\(groupId)&type_id=1&time_from=\(fromDate.timeIntervalSince1970)&time_to=\(toDate.timeIntervalSince1970)")
	}

	public required init(forGroupID groupId: Int, completion: (Timetable -> Void)) {
		self.completion = completion
		requestURL = NURE.apiRoot.URLByAppendingPathComponent("P_API_EVENT_JSON?timetable_id=\(groupId)")
	}

	public func execute() {
		var request = JSONRequest(.GET, url: requestURL) { jsonResponse in
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
		request.execute()
	}

}