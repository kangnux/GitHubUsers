//
//  AppState.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var userData = UserData()
    var routing = ViewRouting()
    var system = System()
}

extension AppState {
    struct UserData: Equatable {
        var pinLoginList: [UserEntity.Login] = AppSettingManager.shared.fetchPinUserList().map { $0.login }
        var pinRepositories: [PinRepositoryEntity] = AppSettingManager.shared.fetchPinRepositories()
        var authorizeState: TokenAuthorizeState = .invalid
    }
}

extension AppState {
    struct ViewRouting: Equatable {
        var userList = UserListViewModel.Routing()
        var mainTab = MainViewModel.Routing(tab: .user)
        var pinTab = PinViewModel.Routing(tab: .user)
    }
}

extension AppState {
    struct System: Equatable {
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        let state = AppState()
        return state
    }
}
#endif
