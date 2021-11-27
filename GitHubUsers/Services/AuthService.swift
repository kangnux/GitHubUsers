//
//  AuthService.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/27.
//

import Foundation
import RxSwift

protocol AuthService {
    func fetchAuthUrl(_ state: String) -> String
    func fetchAccessToken(_ code: String) -> Single<AccessTokenResponse>
}

struct RealAuthService: AuthService {
    let repository: AuthRepository
    let appState: Store<AppState>
    
    init(repository: AuthRepository, appState: Store<AppState>) {
        self.repository = repository
        self.appState = appState
    }
    
    func fetchAuthUrl(_ state: String) -> String {
        return repository.fetchAuthUrl(state)
    }
    
    func fetchAccessToken(_ code: String) -> Single<AccessTokenResponse> {
        return repository.fetchAccessToken(code).map {
            return try AccessTokenResponse($0)
        }
    }
}

struct StubAuthService: AuthService {
    func fetchAuthUrl(_ state: String) -> String {
        return localString.empty()
    }
    
    func fetchAccessToken(_ code: String) -> Single<AccessTokenResponse> {
        let value = AccessTokenResponse(accessToken: "gho_xxxxx",
                                        tokenType: "repo,gist",
                                        scope: "bearer")
        return SingleResponse<AccessTokenResponse>.success(value).Event
    }
}
