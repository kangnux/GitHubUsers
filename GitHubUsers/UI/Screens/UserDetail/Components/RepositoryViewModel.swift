//
//  RepositoryViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation

class RepositoryViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    
    @Published var pinRepositories:[PinRepositoryEntity] = []
    @Published var isRepositoryPin = false
    
    var repository: RepositoryEntity
    
    init(container: DIContainer, repository: RepositoryEntity) {
        self.container = container
        let appState = container.appState
        _pinRepositories = .init(initialValue: appState.value.userData.pinRepositories)
        self.repository = repository
        
        cancelBag.collect {
            $pinRepositories.sink{ appState[\.userData.pinRepositories] = $0 }
            
            appState.map(\.userData.pinRepositories)
                .removeDuplicates()
                .weakAssign(to: \.pinRepositories, on: self)
            
            $pinRepositories
                .removeDuplicates()
                .map{ $0.filter { self.repository.isEqual(owner: $0.owner, repo: $0.repo) }.count > 0 }
                .weakAssign(to: \.isRepositoryPin, on: self)
        }
    }
    
    func updatePinRepositoryStatus(_ isPin: Bool) {
        AppSettingManager.shared.updatePinRepositories(isPin, repository.owner, repository.name)
        self.pinRepositories = AppSettingManager.shared.fetchPinRepositories()
    }
}
