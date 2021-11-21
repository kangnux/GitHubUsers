//
//  PinRepositoryEntity.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation

struct PinRepositoryEntity: Hashable, Codable {
    var owner = localString.empty()
    var repo = localString.empty()
    var date = localString.empty()
    
    init(owner: String, repo: String, date: String) {
        self.owner = owner
        self.repo = repo
        self.date = date
    }
}

extension PinRepositoryEntity: Comparable {
    static func < (lhs: PinRepositoryEntity, rhs: PinRepositoryEntity) -> Bool {
        return lhs.date < rhs.date
    }
}
