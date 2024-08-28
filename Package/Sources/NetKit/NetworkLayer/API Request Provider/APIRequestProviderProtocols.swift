//
//  APIRequestProviderProtocols.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

protocol APIRequestProviderProtocol {
    typealias APIRequestCompletion = (_ result: Result<Data, APIRequestProviderError>) -> Void
    func perform(apiRequest: APIRequestProtocol, completion: @escaping APIRequestCompletion)
}
