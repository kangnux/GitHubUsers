//
//  ProfileViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/23.
//

import Foundation

class ProfileViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    
    @Published var lastDate: String = localString.empty()
    @Published var authorizeState: TokenAuthorizeState = .invalid
    @Published var authInfo = AuthInfoEntity()
    @Published var isShowLoginView: Bool = false
    @Published var count: SearchCount = .ten
    
    init(container: DIContainer) {
        self.container = container
        let appState = container.appState
        
        cancelBag.collect {
            appState.map(\.userData.authorizeState)
                .removeDuplicates()
                .weakAssign(to: \.authorizeState, on: self)
            
            $authorizeState
                .removeDuplicates()
                .sink { appState[\.userData.authorizeState] = $0 }
            
            $authorizeState
                .removeDuplicates()
                .filter{ $0 == .valid }
                .sink { [weak self] _ in
                    self?.fetchAccessToken()
                }
            
            $authorizeState.zip($isShowLoginView)
                .removeDuplicates { $0 == $1 }
                .filter{ $0.1 == false }
                .map { AuthInfoEntity(showAlert: true, state: $0.0 == .valid ? .success : .fail ) }
                .dropFirst()
                .weakAssign(to: \.authInfo, on: self)
        }
    }
    
    func fetchAccessToken() {
        if let tokenItem = AppSettingManager.shared.fetchGitHubApiToken(), !tokenItem.token.isEmpty {
            DispatchQueue.main.async {
                self.authorizeState = .valid
                self.lastDate = tokenItem.last
            }
        }
    }
    
    func fetchSettting() {
        let count = AppSettingManager.shared.fetchSearchCount()
        DispatchQueue.main.async {
            self.count = SearchCount.build(count)
        }
    }
    
    func updateSearchCount() {
        AppSettingManager.shared.updateSearchCount(count.rawValue)
    }
}
