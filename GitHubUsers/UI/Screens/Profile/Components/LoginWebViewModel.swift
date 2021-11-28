//
//  LoginWebViewModel.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/23.
//

import Foundation
import RxSwift

class LoginWebViewModel: ObservableObject {
    let container: DIContainer
    private let cancelBag = CancelBag()
    private var disposable: Disposable?
    private let disposeBag = DisposeBag()
    
    @Published var didFinishLoading: Bool = false
    @Published var authorizeState: TokenAuthorizeState = .invalid
    
    init (container: DIContainer) {
        self.container = container
        let appState = container.appState
        
        cancelBag.collect {
            appState.map(\.userData.authorizeState)
                .removeDuplicates()
                .weakAssign(to: \.authorizeState, on: self)
            
            $authorizeState
                .removeDuplicates()
                .sink { appState[\.userData.authorizeState] = $0 }
        }
    }
    
    func fetchAuthUrl() -> String {
        return container.services.authService.fetchAuthUrl(APIConfig.authState)
    }
    
    func checkRedirectUrl(_ url: URL) {
        if APIConfig.checkRedirectURL(url) {
            let state = fetchQueryStringParameter(url: url.absoluteString, param: "state")
            let code = fetchQueryStringParameter(url: url.absoluteString, param: "code")
            if state == APIConfig.authState, let code = code {
                fetchAccessToken(code: code)
            }
        }
    }
    
    func fetchAccessToken(code: String) {
        disposable = container.services.authService.fetchAccessToken(code)
            .subscribe(onSuccess: { response in
                if let token = response.accessToken, !token.isEmpty {
                    APIConfig.updateToken(token)
                    self.authorizeState = .valid
                }
            }, onFailure: { error in
                self.authorizeState = .invalid
            })
        disposable?.disposed(by: disposeBag)
    }
    
    private func fetchQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
