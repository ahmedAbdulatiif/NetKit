//
//  APIRequestProvider.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

class APIRequestProvider: NSObject, APIRequestProviderProtocol {

    @AppLazyInjected var internetManager: InternetManagerProtocol
    @AppLazyInjected var alamofireClient: AlamofireClient

    func perform(apiRequest: APIRequestProtocol,
                 completion: @escaping APIRequestCompletion) {
        guard internetManager.isInternetConnectionAvailable() else {
            completion(Swift.Result<Data, APIRequestProviderError>.failure(.noInternet(message: "NoInternetError".localized)))
            return
        }
        performRequest(apiRequest.requestURL, completion: completion)
    }

    private func performRequest(_ request: URLRequest,
                                completion: @escaping APIRequestCompletion) {
        alamofireClient
            .request(request)
            .validate()
            .responseData(completionHandler: { (response) in
                let statusCode = response.response?.statusCode ?? 404
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(.server(statusCode: statusCode,
                                                data: response.data)))
                }
            })
    }
}
