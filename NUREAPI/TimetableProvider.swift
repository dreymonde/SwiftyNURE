//
//  TimetableProvider.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol TimetableProviderType: Receivable {
    
	var completion: (Timetable -> Void) { get }
	var error: (ErrorType -> Void)? { get set }

	init(forGroupID groupId: Int, fromDate: NSDate, toDate: NSDate, _ completion: (Timetable -> Void))
	init(forGroupID groupId: Int, completion: (Timetable -> Void))

	func execute() -> ()
    
}

enum ProviderError: ErrorType {
	case CantParseFromJSON
}

public struct TimetableProvider {

    public class Remote: TimetableProviderType {

        public let completion: (Timetable -> Void)
        public var error: (ErrorType -> Void)?
        private let requestURL: NSURL

        public required init(forGroupID groupId: Int, fromDate: NSDate, toDate: NSDate, _ completion: (Timetable -> Void)) {
            self.completion = completion
            let from = UInt64(floor(fromDate.timeIntervalSince1970))
            let to = UInt64(floor(toDate.timeIntervalSince1970))
            self.requestURL = NSURL(string: "P_API_EVENT_JSON?timetable_id=\(groupId)&type_id=1&time_from=\(from)&time_to=\(to)", relativeToURL: NURE.apiRoot)!
        }

        public required init(forGroupID groupId: Int, completion: (Timetable -> Void)) {
            self.completion = completion
            self.requestURL = NSURL(string: "P_API_EVENT_JSON?timetable_id=\(groupId)", relativeToURL: NURE.apiRoot)!
        }

        public func execute() {
            print(requestURL)
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

    public class RawRemote: Remote, RawReceivable {
        
        public var raw: (JSON -> Void)? = nil
        
        public override func execute() {
            var request = JSONRequest(.GET, url: requestURL) { jsonResponse in
                if let timetable = TimetableParser.parse(fromJSON: jsonResponse.data) {
                    self.raw?(jsonResponse.data)
                    self.completion(timetable)
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

}