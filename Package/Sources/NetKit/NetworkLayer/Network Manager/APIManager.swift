//
//  APIManager.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

class APIManager: NetworkManagerProtocol {
    
    @AppLazyInjected private var decodingService: DecodingService
    
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

    private func validate(result: Result<Data, APIRequestProviderError>) -> Result<Data, APIManagerError> {

        let returnedresult: Result<Data, APIManagerError>

        switch result {
        case .failure(let error):
            switch error {
            case .noInternet(let message):
                returnedresult = .failure(.noInternet(message: message))
            case .server(let statusCode, let data):
                if let data = data,
                   let error = try? decodingService.decode(data, to: APIErrorModel.self) {
                    returnedresult = .failure(.errorModel(errorModel: error))
                } else {
                    let error = APIErrorModel(code: statusCode, errorDetail: "APIFailureError".localized)
                    returnedresult = .failure(.errorModel(errorModel: error))
                }
            }
        case .success(let data):
            returnedresult = .success(data)
        }
        return returnedresult
    }

}
