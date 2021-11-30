//
//  ProfileViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/23.
//

import Foundation
import RxSwift

class ProfileViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    private var disposable: Disposable?
    private let disposeBag = DisposeBag()
    
    @Published var lastDate: String = localString.empty()
    @Published var authorizeState: TokenAuthorizeState = .invalid
    @Published var authInfo = AuthInfoEntity()
    @Published var isShowLoginView: Bool = false
    @Published var count: SearchCount = .ten
    @Published var userInfo = UserEntity()
    @Published var repositories: [RepositoryEntity] = []
    @Published var showIndicator = false
    
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
                .sink {
                    self.authInfo = $0
                    self.fetchUserInfo()
                }
        }
    }
    
    func fetchAccessToken() {
        if let tokenItem = AppSettingManager.shared.fetchGitHubApiToken(), !tokenItem.token.isEmpty {
            DispatchQueue.main.async {
                self.authorizeState = .valid
                self.lastDate = tokenItem.last
                self.fetchUserInfo()
            }
        }
    }
    
    func fetchSettting() {
        let count = AppSettingManager.shared.fetchSearchCount()
        DispatchQueue.main.async {
            self.count = SearchCount.build(count)
        }
    }
    
    func fetchUserInfo() {
        showIndicator = true
        disposable = container.services.authService.fetchUserInfo()
            .subscribe(onSuccess: { [weak self] response in
                DispatchQueue.main.async {
                    self?.userInfo = response
                    self?.fetchUserRepositories()
                }
            }, onFailure: { [weak self] error in
                self?.showIndicator = false
            })
        disposable?.disposed(by: disposeBag)
    }
    
    func fetchUserRepositories() {
        if userInfo.login.isEmpty { return }
        disposable = container.services.repositoryService.fetchUserRepository(userInfo.login)
            .subscribe(onSuccess: { [weak self] response in
                DispatchQueue.main.async {
                    self?.repositories = response.list
                    self?.showIndicator = false
                }
            }, onFailure: { [weak self] _ in
                self?.showIndicator = false
            })
        disposable?.disposed(by: disposeBag)
    }
    
    func updateSearchCount() {
        AppSettingManager.shared.updateSearchCount(count.rawValue)
    }
}
