//
//  ServicesContainer.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 28/03/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation

extension AppDIContainer {
    
    static func registerServices() {
        AppResolver.register(scope: .application) {
            AppSessionService(basicCachingService: AppResolver.resolve(name: .basicCaching),
                              secureCachingService: AppResolver.resolve(name: .secureCaching)) as SessionService
        }
        AppResolver.register(scope: .application) {
            AppDecodingService(encodingStrategy: .convertToSnakeCase,
                               decodingStrategy: .convertFromSnakeCase) as DecodingService
        }
        AppResolver.register(name: .basicCaching, scope: .application) {
            BasicCachingService(userDefaults: UserDefaults.standard,
                                decodingService: AppResolver.resolve()) as CachingService
        }
        AppResolver.register(name: .secureCaching, scope: .application) {
            SecureCachingService(keychain: AppResolver.resolve(),
                                 decodingService: AppResolver.resolve()) as CachingService
        }
        AppResolver.register(scope: .application) {
            KeychainSwift() as Keychain
        }
    }
}
