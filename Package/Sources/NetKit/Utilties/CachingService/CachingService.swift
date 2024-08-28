//
//  CachingService.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 05/04/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

// MARK: - Cachable
public protocol Cachable {}

extension Int: Cachable {}
extension Double: Cachable {}
extension Bool: Cachable {}
extension String: Cachable {}

// MARK: - CachingService
public protocol CachingService {
    func cacheValue<T: Cachable>(_ value: T, forKey key: String)
    func cacheObject<T: Encodable>(_ obj: T, forKey key: String)
    func value<T: Cachable>(forKey key: String) -> T?
    func object<T: Decodable>(forKey key: String) -> T?
    func deleteValue(forKey key: String)
    func clearCache()
}
