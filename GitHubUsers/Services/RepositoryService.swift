//
//  RepositoryService.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/17.
//

import Foundation
import RxSwift

protocol RepositoryService {
    func fetchUserInfo(_ username: String) -> Single<UserEntity>
    func fetchUserRepository(_ username: String) -> Single<RepositoryListResponse>
    func fetchRepository(_ owner: String, _ repo: String) -> Single<RepositoryEntity>
}

struct RealRepositoryService: RepositoryService {
    let repository: UserRepository
    let appState: Store<AppState>
    
    init(repository: UserRepository, appState: Store<AppState>) {
        self.repository = repository
        self.appState = appState
    }
    
    func fetchUserInfo(_ username: String) -> Single<UserEntity> {
        return repository.fetchUserInfo(username).map {
            return try UserEntity($0)
        }
    }
    
    func fetchUserRepository(_ username: String) -> Single<RepositoryListResponse> {
        return repository.fetchUserRepository(username).map {
            return try RepositoryListResponse($0)
        }
    }
    
    func fetchRepository(_ owner: String, _ repo: String) -> Single<RepositoryEntity> {
        return repository.fetchRepository(owner, repo).map {
            return RepositoryEntity($0)
        }
    }
}

struct StubRepositoryService: RepositoryService {
    func fetchUserInfo(_ username: String) -> Single<UserEntity> {
        let value = UserEntity.init(login: "kangnux",
                                    name: "kangnux",
                                    avatarUrl: "https://avatars.githubusercontent.com/u/14342048?v=4",
                                    url: "https://api.github.com/users/kangnux",
                                    htmlUrl: "https://github.com/kangnux",
                                    location: "",
                                    email: "kangnux@outlook.com",
                                    bio: "test",
                                    followers: "0",
                                    following: "0")
        return SingleResponse<UserEntity>.success(value).Event
    }
    
    func fetchUserRepository(_ username: String) -> Single<RepositoryListResponse> {
        let value = RepositoryListResponse.init(list:  [RepositoryEntity()])
        return SingleResponse<RepositoryListResponse>.success(value).Event
    }
    
    func fetchRepository(_ owner: String, _ repo: String) -> Single<RepositoryEntity> {
        let value = RepositoryEntity()
        return SingleResponse<RepositoryEntity>.success(value).Event
    }
}
