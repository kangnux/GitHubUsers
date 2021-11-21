//
//  OmitUserViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import Combine

class OmitUserViewModel: ObservableObject {
    let container: DIContainer
    
    private let cancelBag = CancelBag()
    
    @Published var followers: Int = 0
    @Published var userInfo: UserEntity = UserEntity()
    @Published var isPin = false
    
    init(container: DIContainer, _ userInfo: UserEntity) {
        self.container = container
        self.userInfo = userInfo
        let appState = container.appState
        
        cancelBag.collect {
            appState.map(\.userData.pinLoginList)
                .removeDuplicates()
                .map{ $0.contains(userInfo.login) }
                .weakAssign(to: \.isPin, on: self)
        }
    }
}
