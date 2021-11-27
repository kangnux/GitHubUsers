//
//  TokenEntity.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/27.
//

import Foundation

struct TokenEntity: Codable {
    var token = localString.empty()
    var last = localString.empty()
}

extension TokenEntity {
    init (token: String) {
        self.token = token
        let format = DateFormatter()
        format.dateStyle = .short
        format.timeStyle = .short
        self.last = format.string(from: Date())
    }
}
