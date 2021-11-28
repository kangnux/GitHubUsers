//
//  AppSettingManager.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation

class AppSettingManager: NSObject {
    static let shared = AppSettingManager()
    static var searchCount = SearchCount.build(UserDefaultsManager.searchCount ?? SearchCount.ten.rawValue)
    
    func fetchPinUserList() -> [PinUserEntity] {
        if let list = UserDefaultsManager.pinUserList {
            return list
        }
        
        return []
    }
    
    func updatePinUserStatus(_ isPin: Bool, _ login: String, _ avatarUrl: String) {
        var newList:[PinUserEntity] = []
        if let list = UserDefaultsManager.pinUserList {
            newList = list
        }
        
        let index = newList.firstIndex(where: { $0.login == login })
        
        if (isPin && index == nil) {
            let pinUser = PinUserEntity(login: login, avatarUrl: avatarUrl, date: Date().description)
            newList.append(pinUser)
            UserDefaultsManager.pinUserList = newList
        } else if (isPin == false && index != nil) {
            if let index = newList.firstIndex(where: { $0.login == login }) {
                newList.remove(at: index)
                UserDefaultsManager.pinUserList = newList
            }
        }
    }
    
    func fetchPinRepositories() -> [PinRepositoryEntity] {
        if let list = UserDefaultsManager.pinRepositories {
            return list
        }
        
        return []
    }
    
    func updatePinRepositories(_ isPin: Bool, _ owner: String, _ repo: String) {
        var newList:[PinRepositoryEntity] = []
        if let list = UserDefaultsManager.pinRepositories {
            newList = list
        }
        
        let index = newList.firstIndex(where: { $0.owner == owner && $0.repo == repo })
        
        if (isPin && index == nil) {
            let pinRepository = PinRepositoryEntity(owner: owner, repo: repo, date: Date().description)
            newList.append(pinRepository)
            UserDefaultsManager.pinRepositories = newList
        } else if (isPin == false && index != nil) {
            if let index = newList.firstIndex(where: { $0.owner == owner && $0.repo == repo }) {
                newList.remove(at: index)
                UserDefaultsManager.pinRepositories = newList
            }
        }
    }
    
    func fetchGitHubApiToken() -> TokenEntity? {
        return UserDefaultsManager.gitHubApiToken
    }
    
    func updateGitHubApiToken(_ token: String) {
        let tokenItem = TokenEntity(token: token)
        UserDefaultsManager.gitHubApiToken = tokenItem
    }
    
    func fetchSearchCount() -> Int {
        if let value = UserDefaultsManager.searchCount, value > 0 {
            return value
        } else {
            let defaultValue = SearchCount.ten.rawValue
            UserDefaultsManager.searchCount = defaultValue
            return defaultValue
        }
    }
    
    func updateSearchCount(_ count: Int) {
        UserDefaultsManager.searchCount = count
        AppSettingManager.searchCount = SearchCount.build(UserDefaultsManager.searchCount ?? SearchCount.ten.rawValue)
    }
    
    func fetchSearchHistory() -> [TagEntity] {
        if let list = UserDefaultsManager.searchHistory {
            return list
        }
        
        return []
    }
    
    func updateSearchHistory(_ list: [TagEntity])  {
        UserDefaultsManager.searchHistory = list
    }
    
}
