//
//  AlertItem.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let alert: Alert
    
    init() {
        alert = Alert(title: Text(localString.empty()))
    }
    
    init(_ alert: Alert) {
        self.alert = alert
    }
}

extension AlertItem: Equatable {
    static func == (lhs: AlertItem, rhs: AlertItem) -> Bool {
        lhs.id == rhs.id
    }
}
