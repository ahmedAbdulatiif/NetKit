//
//  GraphQRequestCreator.swift
//  Magento kernel
//
//  Created by MSZ on 3/10/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation
extension BaseGraphQlRequest {
    func createRequest() throws -> URLRequest {
        let body = requestBody()
        var request = URLRequest(url: self.url)

        switch authorization {
        case .bearerToken:
            if !userUtilities.isGuest() {
                let token = userUtilities.loadToken()?.token ?? ""
                headers.merge( ["Authorization": "Bearer \(token)"]) { (_, new) in new }
            }
        case .none: break
        }
        request.allHTTPHeaderFields = headers

        switch method {
        case .get:
            let transformer = GraphQLGETTransformer(body: body, url: self.url)
            if let urlForGet = transformer.createGetURL() {
                request = URLRequest(url: urlForGet)
                request.httpMethod = method.rawValue
            }
        case .post:
            do {
                let body = (body as [String: Any?]).withNestedNilValuesRemoved()
                request.httpBody = try JSONSerialization.dataSortedIfPossible(withJSONObject: body)
                request.httpMethod = method.rawValue
            }
        default:
            fatalError(" the \(method) method not allowed ")
        }
        return request
    }

    private func requestBody() -> [String: Any?] {
        [
           "variables": variables,
           "operationName": operationName,
           "query": operationDocument
       ]
    }

}
