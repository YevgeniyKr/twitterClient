//
//  NSErrorExtension.swift
//  TwitterClient
//
//  Created by Yevgeniy Knizhnik on 24.11.15.
//  Copyright © 2015 Krosh. All rights reserved.
//

import Foundation

let localDomain = "SuperTwitterClientDomain"

enum ErrorCode: Int {
    case GeneralError = -144
}

extension NSError {
    class func errorWithLocalizedDescription(description: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey:description]
        return NSError(domain: localDomain, code: ErrorCode.GeneralError.rawValue, userInfo: userInfo)
    }
}