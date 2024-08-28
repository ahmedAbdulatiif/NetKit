//
//  Network.swift
//  Magento kernel
//
//  Created by MSZ on 2/19/20.
//  Copyright © 2020 MSZ. All rights reserved.
//

extension AppDIContainer {
    
    static func registerNetworkLayer() {
        AppResolver.register(scope: .application) {
            TokenRefresher(sessionService: AppResolver.resolve(),
                           decodingService: AppResolver.resolve())
        }
        AppResolver.register(name: .graph, scope: .application) {
            GraphQLApiManager() as NetworkManagerProtocol
        }
        AppResolver.register(name: .rest, scope: .application) {
            APIManager() as NetworkManagerProtocol
        }
        AppResolver.register(scope: .application) {
            InternetConnectionManager() as InternetManagerProtocol
        }
        AppResolver.register(scope: .application) {
            APIRequestProvider() as APIRequestProviderProtocol
        }
        AppResolver.register(scope: .application) {
            AlamofireClient(interceptor: AppResolver.resolve())
        }
        AppResolver.register(scope: .application) { () -> AlamofireRequestInterceptor in
            let baseURL = Environment().getBaseURL()
            return AlamofireRequestInterceptor(baseURL: baseURL,
                                               refreshTokenFullUrl: baseURL + "", // TODO: Refresh Token Full URL
                                               tokenRefresher: AppResolver.resolve(),
                                               sessionService: AppResolver.resolve())
        }
    }
}
