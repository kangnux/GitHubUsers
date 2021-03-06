//
// SearchUserResponse.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct SearchUserResponse: Codable {

    public var totalCount: Int?
    public var incompleteResults: Bool?
    public var items: [SearchUserItem]?

    public init(totalCount: Int? = nil, incompleteResults: Bool? = nil, items: [SearchUserItem]? = nil) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }

    public enum CodingKeys: String, CodingKey { 
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }

}
