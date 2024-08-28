//
//  GraphqlManger.swift
//  Magento kernel
//
//  Created by MSZ on 3/10/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation
import Promises

class GraphQLApiManager: NetworkManagerProtocol {
    
    @AppLazyInjected private var provider: APIRequestProviderProtocol
    @AppLazyInjected private var userUtilities: SessionService
    @AppLazyInjected private var decodingService: DecodingService
    
    func perform(apiRequest: APIRequestProtocol,
                 provider: APIRequestProviderProtocol) -> Promise<Data> {
        return call(provider: provider, apiRequest: apiRequest)
    }
    
    func perform(apiRequest: APIRequestProtocol, provider: APIRequestProviderProtocol) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            provider.perform(apiRequest: apiRequest, completion: { [weak self] result in
                guard let self = self else { return }
                let validatedResult = self.validate(result: result)
                switch validatedResult {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        }
    }
    
    private func call(provider: APIRequestProviderProtocol, apiRequest: APIRequestProtocol) -> Promise<Data> {
        return Promise<Data>(on: .main) { fulfill, reject in
            print( "OperationName: \(apiRequest.description)")
            provider.perform(apiRequest: apiRequest, completion: { [weak self] result in
                if let result =  self?.validate(result: result) {
                    switch result {
                    case .success(let data):
                        fulfill(data)
                    case .failure(let error):
                        reject(error)
                    }
                }
            })
        }
    }
    
    private func validate(result: Result<Data, APIRequestProviderError>)-> Result<Data, GraphQLManagerError> {
        
        let returnedresult: Result<Data, GraphQLManagerError>
        
        switch result {
        case .failure(let error):
            switch error {
            case .noInternet(let message):
                returnedresult = .failure(.noInternet(message: message))
            case .server(let statusCode, let errorData):
                #if DEBUG
                // not nassesary on graphql beacse all request return 200
                let mssg = "all request should return 200 catch this \(statusCode)"
                let errorData = String(data: errorData ?? Data(), encoding: .utf8) ?? ""
                let errorString = "\(mssg) error: \(errorData)) \(error.message)"
                returnedresult = .failure(.errors(errors: [GraphQLError.init(errorString)]))
                #else
                returnedresult = .failure(.errors(errors: [GraphQLError.init("APIFailureError".localized)]))
                #endif
            }
        case .success(let data):
            returnedresult = .success(data)
        }
        
        return returnedresult
    }
}
