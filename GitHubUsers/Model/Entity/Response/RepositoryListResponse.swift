//
//  RepositoryListResponse.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/19.
//

import Foundation

struct RepositoryListResponse {
    var list: [RepositoryEntity] = []
}

extension RepositoryListResponse {
    init(_ src: GitReposList?) throws {
        guard let src = src else { throw RespApiError(.DataError) }
        list = src.compactMap{ $0 } .map { RepositoryEntity($0) }
    }
}
