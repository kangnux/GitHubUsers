//
//  APIConfig.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import Alamofire
import UIKit

class APIConfig {
    static let retryCount = 5
    static let retryTime = 500.0
    
    static func initAPIConfig() {
        API.requestBuilderFactory = GitHubAlamofireRequestBuilderFactory()
        API.customHeaders = headerRequest()
        updateApiBasePath()
    }
    
    static func updateApiBasePath() {
        API.basePath = XcodeConfig.ServerURL
    }
    
    static func fetchUserAgent() -> String {
        return "\(ApplicationUtil.bundle)/\(ApplicationUtil.version)(\(UIDevice.current.model):\(UIDevice.current.systemVersion))"
    }
    
    static func fetchToken() -> String {
        return "token " + XcodeConfig.Token
    }
    
    static func headerRequest() -> [String: String] {
        return ["User-Agent": fetchUserAgent(),
                "Authorization": fetchToken()]
    }
}
