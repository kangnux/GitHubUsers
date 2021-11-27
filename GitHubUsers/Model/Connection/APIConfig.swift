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
    static let authState = UUID().uuidString
    static let authRedirectUrl = URL(string: XcodeConfig.RedirectURL)
    static let authAccept = "application/json"
    static let defaultAccept = "application/vnd.github.v3+json"
    static var token = XcodeConfig.GitHubApiToken
    
    static func initAPIConfig() {
        API.requestBuilderFactory = GitHubAlamofireRequestBuilderFactory()
        loadToken()
        updateApiBasePath()
        updateHeaders()
    }
    
    static func updateApiBasePath(_ apiType: ApiType = .restApi) {
        API.basePath = apiType.apiUrl
    }
    
    static func updateToken(_ token: String) {
        AppSettingManager.shared.updateGitHubApiToken(token)
        self.token = token
        updateHeaders()
    }
    
    static func checkRedirectURL(_ url: URL) -> Bool {
        return url.host == authRedirectUrl?.host && url.scheme == authRedirectUrl?.scheme
    }
}

private extension APIConfig {
    static func loadToken() {
        if let tokenItem = AppSettingManager.shared.fetchGitHubApiToken(), !tokenItem.token.isEmpty {
            self.token = tokenItem.token
        }
    }
    
    static func updateHeaders() {
        API.customHeaders = headerRequest()
    }
    
    static func headerRequest() -> [String: String] {
        return [ApiKeys.userAgent.rawValue: fetchUserAgent(),
                ApiKeys.authorization.rawValue: fetchToken()]
    }
    
    static func fetchUserAgent() -> String {
        return "\(ApplicationUtil.bundle)/\(ApplicationUtil.version)(\(UIDevice.current.model):\(UIDevice.current.systemVersion))"
    }
    
    static func fetchToken() -> String {
        return ApiKeys.token.rawValue + token
    }
}
