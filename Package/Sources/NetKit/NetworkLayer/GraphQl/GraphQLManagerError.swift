//
//  GraphQLManagerError.swift
//  Magento kernel
//
//  Created by MSZ on 3/14/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation
enum GraphQLManagerError: Error {

    case errors(errors: [GraphQLError])
    case noInternet(message: String)

    var message: String {
        switch self {
        case .errors(let graphQLErrors):
            return graphQLErrors[0].message
        case .noInternet(let message):
            return message
        }
    }
    var errors: [GraphQLError]? {
        switch self {
        case .errors(let graphQLErrors):
            return graphQLErrors
        case .noInternet:
            return nil
        }
    }
}
