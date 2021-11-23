//
//  UserDefaultsManager.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation

class UserDefaultsManager: NSObject {
    static var pinUserList: [PinUserEntity]? {
        get { UserDefaults.getPinUserList() }
        set {
            if let list = newValue {
                UserDefaults.setPinUserList(list)
            }
        }
    }
    
    static var pinRepositories: [PinRepositoryEntity]? {
        get { UserDefaults.getPinRepositories() }
        set {
            if let list = newValue {
                UserDefaults.setPinRepositories(list)
            }
        }
    }
    
    static var searchCount: Int? {
        get { UserDefaults.getSearchCount() }
        set {
            if let value = newValue {
                UserDefaults.setSearchCount(value)
            }
        }
    }
    
    static var searchHistory: [TagEntity]? {
        get { UserDefaults.getSearchHistory() }
        set {
            if let list = newValue {
                UserDefaults.setSearchHistory(list)
            }
        }
    }
}

extension UserDefaults {
    fileprivate static func getPinUserList() -> [PinUserEntity]? {
        let userDefaults = UserDefaults.init(suiteName: Constants.userDefaultsSuitName)
        if let data = userDefaults?.data(forKey: UserDefaultsKeys.pinUserList.rawValue) {
            let decoder = JSONDecoder()
            let list = try? decoder.decode([PinUserEntity].self, from: data)
            return list
        }
        
        return nil
    }
    
    fileprivate static func setPinUserList(_ list: [PinUserEntity]) {
        let userDefaults = UserDefaults.init(suiteName: Constants.userDefaultsSuitName)
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(list)
        userDefaults?.set(encodedData, forKey: UserDefaultsKeys.pinUserList.rawValue)
        userDefaults?.synchronize()
    }
    
    fileprivate static func getPinRepositories() -> [PinRepositoryEntity]? {
        let userDefaults = UserDefaults.init(suiteName: Constants.userDefaultsSuitName)
        if let data = userDefaults?.data(forKey: UserDefaultsKeys.pinRepositories.rawValue) {
            let decoder = JSONDecoder()
            let list = try? decoder.decode([PinRepositoryEntity].self, from: data)
            return list
        }
        
        return nil
    }
    
    fileprivate static func setPinRepositories(_ list: [PinRepositoryEntity]) {
        let userDefaults = UserDefaults.init(suiteName: Constants.userDefaultsSuitName)
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(list)
        userDefaults?.set(encodedData, forKey: UserDefaultsKeys.pinRepositories.rawValue)
        userDefaults?.synchronize()
    }
    
    fileprivate static func getSearchCount() -> Int? {
        let userDefaults = UserDefaults.init(suiteName: Constants.userDefaultsSuitName)
        return userDefaults?.integer(forKey: UserDefaultsKeys.searchCount.rawValue)
    }
    
    fileprivate static func setSearchCount(_ count: Int) {
        let userDefaults = UserDefaults.init(suiteName: Constants.userDefaultsSuitName)
        userDefaults?.set(count, forKey: UserDefaultsKeys.searchCount.rawValue)
        userDefaults?.synchronize()
    }
    
    fileprivate static func getSearchHistory() -> [TagEntity]? {
        let userDefaults = UserDefaults.init(suiteName: Constants.userDefaultsSuitName)
        if let data = userDefaults?.data(forKey: UserDefaultsKeys.searchHistory.rawValue) {
            let decoder = JSONDecoder()
            let list = try? decoder.decode([TagEntity].self, from: data)
            return list
        }
        
        return nil
    }
    
    fileprivate static func setSearchHistory(_ list: [TagEntity]) {
        let userDefaults = UserDefaults.init(suiteName: Constants.userDefaultsSuitName)
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(list)
        userDefaults?.set(encodedData, forKey: UserDefaultsKeys.searchHistory.rawValue)
        userDefaults?.synchronize()
    }
}
