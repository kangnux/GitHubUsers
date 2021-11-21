//
//  Publisher+WeakAssign.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on object: T
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
