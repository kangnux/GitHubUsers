//
//  AccessTokenResponse.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/23.
//

import Foundation

struct AccessTokenResponse: Codable {
    public let accessToken: String?
    public let tokenType: String?
    public let scope: String?
}

extension AccessTokenResponse {
    init(_ src: GitTokenItem?) throws {
        guard let src = src else { throw RespApiError(.DataError) }
        accessToken = src.accessToken
        tokenType = src.tokenType
        scope = src.scope
    }
}
