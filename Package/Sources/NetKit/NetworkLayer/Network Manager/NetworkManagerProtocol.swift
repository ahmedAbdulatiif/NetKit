//
//  NetworkManagerProtocol.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation
import Promises

protocol NetworkManagerProtocol: AnyObject {
    func perform(apiRequest: APIRequestProtocol, provider: APIRequestProviderProtocol) -> Promise<Data>
    func perform(apiRequest: APIRequestProtocol, provider: APIRequestProviderProtocol) async throws -> Data
}
