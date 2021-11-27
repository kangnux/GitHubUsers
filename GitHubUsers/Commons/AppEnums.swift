//
//  AppEnums.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import SwiftUI

enum UserDefaultsKeys: String {
    case pinUserList = "pinUserList"
    case pinRepositories = "pinRepositories"
    case searchCount = "searchCount"
    case searchHistory = "searchHistory"
    case gitHubApiToken = "gitHubApiToken"
}

enum UserSortType: String {
    case bestMatch
    case follwoers = "follwoers"
    case repositories = "repositories"
    
    var value: String? {
        switch self {
        case .follwoers, .repositories:
            return self.rawValue
            
        case .bestMatch:
            return nil
        }
    }
}

enum UserOrderType: String {
    case asc = "asc"
    case desc = "desc"
}

enum AcceptType: String {
    case recommend = "application/vnd.github.v3+json"
    case withMatch = "application/vnd.github.v3.text-match+json"
}

enum PinViewTab {
    case user
    case repository
    
    var title: String {
        switch self {
        case .user:
            return localString.user()
        case .repository:
            return localString.repositories()
        }
    }
}

enum ApiType: Int {
    case restApi = 0
    case authApi
    
    var apiUrl: String {
        switch self {
        case .restApi:
            return XcodeConfig.RestApiURL
        case .authApi:
            return XcodeConfig.AuthBaseURL
        }
    }
}

enum ApiKeys: String {
    case token = "token "
    case userAgent = "User-Agent"
    case authorization = "Authorization"
}

enum MainViewTab {
    case user
    case pin
    case profile
    case thank
}

enum ViewLayer {
    case main
    case detail
    case repository
}

enum SearchCount: Int {
    case ten = 10
    case twenty = 20
    case thirty = 30
    case fifty = 50
    
    static func build(_ value: Int) -> SearchCount {
        if let count = SearchCount(rawValue: value) {
            return count
        }
        return .ten
    }
    
    var titleImage: String {
        switch self {
        case .ten:
            return "10.circle"
        case .twenty:
            return "20.circle"
        case .thirty:
            return "30.circle"
        case .fifty:
            return "50.circle"
        }
    }
    
    var titleMessage: String {
        return localString.countTitle(self.rawValue.description)
    }
}
