//
//  UserUtilities.swift
//  Magento kernel
//
//  Created by Aya Fayad on 3/24/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

protocol SessionService {
    /// Saves given token into Keychain
    func save(token: CustomerToken)
    func loadToken() -> CustomerToken?
    func removeToken()
    /// Saves given user into UserDefaults (Make sure that this object does NOT include Sensitive Data)
    func save(user: Customer)
    func loadUser() -> Customer?
    func removeUser()
    func isGuest() -> Bool
    func save(guestCartID: String)
    func removeGuestCartID()
    func loadGuestCartID() -> String?
    func removeAll()
}

class AppSessionService: SessionService {
    
    private let basicCachingService: CachingService
    private let secureCachingService: CachingService
    
    init(basicCachingService: CachingService,
         secureCachingService: CachingService) {
        self.basicCachingService = basicCachingService
        self.secureCachingService = secureCachingService
    }
    
    struct Keys {
        static let user = "user"
        static let token = "userToken"
        static let guestCartID = "guestCartID"
    }

    func save(token: CustomerToken) {
        secureCachingService.cacheObject(token, forKey: Keys.token)
    }

    func loadToken() -> CustomerToken? {
        return secureCachingService.object(forKey: Keys.token)
    }

    func removeToken() {
        secureCachingService.deleteValue(forKey: Keys.token)
    }

    func save(user: Customer) {
        basicCachingService.cacheObject(user, forKey: Keys.user)
    }

    func loadUser() -> Customer? {
        guard !isGuest() else { return nil }
        return basicCachingService.object(forKey: Keys.user)
    }

    func removeUser() {
        basicCachingService.deleteValue(forKey: Keys.user)
    }

    func isGuest() -> Bool {
        let token: String? = secureCachingService.value(forKey: Keys.token)
         return token == nil
    }

    func save(guestCartID: String) {
        basicCachingService.cacheValue(guestCartID, forKey: Keys.guestCartID)
    }

    func loadGuestCartID() -> String? {
        basicCachingService.value(forKey: Keys.guestCartID)
    }

    func removeGuestCartID() {
        basicCachingService.deleteValue(forKey: Keys.guestCartID)
    }

    func removeAll() {
        basicCachingService.clearCache()
        secureCachingService.clearCache()
    }
}
