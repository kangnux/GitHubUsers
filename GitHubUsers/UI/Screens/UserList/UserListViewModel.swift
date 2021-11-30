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
    @Published var refresh: Trigger<RefreshType> = .init(type: .appear, trigger: false)
    @Published var routingState: Routing
    @Published var searchKey: String = localString.empty()
    @Published var tags: [TagEntity] = []
    @Published var userListInfo: UserListResponse = UserListResponse()
    @Published var showIndicator = false
    @Published var isShowEmpty: Bool = false
    @Published var authorizeState: TokenAuthorizeState = .invalid
    
    var userDetailViewModel: UserDetailViewModel
    
    init(container: DIContainer) {
        self.container = container
        let appState = container.appState
        _routingState = .init(initialValue: appState.value.routing.userList)
        
        userDetailViewModel = .init(container: container)
        
        cancelBag.collect {
            $searchKey
                .debounce(for: 0.25, scheduler: DispatchQueue.main)
                .sink {_ in
                    self.refresh = self.refresh.toggle(type: .manual)
                }
            
            appState.map(\.userData.authorizeState)
                .removeDuplicates()
                .weakAssign(to: \.authorizeState, on: self)
            
            $authorizeState
                .removeDuplicates()
                .sink { appState[\.userData.authorizeState] = $0 }
            
            $routingState.sink { appState[\.routing.userList.tapLogin] = $0.tapLogin }
            
            $userListInfo
                .removeDuplicates()
                .sink { self.userDetailViewModel.userInfoList = $0.list }
            
            $routingState
                .removeDuplicates()
                .map { $0.tapLogin ?? localString.empty() }
                .sink { self.userDetailViewModel.tapLogin = $0 }
        }
    }
    
    func refresh(type: RefreshType) {
        if [.appear, .active, .manual, .pull].contains(type) {
            fetchUserList(type.isShowIndicator)
        }
    }
    
    func fetchUserList(_ isShowIndicator: Bool = true) {
        userListInfo = UserListResponse()
        isShowEmpty = false
        showIndicator = isShowIndicator
        
        let request = UserListRequest(q: searchKey + Constants.searchKeySuffix, perPage: AppSettingManager.searchCount.rawValue)
        disposable = container.services.userListService.fetchUserList(request)
            .subscribe(onSuccess: { [weak self] response in
                let loginList = response.list.map { $0.login } .filter { !$0.isEmpty }
                self?.fetchUserDetailInfo( loginList )
                self?.authorizeState = .valid
                DispatchQueue.main.async {
                    self?.userListInfo = response
                    self?.showIndicator = false
                    self?.isShowEmpty = loginList.isEmpty
                }
            }, onFailure: {  [weak self] error in
                if let apiError = error as? ApiError,
                   [.NotModified, .Unauthorized, .Forbidden].contains(apiError.status) {
                    self?.authorizeState = .invalid
                }
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
        let tags = AppSettingManager.shared.fetchSearchHistory()
        DispatchQueue.main.async {
            self.tags = tags
            if tags.count > 0 {
                self.searchKey = tags.first?.text ?? localString.empty()
            } else {
                self.refresh = self.refresh.toggle(type: .appear)
            }
        }
    }
}

extension UserListViewModel {
    struct Routing: Equatable {
        var tapLogin: OmitUserEntity.Login?
    }
}
