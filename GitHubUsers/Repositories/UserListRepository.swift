//
//  UserListRepository.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import RxSwift

protocol UserListRepository: BaseRepository {
    func fetchUserList(_ request: UserListRequest) -> Single<GitSearchUserResponse>
}

struct RealUserListRepository: UserListRepository {
    func fetchUserList(_ request: UserListRequest) -> Single<GitSearchUserResponse> {
        return convertSingle { completion in
            SearchAPI.requestSearchUsers( q: request.q,
                                          sort: request.sort.value,
                                          perPage: request.perPage,
                                          page: request.page,
                                          completion: completion)
        }
    }
}
