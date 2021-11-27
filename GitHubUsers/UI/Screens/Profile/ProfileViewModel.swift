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
    
    init(container: DIContainer) {
        self.container = container
    }
}
