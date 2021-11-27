//
//  BaseRepository.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//


import Foundation
import Alamofire
import RxSwift

protocol BaseRepository {
}

extension BaseRepository {
    func convertSingle<T: Codable>(apiType: ApiType = .restApi,
                                   function: String = #function,
                                   executeApi: @escaping (_ completion: @escaping ((_ data: T?, _ error: Error?) -> Void)) -> Void) -> Single<T> {
        APIConfig.updateApiBasePath(apiType)
        return Single<T>.create { (observer) -> Disposable in
            executeApi { response, error in
                if let apiError = convertToApiError(response, error) {
                    observer(.failure(apiError))
                } else {
                    if let response = response {
                        observer(.success(response))
                    } else {
                        observer(.failure(RespApiError(.DataError)))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    private func convertToApiError(_ response: Any?,_ error: Error?) -> ApiError? {
        if let error = error {
            if let errorResponse = error as? ErrorResponse {
                switch(errorResponse) {
                case .error(let code, _, let error):
                    if let status = RespStatus.transfer(code) {
                        return RespApiError(status)
                    } else {
                        let code = (error as NSError).code
                        if [NSURLErrorNotConnectedToInternet,
                            NSURLErrorNetworkConnectionLost,
                            NSURLErrorCannotConnectToHost,
                            NSURLErrorTimedOut].contains(code) {
                            return RespApiError(.ConnectError)
                        } else if code == NSURLErrorCancelled {
                            return RespApiError(.CancelError)
                        } else if error is DecodingError {
                            return RespApiError(.DataError)
                        } else {
                            return RespApiError(.ConnectError)
                        }
                    }
                }
            } else if error is DecodingError {
                return RespApiError(.DataError)
            } else {
                return RespApiError(.ConnectError)
            }
        } else if response == nil {
            return RespApiError(.DataError)
        }
        return nil
    }
}
