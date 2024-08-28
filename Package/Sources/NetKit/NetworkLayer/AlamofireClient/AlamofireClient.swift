//
//  AlamofireClient.swift
//  PremiereCinemas
//
//  Created by Youssef El-Ansary on 13/03/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireClient {
    
    private lazy var session = createAlamofireSession()
    private let interceptor: AlamofireRequestInterceptor
    
    init(interceptor: AlamofireRequestInterceptor) {
        self.interceptor = interceptor
    }
    
    func request(_ request: URLRequest) -> DataRequest {
        session.request(request)
    }
    
    private func createAlamofireSession() -> Alamofire.Session {
        let monitor = AlamofireMonitor()
        return Session(configuration: getURLSessionConfiguration(),
                       interceptor: interceptor,
                       eventMonitors: [monitor])
    }
    
    open func getURLSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.af.default
        let timeoutInterval = Double(Environment().configuration(.timeoutInterval) as String)!
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.allowsCellularAccess = true
        return configuration
    }
}

extension Alamofire.Request {
    
    var statusCode: Int? {
        (task?.response as? HTTPURLResponse)?.statusCode
    }
}
