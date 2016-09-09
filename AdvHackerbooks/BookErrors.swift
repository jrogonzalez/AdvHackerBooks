//
//  BookErrors.swift
//  HackerBooks
//
//  Created by jro on 04/07/16.
//  Copyright © 2016 jro. All rights reserved.
//

import Foundation

//MARK: JSON Errors
enum BookErrors : Error{
    case wrongJSONFormat
    case nilJSONObject
    case jsonParsingError
    case initModelError
    case resourceURLNotReachable
    case bookNotFound
    case imageNotFound
}
