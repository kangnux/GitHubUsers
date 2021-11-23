//
//  TagEntity.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/22.
//

import Foundation
import SwiftUI

struct TagEntity: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
