//
//  AppConstants.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation

typealias API = GitHubApiAPI
typealias AnyDicts = [String: Any]

class ApplicationUtil {
    static var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static var bundle: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
}

class Constants {
    static let pageUpperLimit: Int = 1
    static let maxResultCount: Int = 20
    static let searchKeySuffix = "+in:fullname+type:user"
    static let userDefaultsSuitName = "GitHubUsers"
}
