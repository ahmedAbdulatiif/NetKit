//
//  BaseUseCase.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

open class BaseUseCase {
    
    @LazyInjected(name: .graph) private var network: NetworkManagerProtocol
    @LazyInjected(name: .rest) private var restNetwork: NetworkManagerProtocol
    @LazyInjected(name: .magentoCartManager) private var magentoCartManager: NetworkManagerProtocol
    @AppLazyInjected private var internetManager: InternetManagerProtocol
    @AppLazyInjected private var provider: APIRequestProviderProtocol

    public init() {}

    private final func validate() throws {
        guard internetManager.isInternetConnectionAvailable() else {
            throw NSError.noInternet
        }
    }
    
    public func perform<T>(apiRequest: APIRequestProtocol, mapper: BaseMapper<T>) async throws -> T {
        try validate()
        let result = try await restNetwork.perform(apiRequest: apiRequest, provider: self.provider)
        let mappedData = try await mapper.map(result)
        return mappedData
    }
    
    public func perform<T>(apiRequest: APIRequestProtocol, mapper: BaseGraphQLMapper<T>) async throws -> T {
        try validate()
        let result = try await network.perform(apiRequest: apiRequest, provider: self.provider)
        let mappedData = try await mapper.map(result)
        return mappedData
    }
}
