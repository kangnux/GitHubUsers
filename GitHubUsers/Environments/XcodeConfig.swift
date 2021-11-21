//
//  XcodeConfig.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation

struct XcodeConfig {
    static func getInfoKey(_ key: String) -> String {
        guard let value = (Bundle.main.object(forInfoDictionaryKey: key) as? String)?
                .replacingOccurrences(of: "\\", with: "") else {
                    assertionFailure("Failed to \(#function)")
                    return ""
                }
        return value
    }
    
    static var ServerURL: String {
        return getInfoKey("ServerURL")
    }
    
    static var Token: String {
        return getInfoKey("GitHubApiToken")
    }
}
