//
//  ApiError.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation

enum RespStatus: Int {
    case Success = 200
    case NotModified = 304
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case UnprocessableEntity = 422
    case ServiceUnavailable = 503
    case CancelError = 777
    case ConnectError = 888
    case DataError = 999
    
    static func transfer(_ code: Int) -> RespStatus? {
        if let status = [.NotModified, .Unauthorized, .Forbidden, .UnprocessableEntity, .ServiceUnavailable]
            .first(where: { ($0 as RespStatus).rawValue == code }) {
            return status
        }
        
        return nil
    }
    
    var message: String {
        switch self {
        case .Success:
            return localString.empty()
        case .NotModified, .Unauthorized, .Forbidden:
            return localString.updateToken() + localString.errorCode(self.rawValue.description)
        case .NotFound:
            return localString.retryLater() + localString.errorCode(self.rawValue.description)
        case .UnprocessableEntity:
            return localString.checkInput() + localString.errorCode(self.rawValue.description)
        case .ServiceUnavailable:
            return localString.retryLater() + localString.errorCode(self.rawValue.description)
        case .ConnectError:
            return localString.retryLater()
        case .CancelError, .DataError:
            return localString.retryLater()
        }
    }
    
    var title: String {
        switch self {
        case .Success:
            return localString.empty()
        case.NotModified:
            return localString.notModified()
        case .Unauthorized:
            return localString.unauthorized()
        case .Forbidden:
            return localString.forbidden()
        case .NotFound:
            return localString.notFound()
        case .UnprocessableEntity:
            return localString.unprocessableEntity()
        case .ServiceUnavailable:
            return localString.serviceUnavailable()
        case .CancelError:
            return localString.cancelError()
        case .ConnectError:
            return localString.connectError()
        case .DataError:
            return localString.dataError()
        }
    }
}

protocol ApiError: Error {
    var status: RespStatus { get }
}

struct RespApiError: ApiError {
    var status: RespStatus
    
    init(_ status: RespStatus) {
        self.status = status
    }
}
