//
//  RxSwift+Extension.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import RxSwift

enum SingleResponse<T> {
    case success(T)
    case failure(Error)
    
    var value: T? {
        switch self {
        case let .success(value): return value
        default: return nil
        }
    }
    
    var error: Error? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
    
    var Event: Single<T> {
        return Single<T>.create { single in
            switch self {
            case let .success(value): single(.success(value))
            case let .failure(error): single(.failure(error))
            }
            return Disposables.create()
        }
        .delay(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
    }
}
