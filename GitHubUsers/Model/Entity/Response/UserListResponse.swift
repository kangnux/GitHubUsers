//
//  UserListResponse.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation

struct UserListResponse: Equatable {
    var list: [UserEntity] = []
}

extension UserListResponse {
    init(_ src: [PinUserEntity]) {
        self.list = src.map { UserEntity($0) }
    }
    
    init(_ src: GitSearchUserResponse?) throws {
        guard let src = src else { throw RespApiError(.DataError) }
        if let items = src.items {
            self.list = items.compactMap{ $0 }.map { UserEntity($0) }
        } else {
            self.list = []
        }
    }
    
    mutating func update(_ list: [UserEntity]) {
        _ = list.map { user in
            if let index = list.firstIndex(where: { $0.login == user.login }) {
                if self.list.count > index {
                    self.list[index].name = user.name
                    self.list[index].url = user.url
                    self.list[index].htmlUrl = user.url
                    self.list[index].location = user.location
                    self.list[index].email = user.email
                    self.list[index].name = user.name
                    self.list[index].bio = user.bio
                    self.list[index].followers = user.followers
                    self.list[index].following = user.following
                }
            }
        }
    }
}
