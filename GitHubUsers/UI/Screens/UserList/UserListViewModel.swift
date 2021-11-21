//
//  UserListViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import RxSwift

class UserListViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    private var disposable: Disposable?
    private let disposeBag = DisposeBag()
    
    @Published var apiAlertBag = ApiAlertBag()
    @Published var routingState: Routing
    @Published var searchKey: String = localString.empty()
    @Published var userListInfo: UserListResponse = UserListResponse()
    @Published var showIndicator = false
    @Published var searchCount: SearchCount = .ten
    @Published var isShowEmpty: Bool = false
    
    init(container: DIContainer) {
        self.container = container
        let appState = container.appState
        _routingState = .init(initialValue: appState.value.routing.userList)
        
        cancelBag.collect {
            $searchKey
                .debounce(for: 0.25, scheduler: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.fetchUserList()
                }
        }
    }
    
    func fetchUserList(_ isShowIndicator: Bool = true) {
        guard !showIndicator else { return }
        userListInfo = UserListResponse()
        isShowEmpty = false
        showIndicator = isShowIndicator
        
        let request = UserListRequest(q: searchKey + Constants.searchKeySuffix, perPage: searchCount.rawValue)
        disposable = container.services.userListService.fetchUserList(request)
            .subscribe(onSuccess: { [weak self] response in
                let loginList = response.list.map { $0.login } .filter { !$0.isEmpty }
                self?.fetchUserDetailInfo( loginList )
                DispatchQueue.main.async {
                    self?.userListInfo = response
                    self?.showIndicator = false
                    self?.isShowEmpty = loginList.isEmpty
                }
            }, onFailure: {  [weak self] error in
                self?.showIndicator = false
                self?.apiAlertBag.addAlertItem(error: error)
                self?.isShowEmpty = false
            })
        disposable?.disposed(by: disposeBag)
    }
    
    func fetchUserDetailInfo(_ loginList: [String], _ isShowIndicator: Bool = true) {
        showIndicator = isShowIndicator
        let requestlist = loginList
            .map{ container.services.repositoryService.fetchUserInfo($0).asObservable() }
        disposable = Observable.zip(requestlist)
            .subscribe(onNext: { [weak self] list in
                DispatchQueue.main.async {
                    self?.showIndicator = false
                    self?.userListInfo.update(list)
                }
            }, onError: { [weak self] error in
                self?.showIndicator = false
                self?.apiAlertBag.addAlertItem(error: error)
            })
        disposable?.disposed(by: disposeBag)
    }
    
    func fetchSettting() {
        let count = AppSettingManager.shared.fetchSearchCount()
        DispatchQueue.main.async {
            self.searchCount = SearchCount.build(count)
            self.fetchUserList()
        }
    }
    
    func updateSearchCount() {
        AppSettingManager.shared.updateSearchCount(searchCount.rawValue)
        fetchUserList()
    }
}

extension UserListViewModel {
    struct Routing: Equatable {
        var tapLogin: OmitUserEntity.Login?
    }
}
