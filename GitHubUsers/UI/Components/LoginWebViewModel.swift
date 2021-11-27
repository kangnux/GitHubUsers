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
    
    @Published var didFinishLoading: Bool = false
    private var disposable: Disposable?
    private let disposeBag = DisposeBag()
    
    init (container: DIContainer) {
        self.container = container
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
                }
            }, onFailure: {  [weak self] error in
                print(error)
            })
        disposable?.disposed(by: disposeBag)
    }
    
    private func fetchQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
