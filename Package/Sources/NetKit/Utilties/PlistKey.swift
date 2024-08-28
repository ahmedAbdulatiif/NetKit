//
//  PlistKey .swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

public enum PlistKey {

    case baseDomain
    case baseRestDomain
    case timeoutInterval
    case urlProtocol
    case port
    case tokenExpirationCode
    case pageSize

    func value() -> String {
        switch self {
        case .baseDomain: return "BaseDomain"
        case .baseRestDomain: return "BaseRestDomain"
        case .timeoutInterval: return "TimeoutInterval"
        case .urlProtocol: return "URLProtocol"
        case .port: return "Port"
        case .tokenExpirationCode: return "TokenExpirationCode"
        case .pageSize: return "PageSize"
        }
    }
}
