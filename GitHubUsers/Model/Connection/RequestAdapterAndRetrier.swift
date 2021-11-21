//
//  RequestAdapterAndRetrier.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import Alamofire

class RequestAdapterAndRetrier: RequestAdapter, RequestRetrier {
    var retryCount: Int = APIConfig.retryCount
    var retrytime: Double {
        return APIConfig.retryTime / 1000
    }

    func adapt( _ urlRequest: URLRequest) throws -> URLRequest {
        var urlReq: URLRequest = urlRequest
        urlReq.cachePolicy = .reloadIgnoringLocalCacheData
        return urlReq
    }
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        var isRetry = true
        
        if (error as NSError).code == NSURLErrorNotConnectedToInternet ||
            (error as NSError).code == NSURLErrorCancelled {
            isRetry = false
        }
        
        if isRetry {
            if request.retryCount < retryCount {
                completion(true, TimeInterval(retrytime))
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    completion(false, 0)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion(false, 0)
            }
        }
    }
}
