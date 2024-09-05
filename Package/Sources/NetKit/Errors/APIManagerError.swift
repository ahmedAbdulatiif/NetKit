//
//  APIManagerError.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

public enum APIManagerError: Error {
    case requestFailed(message: String)
    case errorModel(errorModel: APIErrorModel)
    case noInternet(message: String)
    case refreshTokenError(_ reason: String)
    case decodingFailed
    case unknown

    public var message: String {
        switch self {
        case .requestFailed(let message):
            return message
        case .errorModel(let errorModel):
            return errorModel.errorDetail ?? ""
        case .noInternet(let message):
            return message
        case .refreshTokenError(let reason):
            return reason
        case .unknown, .decodingFailed:
            return "APIFailureError".localized
        }
    }
}
