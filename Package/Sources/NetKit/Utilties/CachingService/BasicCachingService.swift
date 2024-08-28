//
//  BasicCachingService.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 05/04/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation

class BasicCachingService: CachingService {
    
    private let userDefaults: UserDefaults
    private let decodingService: DecodingService
    
    public init(userDefaults: UserDefaults,
                decodingService: DecodingService) {
        self.userDefaults = userDefaults
        self.decodingService = decodingService
    }
    
    func cacheValue<T: Cachable>(_ value: T, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func cacheObject<T: Encodable>(_ obj: T, forKey key: String) {
        guard let data = try? decodingService.encode(obj) else {
            print("Unable to encode data of type \(String(describing: T.self))")
            return
        }
        userDefaults.set(data, forKey: key)
    }
    
    func value<T: Cachable>(forKey key: String) -> T? {
        userDefaults.value(forKey: key) as? T
    }
    
    func object<T: Decodable>(forKey key: String) -> T? {
        guard let data: Data = userDefaults.value(forKey: key) as? Data else {
            print("No value found for key \(key) in UserDefaults")
            return nil
        }
        guard let object = try? decodingService.decode(data, to: T.self) else {
            print("Value for \(key) found but unable to decode it to \(String(describing: T.self))")
            return nil
        }
        return object
    }
    
    func deleteValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func clearCache() {
        userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
