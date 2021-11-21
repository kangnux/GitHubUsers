//
//  AppEnvironment.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import Combine

struct AppEnvironment {
    let container: DIContainer
    
    static func bootstrap() -> AppEnvironment {
        initSystemConfit()
        
        let appState = Store<AppState>(AppState())
        let repositoreis = configRepositories(appState: appState)
        let services = configServices(appState: appState, repositories: repositoreis)
        let diContainer = DIContainer(appState: appState, services: services)
        
        return AppEnvironment(container: diContainer)
    }
    
    private static func configRepositories(appState: Store<AppState>) -> DIContainer.Repositories {
        let userListRepository = RealUserListRepository()
        let userRepository = RealUserRepository()
        
        return .init(userListRepository: userListRepository, userRepository: userRepository)
    }
    
    private static func configServices(appState: Store<AppState>, repositories: DIContainer.Repositories) -> DIContainer.Services {
        let userListService = RealUserListService(repository: repositories.userListRepository, appState: appState)
        let repositoryService = RealRepositoryService(repository: repositories.userRepository, appState: appState)
        return .init(userListService: userListService, repositoryService: repositoryService)
    }
    
    private static func initSystemConfit() {
        APIConfig.initAPIConfig()
    }
}

extension DIContainer {
    struct Repositories {
        let userListRepository: UserListRepository
        let userRepository: UserRepository
    }
}
