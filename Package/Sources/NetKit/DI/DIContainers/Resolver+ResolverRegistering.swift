//
//  Resolver+ResolverRegistering.swift
//  Magento kernel
//
//  Created by MSZ on 2/18/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        AppDIContainer.registerAllServices()
    }
}

class AppDIContainer {
    
    public static func registerAllServices() {
        registerNetworkLayer()
        registerServices()
    }
    
}
