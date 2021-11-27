//
//  AuthInfoEntity.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/27.
//

import Foundation

struct AuthInfoEntity: Equatable {
    var showAlert: Bool = false
    var state: AuthState = .fail
}
