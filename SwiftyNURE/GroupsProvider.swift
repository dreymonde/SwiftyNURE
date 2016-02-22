//
//  GroupsProvider.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 19.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

public protocol GroupsProvider: Receivable {
    
    var completion: ([Group] -> Void) { get }
    var error: (ErrorType -> Void)? { get set }
    
    init(matching filter: String?, _ completion: ([Group] -> Void))
    init(_ completion: ([Group] -> Void))
    
    func execute() -> ()
    
}

public class RemoteGroupsProvider: GroupsProvider {
    
    public let completion: ([Group] -> Void)
    public var error: (ErrorType -> Void)?
    private let filter: String?
    
    public required init(matching filter: String?, _ completion: ([Group] -> Void)) {
        self.filter = filter
        self.completion = completion
    }
    
    public convenience required init(_ completion: ([Group] -> Void)) {
        self.init(matching: nil, completion)
    }
    
    public func execute() {
        var request = JSONRequest(.GET, url: NURE.apiGroupJson) { jsonResponse in
            let json = jsonResponse.data
            var groups = [Group]()
            for faculty in json["university"]["faculties"].arrayValue {
                for direction in faculty["directions"].arrayValue {
                    for groupJSON in direction["groups"].arrayValue {
                        if let group = GroupParser.parse(fromJSON: groupJSON) {
                            if group.name.containsOptionalString(self.filter) && !groups.contains(group) {
                                groups.append(group)
                            }
                        }
                    }
                    for speciality in direction["specialities"].arrayValue {
                        for groupJSON in speciality["groups"].arrayValue {
                            if let group = GroupParser.parse(fromJSON: groupJSON) {
                                if group.name.containsOptionalString(self.filter) && !groups.contains(group) {
                                    groups.append(group)
                                }
                            }
                        }
                    }
                }
            }
            self.completion(groups) 
        }
        request.error = pushError
        request.execute()
    }
    
}