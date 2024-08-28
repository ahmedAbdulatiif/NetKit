//
//  BaseUseCase.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation
import Promises

open class BaseUseCase<Output> {
    
    @LazyInjected(name: .graph) private var network: NetworkManagerProtocol
    @LazyInjected(name: .rest) private var restNetwork: NetworkManagerProtocol
    @LazyInjected(name: .magentoCartManager) private var magentoCartManager: NetworkManagerProtocol
    @AppLazyInjected private var internetManager: InternetManagerProtocol
    @AppLazyInjected private var provider: APIRequestProviderProtocol

    public init() {}
    
    // it will be injected by UseCase consumer (e.g. presenter)
    open var willProcess: (() -> Void)?

    open func extract() {}

    open func validate() throws {
        guard internetManager.isInternetConnectionAvailable() else {
            throw NSError.noInternet
        }
    }
    
    open func process() async throws -> Output {
        fatalError("You must implement this method in the sub class")
    }
    
    open func process() -> Promise<Output> {
        fatalError("You must implement this method in the sub class")
    }

    public func execute() -> Promise<Output> {
        do {
            extract()
            try validate()
            willProcess?()
            return process()
        } catch let error {
            return Promise<Output>.init(error)
        }
    }
    
    public func execute() async throws -> Output {
        extract()
        try validate()
        willProcess?()
        return try await process()
    }
    
    public func perform<T>(apiRequest: APIRequestProtocol, mapper: BaseGraphQLPromisesMapper<T>) -> Promise<T> {
        network.perform(apiRequest: apiRequest, provider: self.provider).then(mapper.map)
    }
    
    public func perform<T>(apiRequest: APIRequestProtocol, mapper: BasePromisesMapper<T>) -> Promise<T> {
        restNetwork.perform(apiRequest: apiRequest, provider: self.provider).then(mapper.map)
    }
    
    public func perform<T>(apiRequest: APIRequestProtocol, mapper: BaseMapper<T>) async throws -> T {
        let result = try await restNetwork.perform(apiRequest: apiRequest, provider: self.provider)
        let mappedData = try await mapper.map(result)
        return mappedData
    }
    
    public func perform<T>(apiRequest: APIRequestProtocol, mapper: BaseGraphQLMapper<T>) async throws -> T {
        let result = try await network.perform(apiRequest: apiRequest, provider: self.provider)
        let mappedData = try await mapper.map(result)
        return mappedData
    }
}
