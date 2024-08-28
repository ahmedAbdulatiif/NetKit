//
//  APIAuthorization.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

public enum APIAuthorization {
    
    case none
    case bearerToken
    
    var authData: [String: String] {
        switch self {
        case .none:
            return [:]
        case .bearerToken:
            let sessionService: SessionService = AppResolver.resolve()
            let token = sessionService.loadToken()?.token ?? ""
            print("token: \(token)")
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
