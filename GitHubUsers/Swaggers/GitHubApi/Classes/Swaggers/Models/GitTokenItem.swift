//
// GitTokenItem.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct GitTokenItem: Codable {

    public var accessToken: String?
    public var scope: String?
    public var tokenType: String?

    public init(accessToken: String? = nil, scope: String? = nil, tokenType: String? = nil) {
        self.accessToken = accessToken
        self.scope = scope
        self.tokenType = tokenType
    }

    public enum CodingKeys: String, CodingKey { 
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }

}
