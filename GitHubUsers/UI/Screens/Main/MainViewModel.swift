//
//  MainViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation

import Foundation

class MainViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    
    @Published var tab: MainViewTab
    @Published var userListViewModel: UserListViewModel
    @Published var pinViewModel: PinViewModel
    @Published var thankViewModel: ThankViewModel
    
    init(container: DIContainer) {
        self.container = container
        let appState = container.appState
        _tab = .init(initialValue: appState.value.routing.mainTab.tab)
        userListViewModel = .init(container: container)
        pinViewModel = .init(container: container)
        thankViewModel = .init(container: container)
        
        cancelBag.collect {
            $tab.sink{ appState[\.routing.mainTab.tab] = $0 }
            
            appState.map(\.routing.mainTab.tab)
                .removeDuplicates()
                .weakAssign(to: \.tab, on: self)
        }
    }
}

extension MainViewModel {
    struct Routing: Equatable {
        var tab: MainViewTab
    }
}
