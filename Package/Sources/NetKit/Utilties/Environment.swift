//
//  Environment.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

public struct Environment {
    
    var isProduction: Bool {
        #if RELEASE
        return true
        #endif
        return false
    }
    
    private var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("Plist file not found")
        }
    }
    
    public func configuration(_ key: PlistKey) -> NSString {
        guard let keyValue = infoDict[key.value()] as? NSString else {
            fatalError("Key \(key.value()) Not founded")
        }
        return keyValue
    }
    
    public func optionalConfiguration(_ key: PlistKey) -> NSString? {
        infoDict[key.value()] as? NSString
    }
    
    public func getBaseURL() -> String {
        let `protocol` = configuration(.urlProtocol)
        let domain = configuration(.baseRestDomain)
        let port = Int(configuration(.port) as String) ?? 0
        let baseUrl = "\(`protocol`)://\(domain)"
        return port == 0 ? baseUrl.appending("/") : baseUrl.appending(":\(port)/")
    }
}
