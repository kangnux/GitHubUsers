//
//  UserDetailViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/18.
//

import Foundation
import RxSwift

class UserDetailViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    private var disposable: Disposable?
    private let disposeBag = DisposeBag()
    
    @Published var apiAlertBag = ApiAlertBag()
    @Published var userInfo = UserEntity()
    @Published var repositories: [RepositoryEntity] = []
    @Published var showIndicator = false
    @Published var pinLoginList: [UserEntity.Login] = []
    @Published var pinRepositories:[PinRepositoryEntity] = []
    @Published var isUserPin = false
    
    init(container: DIContainer, userInfo: UserEntity) {
        self.container = container
        self.userInfo = userInfo
        let appState = container.appState
        _pinLoginList = .init(initialValue: appState.value.userData.pinLoginList)
        _pinRepositories = .init(initialValue: appState.value.userData.pinRepositories)
        cancelBag.collect {
            $pinLoginList.sink{ appState[\.userData.pinLoginList] = $0 }
            
            $pinRepositories.sink{ appState[\.userData.pinRepositories] = $0 }
            
            appState.map(\.userData.pinLoginList)
                .removeDuplicates()
                .weakAssign(to: \.pinLoginList, on: self)
            
            appState.map(\.userData.pinRepositories)
                .removeDuplicates()
                .weakAssign(to: \.pinRepositories, on: self)
            
            $pinLoginList
                .removeDuplicates()
                .map{ $0.contains(userInfo.login) }
                .weakAssign(to: \.isUserPin, on: self)
        }
    }
    
    func updatePinUserStatus(_ isPin: Bool) {
        AppSettingManager.shared.updatePinUserStatus(isPin, userInfo.login, userInfo.avatarUrl)
        self.pinLoginList = AppSettingManager.shared.fetchPinUserList().map { $0.login }
    }
    
    func fetchUserRepositories() {
        if showIndicator || userInfo.login.isEmpty { return }
        repositories = []
        showIndicator = true
        
        disposable = container.services.repositoryService.fetchUserRepository(userInfo.login)
            .subscribe(onSuccess: { [weak self] response in
                DispatchQueue.main.async {
                    self?.repositories = response.list
                    self?.showIndicator = false
                }
            }, onFailure: {  [weak self] error in
                self?.showIndicator = false
            })
        disposable?.disposed(by: disposeBag)
    }
}
