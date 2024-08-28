//
//  BaseGraphQlRequest.swift
//  Magento kernel
//
//  Created by MSZ on 3/9/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

public protocol GraphQLOperation {
  var operationTypeRowValue: String { get }
  var operationType: GraphQLOperationType { get }
  var operationName: String { get }
  var operationDocument: String { get }
  var variables: [String: Any]? { get }
}

public enum GraphQLOperationType: String {
  case query
  case mutation
  case subscription
}

open class BaseGraphQlRequest: APIRequestProtocol, GraphQLOperation {

    @AppLazyInjected private(set) var userUtilities: SessionService
    public var scheme: String
    public var baseDomain: String
    public var portNumber: Int?
    public var path: String
    public var authorization: APIAuthorization
    public var method: HTTPMethod
    public var headers: [String: String]
    open var queryBody: Any? {
        return nil
    }
    open var queryParams: [String: String]? {
        return [:]
    }
    private var queryItems: [URLQueryItem]? {
        return queryParams?.map({ URLQueryItem.init(name: $0.key, value: $0.value)})
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
        do {
            return try createRequest()
        } catch {
            #if DEBUG
            fatalError(error.localizedDescription)
            #else
            return URLRequest(url: url)
            #endif
        }
    }

    public init() {
        portNumber = Environment().configuration(.port).integerValue
        scheme = "\(Environment().configuration(.urlProtocol))"
        baseDomain = "\(Environment().configuration(.baseDomain))"
        authorization = .none
        headers = ["Content-Type": "application/json",
                   "Store": LanguageHandler.currentLanguage().apiHeaderValue]
        path = "/graphql"
        method = .post
    }

    public func customVariables() -> [String: Any]? {
        return nil
    }

    public var description: String {
        operationName
    }

    public var operationTypeRowValue: String {
        ""
    }
    public var operationType: GraphQLOperationType {
        GraphQLOperationType(rawValue: operationTypeRowValue) ?? .query
    }

    public var operationName: String {
        ""
    }

    public var operationDocument: String {
        ""
    }

    public var variables: [String: Any]? {
        customVariables()
    }

}
