//
//  TriggerObject.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/28.
//

import Foundation

class TriggerObject: ObservableObject {
    var refreshTrigger: Trigger<RefreshType> = .init(type: .appear, trigger: false)
}

struct Trigger<T: Equatable>: Equatable {
    var type: T
    var trigger: Bool
    
    func toggle(type: T) -> Trigger<T> {
        return .init(type: type, trigger: !trigger)
    }
}
