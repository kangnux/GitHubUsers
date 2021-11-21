//
//  UserEntity.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/17.
//

import Foundation

struct UserEntity: Identifiable, Hashable {
    var id = UUID()
    var login: String = localString.empty()
    var name: String = localString.hyphen()
    var avatarUrl: String = localString.empty()
    var url: String = localString.empty()
    var htmlUrl: String = localString.empty()
    var location: String = localString.empty()
    var email: String = localString.empty()
    var bio: String = localString.empty()
    var followers: String = localString.zero()
    var following: String = localString.zero()
    
    typealias Login = String
}

extension UserEntity {
    init(_ src: GitSearchUserItem )  {
        avatarUrl = src.avatarUrl ?? localString.empty()
        login = src.login ?? localString.empty()
    }
    
    init(_ src: PinUserEntity )  {
        avatarUrl = src.avatarUrl
        login = src.login
    }
    
    init(_ src: GitUserInfo? ) throws {
        guard let src = src else { throw RespApiError(.DataError) }
        login = src.login ?? localString.empty()
        name = src.name ?? localString.empty()
        avatarUrl = src.avatarUrl ?? localString.empty()
        url = src.url ?? localString.empty()
        htmlUrl = src.url ?? localString.empty()
        location = src.location ?? localString.empty()
        email = src.email ?? localString.empty()
        name = src.name ?? localString.hyphen()
        bio = src.bio ?? localString.empty()
        followers = (src.followers ?? 0) .formatPoints()
        following = (src.following ?? 0) .formatPoints()
    }
}
