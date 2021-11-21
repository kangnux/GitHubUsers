//
//  PinViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation
import RxSwift

class PinViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    private var disposable: Disposable?
    private let disposeBag = DisposeBag()
    
    @Published var apiAlertBag = ApiAlertBag()
    @Published var tab: PinViewTab
    @Published var tapLogin: UserEntity.Login?
    @Published var userListInfo: UserListResponse = UserListResponse()
    @Published var repositories: [RepositoryEntity] = []

    init(container: DIContainer) {
        self.container = container
        let appState = container.appState
        _tab = .init(initialValue: appState.value.routing.pinTab.tab)
        _tapLogin = .init(initialValue: appState.value.routing.pinTab.tapLogin)
        
        cancelBag.collect {
            $tab.sink{ appState[\.routing.pinTab.tab] = $0 }
            
            appState.map(\.routing.pinTab.tab)
                .removeDuplicates()
                .weakAssign(to: \.tab, on: self)
            
            appState.map(\.userData.pinLoginList)
                .removeDuplicates()
                .sink { [weak self] _ in
                    self?.fetPinUserList()
                }
            
            appState.map(\.userData.pinRepositories)
                .removeDuplicates()
                .sink { [weak self] _ in
                    self?.fetPinRepositories()
                }
        }
    }
    
    func fetPinUserList() {
        let list = AppSettingManager.shared.fetchPinUserList()
        self.userListInfo = UserListResponse(list)
        let loginList = list.map { $0.login } .filter { !$0.isEmpty }
        if loginList.count > 0 {
            fetchUserDetailInfo(loginList)
        }
    }
    
    func fetPinRepositories() {
        let list = AppSettingManager.shared.fetchPinRepositories()
        fetchRepositoryInfo(list)
    }
    
    func fetchUserDetailInfo(_ loginList: [String]) {
        let requestlist = loginList
            .map{ container.services.repositoryService.fetchUserInfo($0).asObservable() }
        disposable = Observable.zip(requestlist)
            .subscribe(onNext: { [weak self] list in
                DispatchQueue.main.async {
                    self?.userListInfo.update(list)
                }
            }, onError: { [weak self] error in
                self?.apiAlertBag.addAlertItem(error: error)
            })
        disposable?.disposed(by: disposeBag)
    }
    
    func fetchRepositoryInfo(_ pinRepositories: [PinRepositoryEntity]) {
        self.repositories = []
        let requestlist = pinRepositories
            .map{ container.services.repositoryService.fetchRepository($0.owner, $0.repo).asObservable() }
        disposable = Observable.zip(requestlist)
            .subscribe(onNext: { [weak self] list in
                DispatchQueue.main.async {
                    self?.repositories = list
                }
            }, onError: { [weak self] error in
                self?.apiAlertBag.addAlertItem(error: error)
            })
        disposable?.disposed(by: disposeBag)
    }
}

extension PinViewModel {
    struct Routing: Equatable {
        var tab: PinViewTab
        var tapLogin: UserEntity.Login?
    }
}
