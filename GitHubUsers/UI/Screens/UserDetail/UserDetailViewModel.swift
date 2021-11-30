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
    @Published var userInfoList: [UserEntity] = []
    @Published var userInfo = UserEntity()
    @Published var tapLogin: String = localString.empty()
    @Published var repositories: [RepositoryEntity] = []
    @Published var showIndicator = false
    @Published var pinLoginList: [UserEntity.Login] = []
    @Published var pinRepositories:[PinRepositoryEntity] = []
    @Published var isUserPin = false
    
    init(container: DIContainer) {
        self.container = container
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
                .map{ $0.contains(self.tapLogin) }
                .weakAssign(to: \.isUserPin, on: self)
            
            $userInfoList.combineLatest($tapLogin)
                .removeDuplicates { $0 == $1 }
                .map { list, login in
                    list.first{ element in element.login == login } ?? UserEntity()
                }
                .weakAssign(to: \.userInfo, on: self)
        }
    }
    
    func updatePinUserStatus(_ isPin: Bool) {
        if !tapLogin.isEmpty {
            AppSettingManager.shared.updatePinUserStatus(isPin, tapLogin, userInfo.avatarUrl)
            self.pinLoginList = AppSettingManager.shared.fetchPinUserList().map { $0.login }
        }
    }
    
    func fetchUserRepositories() {
        self.repositories = []
        if !tapLogin.isEmpty {
            showIndicator = true
            disposable = container.services.repositoryService.fetchUserRepository(tapLogin)
                .subscribe(onSuccess: { [weak self] response in
                    DispatchQueue.main.async {
                        self?.showIndicator = false
                        self?.repositories = response.list.filter { $0.fork == false }
                    }
                }, onFailure: { [weak self]  _ in
                    self?.showIndicator = false
                })
            disposable?.disposed(by: disposeBag)
        }
    }
}
