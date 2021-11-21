//
//  PinUserEntity.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation
import UIKit

struct PinUserEntity: Hashable, Codable {
    var login = localString.empty()
    var avatarUrl = localString.empty()
    var date = localString.empty()
    
    init(login: String, avatarUrl: String, date: String) {
        self.login = login
        self.avatarUrl = avatarUrl
        self.date = date
    }
}

extension PinUserEntity: Comparable {
    static func < (lhs: PinUserEntity, rhs: PinUserEntity) -> Bool {
        return lhs.date < rhs.date
    }
}
