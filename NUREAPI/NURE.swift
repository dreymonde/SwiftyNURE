//
//  NURE.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

struct NURE {
    
    static let apiRoot = NSURL(string: "http://cist.nure.ua/ias/app/tt/")!
    static let apiGroupJson = NURE.apiRoot.URLByAppendingPathComponent("P_API_GROUP_JSON")

}

public protocol GroupsProvider: Receivable {

	var completion: ([Group] -> Void) { get }
	var error: (ErrorType -> Void)? { get set }

	init(completion: ([Group] -> Void))

	func execute() -> ()

}

public class RemoteGroupsProvider: GroupsProvider {

	public let completion: ([Group] -> Void)
	public lazy var error: (ErrorType -> Void)?

	public required init(completion: ([Group] -> Void)) {
		self.completion = completion
	}

	public func execute() {
		var request = JSONRequest(.GET, url: NURE.apiGroupJson) { jsonResponse in
			let json = jsonResponse.data
			var groups = [Group]()
			for faculty in json["university"]["faculties"] {
				for direction in faculty["directions"] {
					for groupJSON in direction["groups"] {
						if let group = GroupParser.parse(withJSON: groupJSON) { groups.append(group) }
					}
					for speciality in direction["specialities"] {
						for groupJSON in speciality["groups"] {
							if let group = GroupParser.parse(withJSON: groupJSON) { groups.append(group) }
						}
					}
				}
			}
			self.completion(groups) 
		}
		request.error = { error in
			self.error?(error)
		}
		request.execute()
	}

}