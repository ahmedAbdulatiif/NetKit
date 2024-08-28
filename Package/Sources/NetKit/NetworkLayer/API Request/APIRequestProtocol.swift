//
//  APIRequestProtocol.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

public protocol APIRequestProtocol: AnyObject, CustomStringConvertible {

    var scheme: String { get }
    var portNumber: Int? { get }
    var baseDomain: String { get }
    var path: String { get }
    var url: URL { get }
    var method: HTTPMethod { get }
    var queryParams: [String: String]? { get }
    var queryBody: Any? { get }
    var headers: [String: String] { get set }
    var authorization: APIAuthorization { get }
    var requestURL: URLRequest { get }

}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
