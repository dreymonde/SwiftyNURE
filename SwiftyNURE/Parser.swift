//
//  Parser.swift
//  NUREAPI
//
//  Created by Oleg Dreyman on 18.02.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

internal protocol JSONCISTParser {

    typealias ParseTo

    static func parse(fromJSON json: JSON) -> ParseTo?

}
