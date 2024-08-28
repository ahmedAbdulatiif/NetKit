//
//  APIRequestProviderError.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

enum APIRequestProviderError: Error {
    case noInternet(message: String)
    case server(statusCode: Int, data: Data?)
//    case requestFailed(error: Error)

    var reason: String {
        switch self {
//        case .requestFailed (let error):
//            return error.localizedDescription
        case .server(let statusCode, _):
            return "Request Failed with status Code \(statusCode)"
        case .noInternet(let eMessage):
            return eMessage
        }
    }
}
