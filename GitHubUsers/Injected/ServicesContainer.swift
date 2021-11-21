//
//  ServicesContainer.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation

extension DIContainer {
    struct Services {
        let userListService: UserListService
        let repositoryService: RepositoryService
        
        init(userListService: UserListService, repositoryService: RepositoryService) {
            self.userListService = userListService
            self.repositoryService = repositoryService
        }
        
        static var stub: Self {
            .init(userListService: StubUserListService(), repositoryService: StubRepositoryService())
        }
    }
}
