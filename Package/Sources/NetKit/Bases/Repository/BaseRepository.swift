//
//  BaseRepository.swift
//  Mazaya
//
//  Created by Ahmed Hussein on 20/07/2023.
//  Copyright © 2023 Robusta. All rights reserved.
//

import Foundation

open class BaseRepository {
    @LazyInjected(name: .graph) var network: NetworkManagerProtocol
    @AppLazyInjected var provider: APIRequestProviderProtocol
    
    open func invalidateCache() {}
}
