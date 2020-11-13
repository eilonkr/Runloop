//
//  Environment.swift
//  Sticky Passcode
//
//  Created by Eilon Krauthammer on 13/11/2020.
//

import Foundation

struct Environment {
    static var isDebug: Bool {
        getEnvironmentValue(forKey: "is_debug") == "true"
    }
    
    fileprivate static func getEnvironmentValue(forKey key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
}

