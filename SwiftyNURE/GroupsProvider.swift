//
//  GroupsProvider.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 19.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import EezehRequests

public protocol GroupsProviderType: Receivable {
    
    var completion: ([Group] -> Void) { get }
    var error: (ErrorType -> Void)? { get set }
    
    init(matching filter: String?, _ completion: ([Group] -> Void))
    init(_ completion: ([Group] -> Void))
    
    func execute() -> ()
    
}

public struct GroupsProvider {
    
    public class Remote: GroupsProviderType {
        
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
                if let groups = GroupsCISTParser.parse(fromJSON: json) {
                    self.completion(groups.filter({ $0.name.containsOptionalString(self.filter) }))
                    return
                }
                self.error?(RequestError.JsonParseNull)
            }
            request.error = pushError
            request.execute()
        }
        
    }
    
}

