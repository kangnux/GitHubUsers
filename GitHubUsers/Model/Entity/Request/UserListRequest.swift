//
//  UserListRequest.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation

struct UserListRequest {
    var q: String
    var accept: AcceptType  = .recommend
    var sort: UserSortType = .bestMatch
    var order: UserOrderType =  .desc
    var perPage: Int
    var page: Int = 1
}

extension UserListRequest {
    init(q: String, perPage: Int) {
        self.q = q
        self.perPage = perPage
    }
}
