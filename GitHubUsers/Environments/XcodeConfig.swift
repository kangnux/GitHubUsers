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
    
    static var RestApiURL: String {
        return getInfoKey("RestApiURL")
    }
    
    static var AuthBaseURL: String {
        return getInfoKey("AuthBaseURL")
    }
  
    static var RedirectURL: String {
        return getInfoKey("RedirectURL")
    }
    
    static var ClientID: String {
        return getInfoKey("ClientID")
    }
    
    static var ClientServer: String {
        return getInfoKey("ClientServer")
    }
    
    static var GitHubApiToken: String {
        return getInfoKey("GitHubApiToken")
    }
}
