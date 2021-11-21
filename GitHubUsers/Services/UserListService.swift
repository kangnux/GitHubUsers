//
//  UserListService.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import RxSwift

protocol UserListService {
    func fetchUserList(_ request: UserListRequest) -> Single<UserListResponse>
}

struct RealUserListService: UserListService {
    let repository: UserListRepository
    let appState: Store<AppState>
    
    init(repository: UserListRepository, appState: Store<AppState>) {
        self.repository = repository
        self.appState = appState
    }
    
    func fetchUserList(_ request: UserListRequest) -> Single<UserListResponse> {
        return repository.fetchUserList(request).map {
            return try UserListResponse($0)
        }
    }
}

struct StubUserListService: UserListService {
    func fetchUserList(_ request: UserListRequest) -> Single<UserListResponse> {
        let user = UserEntity(
            login: "octocat",
            name: "The Octocat",
            avatarUrl: "https://avatars.githubusercontent.com/u/583231?v=4",
            url: "https://api.github.com/users/octocat",
            htmlUrl: "https://github.com/octocat",
            location: "San Francisco",
            email: "kangnux@outlook.com",
            bio: "Test bio",
            followers: "10",
            following: "1.0K")
        let value = UserListResponse(list: [user])
        return SingleResponse<UserListResponse>.success(value).Event
    }
}
