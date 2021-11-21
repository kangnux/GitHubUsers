//
//  UserRepository.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/17.
//

import Foundation
import RxSwift

protocol UserRepository: BaseRepository {
    func fetchUserInfo(_ username: String) -> Single<GitUserInfo>
    func fetchUserRepository(_ username: String) -> Single<GitReposList>
    func fetchRepository(_ owner: String, _ repo: String) -> Single<GitReposItem>
}

struct RealUserRepository: UserRepository {
    func fetchUserInfo(_ username: String) -> Single<GitUserInfo> {
        return convertSingle { completion in
            UsersAPI.requestUsers(username: username, completion: completion)
        }
    }
    
    func fetchUserRepository(_ username: String) -> Single<GitReposList> {
        return convertSingle { completion in
            RepositoriesAPI.requestRepos(username: username, perPage: 100, completion: completion)
        }
    }
    
    func fetchRepository(_ owner: String, _ repo: String) -> Single<GitReposItem> {
        return convertSingle { completion in
            RepositoriesAPI.requestGetRepository(username: owner, repo: repo, completion: completion)
        }
    }
}
