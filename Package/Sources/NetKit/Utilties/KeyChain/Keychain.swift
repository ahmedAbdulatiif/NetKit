//
//  Keychain.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 25/05/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation

protocol Keychain {
    var allKeys: [String] { get }
    func get(_ key: String) -> String?
    func getBool(_ key: String) -> Bool?
    func getData(_ key: String, asReference: Bool) -> Data?
    @discardableResult
    func set(_ value: Data, forKey key: String, withAccess access: KeychainSwiftAccessOptions?) -> Bool
    @discardableResult
    func set(_ value: String, forKey key: String, withAccess access: KeychainSwiftAccessOptions?) -> Bool
    @discardableResult
    func set(_ value: Bool, forKey key: String, withAccess access: KeychainSwiftAccessOptions?) -> Bool
    @discardableResult
    func delete(_ key: String) -> Bool
}

extension Keychain {
    
    func getData(_ key: String) -> Data? {
        getData(key, asReference: false)
    }
    
    @discardableResult
    func set(_ value: Data, forKey key: String) -> Bool {
        set(value, forKey: key, withAccess: nil)
    }
    
    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool {
        set(value, forKey: key, withAccess: nil)
    }
    
    @discardableResult
    func set(_ value: Bool, forKey key: String) -> Bool {
        set(value, forKey: key, withAccess: nil)
    }
}
