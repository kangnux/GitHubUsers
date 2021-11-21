//
//  GitHubAlamofireRequestBuilderFactory.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import Alamofire

class GitHubAlamofireRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        return AlamofireRequestBuilder<T>.self
    }
    
    func getBuilder<T>() -> RequestBuilder<T>.Type where T : Decodable {
        return WatchOSAlamofireRequestBuilder<T>.self
    }
}

class WatchOSAlamofireRequestBuilder<T: Decodable>: AlamofireDecodableRequestBuilder<T> {
    override func createSessionManager() -> SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = buildHeaders()
        let handler = RequestAdapterAndRetrier()
        let manager = Alamofire.SessionManager(configuration: configuration)
        manager.adapter = handler
        manager.retrier = handler
        return manager
    }
}
