//
//  AuthRepository.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/27.
//

import Foundation
import RxSwift

protocol AuthRepository: BaseRepository {
    func fetchAuthUrl(_ state: String) -> String
    func fetchAccessToken(_ code: String) -> Single<GitTokenItem>
}

struct RealAuthRepository: AuthRepository {
    func fetchAuthUrl(_ state: String) -> String {
        APIConfig.updateApiBasePath(.authApi)
        return AuthAPI.requestAuthorizeWithRequestBuilder(clientId: XcodeConfig.ClientID,
                                                          redirectUri: XcodeConfig.RedirectURL,
                                                          state: state).URLString
    }
    
    func fetchAccessToken(_ code: String) -> Single<GitTokenItem> {
        return convertSingle(apiType: .authApi) { completion in
            AuthAPI.requestAccessToken(accept: APIConfig.authAccept,
                                       clientId: XcodeConfig.ClientID,
                                       clientSecret: XcodeConfig.ClientServer,
                                       code: code,
                                       redirectUri: XcodeConfig.RedirectURL,
                                       completion: completion)
        }
    }
}
