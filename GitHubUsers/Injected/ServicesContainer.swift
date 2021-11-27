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
        let authService: AuthService
        
        init(userListService: UserListService, repositoryService: RepositoryService, authService: AuthService) {
            self.userListService = userListService
            self.repositoryService = repositoryService
            self.authService = authService
        }
        
        static var stub: Self {
            .init(userListService: StubUserListService(),
                  repositoryService: StubRepositoryService(),
                  authService: StubAuthService())
        }
    }
}
