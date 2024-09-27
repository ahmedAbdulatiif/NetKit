//
//  BaseAPIRequest.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

open class BaseAPIRequest: APIRequestProtocol {

    public var scheme: String
    public var baseDomain: String
    public var portNumber: Int?
    public var path: String
    public var authorization: APIAuthorization
    public var method: HTTPMethod
    public var headers: [String: String]
    public var cachePolicy: NSURLRequest.CachePolicy
    open var queryBody: Any? {
        return nil
    }
    open var queryParams: [String: String]? {
        return [:]
    }
    private var queryItems: [URLQueryItem]? {
        return queryParams?.map({ URLQueryItem(name: $0.key, value: $0.value) })
    }
    public var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.port = portNumber
        urlComponents.path = "\(self.path)"
        urlComponents.host = self.baseDomain
        urlComponents.queryItems = self.queryItems
        return urlComponents.url!
    }
    public var requestURL: URLRequest {
        let timeoutInterval: Double = Environment().configuration(.timeoutInterval).doubleValue
        var request = URLRequest(url: self.url,
                                 cachePolicy: cachePolicy,
                                 timeoutInterval: timeoutInterval)
        switch authorization {
        case .bearerToken:
            headers.merge(authorization.authData) { (_, new) in new }
        case .none:
            break
        }
        request.allHTTPHeaderFields = headers
        request.httpMethod = self.method.rawValue
        var bodyData: Data?
        if let queryBody = self.queryBody as? [String: Any] {
            bodyData = try? JSONSerialization.data(withJSONObject: queryBody, options: [])
        } else if let queryBody = self.queryBody as? String {
            bodyData = queryBody.data(using: .utf8)
        }
        request.httpBody = bodyData
        return request
    }
    public var description: String {
        "RequestURL : \(requestURL.url?.absoluteString ?? "")"
    }
    
    public init() {
        portNumber = Environment().optionalConfiguration(.port)?.integerValue
        scheme = "\(Environment().configuration(.urlProtocol))"
        baseDomain = "\(Environment().configuration(.baseDomain))"
        authorization = .none
        headers = ["Content-Type": "application/json"]
        path = ""
        method = .get
        cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }
}
