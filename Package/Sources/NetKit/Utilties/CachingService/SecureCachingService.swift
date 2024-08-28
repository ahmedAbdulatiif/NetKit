//
//  SecureCachingService.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 25/05/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation

class SecureCachingService: CachingService {
    
    private let keychain: Keychain
    private let decodingService: DecodingService
    
    public init(keychain: Keychain,
                decodingService: DecodingService) {
        self.keychain = keychain
        self.decodingService = decodingService
    }
    
    func cacheValue<T: Cachable>(_ value: T, forKey key: String) {
        if let value = value as? Int {
            keychain.set(String(value), forKey: key)
        } else if let value = value as? Double {
            keychain.set(String(value), forKey: key)
        } else if let value = value as? Bool {
            keychain.set(value, forKey: key)
        } else if let value = value as? String {
            keychain.set(value, forKey: key)
        } else {
            fatalError("Type \(String(describing: T.self)) is not handled to be cached/retrieved in KeyChain")
        }
    }
    
    func cacheObject<T: Encodable>(_ obj: T, forKey key: String) {
        guard let data = try? decodingService.encode(obj) else {
            print("Unable to encode data of type \(String(describing: T.self))")
            return
        }
        keychain.set(data, forKey: key)
    }
    
    func value<T: Cachable>(forKey key: String) -> T? {
        if T.self == Bool.self {
            return keychain.getBool(key) as? T
        }
        let stringValue = keychain.get(key) ?? ""
        if T.self == Int.self {
            return Int(stringValue) as? T
        } else if T.self == Double.self {
            return Double(stringValue) as? T
        } else if T.self == String.self {
            return stringValue as? T
        } else {
            fatalError("Type \(String(describing: T.self)) is not handled to be cached/retrieved in KeyChain")
        }
    }
    
    func object<T: Decodable>(forKey key: String) -> T? {
        guard let data: Data = keychain.getData(key) else {
            print("No value found for key \(key) in KeyChain")
            return nil
        }
        guard let object = try? decodingService.decode(data, to: T.self) else {
            print("Value for \(key) found but unable to decode it to \(String(describing: T.self))")
            return nil
        }
        return object
    }
    
    func deleteValue(forKey key: String) {
        keychain.delete(key)
    }
    
    func clearCache() {
        keychain.allKeys.forEach { key in
            keychain.delete(key)
        }
    }
}
