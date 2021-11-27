//
// AuthAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire
import RxSwift


open class AuthAPI {
    /**
     Fetch Token

     - parameter accept: (header)  
     - parameter clientId: (query)  
     - parameter clientSecret: (query)  
     - parameter code: (query)  
     - parameter redirectUri: (query)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestAccessToken(accept: String, clientId: String, clientSecret: String, code: String, redirectUri: String, completion: @escaping ((_ data: GitTokenItem?,_ error: Error?) -> Void)) {
        requestAccessTokenWithRequestBuilder(accept: accept, clientId: clientId, clientSecret: clientSecret, code: code, redirectUri: redirectUri).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     Fetch Token
     - parameter accept: (header)  
     - parameter clientId: (query)  
     - parameter clientSecret: (query)  
     - parameter code: (query)  
     - parameter redirectUri: (query)  
     - returns: Observable<GitTokenItem>
     */
    open class func requestAccessToken(accept: String, clientId: String, clientSecret: String, code: String, redirectUri: String) -> Observable<GitTokenItem> {
        return Observable.create { observer -> Disposable in
            requestAccessToken(accept: accept, clientId: clientId, clientSecret: clientSecret, code: code, redirectUri: redirectUri) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     Fetch Token
     - POST /access_token
     - 

     - examples: [{contentType=application/json, example={
  "access_token" : "gho_16C7e42F292c6912E7710c838347Ae178B4a",
  "scope" : "repo,gist",
  "token_type" : "bearer"
}}]
     - parameter accept: (header)  
     - parameter clientId: (query)  
     - parameter clientSecret: (query)  
     - parameter code: (query)  
     - parameter redirectUri: (query)  

     - returns: RequestBuilder<GitTokenItem> 
     */
    open class func requestAccessTokenWithRequestBuilder(accept: String, clientId: String, clientSecret: String, code: String, redirectUri: String) -> RequestBuilder<GitTokenItem> {
        let path = "/access_token"
        let URLString = GitHubApiAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
                        "client_id": clientId, 
                        "client_secret": clientSecret, 
                        "code": code, 
                        "redirect_uri": redirectUri
        ])
        let nillableHeaders: [String: Any?] = [
                        "Accept": accept
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<GitTokenItem>.Type = GitHubApiAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }
    /**
     Authorize

     - parameter clientId: (query)  
     - parameter redirectUri: (query)  
     - parameter state: (query)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestAuthorize(clientId: String, redirectUri: String, state: String, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        requestAuthorizeWithRequestBuilder(clientId: clientId, redirectUri: redirectUri, state: state).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }

    /**
     Authorize
     - parameter clientId: (query)  
     - parameter redirectUri: (query)  
     - parameter state: (query)  
     - returns: Observable<Void>
     */
    open class func requestAuthorize(clientId: String, redirectUri: String, state: String) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            requestAuthorize(clientId: clientId, redirectUri: redirectUri, state: state) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     Authorize
     - GET /authorize
     - 

     - parameter clientId: (query)  
     - parameter redirectUri: (query)  
     - parameter state: (query)  

     - returns: RequestBuilder<Void> 
     */
    open class func requestAuthorizeWithRequestBuilder(clientId: String, redirectUri: String, state: String) -> RequestBuilder<Void> {
        let path = "/authorize"
        let URLString = GitHubApiAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
                        "client_id": clientId, 
                        "redirect_uri": redirectUri, 
                        "state": state
        ])


        let requestBuilder: RequestBuilder<Void>.Type = GitHubApiAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }
}
