//
//  OmitUserEntity.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation

struct OmitUserEntity: Identifiable, Hashable {
    var id = UUID()
    var avatarUrl: String
    var login: String
    
    typealias Login = String
}

extension OmitUserEntity {
    init(_ src: GitSearchUserItem) {
        avatarUrl = src.avatarUrl ?? localString.empty()
        login = src.login ?? localString.empty()
    }
}
