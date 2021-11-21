//
//  ThankViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation

class ThankViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    
    init(container: DIContainer) {
        self.container = container
    }
}
