//
//  Error+Extension.swift
//  Magento kernel
//
//  Created by MSZ on 2/18/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

public extension Error {
    var message: String {
        if let apiError = self as? APIManagerError {
            return apiError.message
        } else if let graphQLManagerError = self as? GraphQLManagerError {
            return graphQLManagerError.message
        } else if let apiError = self as? APIRequestProviderError {
            return apiError.reason
        } else {
            let error = self as NSError
            return error.domain
        }
    }

    var isNoInternet: Bool {
        message == "NoInternetError".localized
    }
}
extension NSError {
    static var apiFailureError: NSError {
        NSError(domain: "APIFailureError".localized,
                code: 404,
                userInfo: nil)

    }
    static let cancelError = NSError(domain: "OperationCanceled".localized,
                                     code: 4000,
                                     userInfo: nil)

    static var noInternet: NSError {
        NSError(domain: "NoInternetError".localized,
                code: 5005,
                userInfo: nil)

    }
}
