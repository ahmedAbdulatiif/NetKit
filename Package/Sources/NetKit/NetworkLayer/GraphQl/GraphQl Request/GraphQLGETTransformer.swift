//
//  GraphQLGETTransformer.swift
//  Magento kernel
//
//  Created by MSZ on 3/10/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

struct GraphQLGETTransformer {

    let body: [String: Any]
    let url: URL

    /// A helper for transforming a GraphQLMap that can be sent with a `POST` request into a URL with query parameters for a `GET` request.
    ///
    /// - Parameters:
    ///   - body: The GraphQLMap to transform from the body of a `POST` request
    ///   - url: The base url to append the query to.
    init(body: [String: Any], url: URL) {
        self.body = body
        self.url = url
    }

    /// Creates the get URL.
    ///
    /// - Returns: [optional] The created get URL or nil if the provided information couldn't be used to access the appropriate parameters.
    func createGetURL() -> URL? {
        guard var components = URLComponents(string: self.url.absoluteString) else {
            return nil
        }

        let queryItems: [URLQueryItem] = []

//        do {
//            _ = try self.body.sorted(by: {$0.key < $1.key}).compactMap({ arg in
//                if let value = arg.value as? GraphQLMap {
//                    let data = try JSONSerialization.dataSortedIfPossible(withJSONObject: value.jsonValue)
//                    if let string = String(data: data, encoding: .utf8) {
//                        queryItems.append(URLQueryItem(name: arg.key, value: string))
//                    }
//                } else if let string = arg.value as? String {
//                    queryItems.append(URLQueryItem(name: arg.key, value: string))
//                } else if arg.key != "variables" {
//                    assertionFailure()
//                }
//            })
//        } catch {
//            return nil
//        }

        components.queryItems = queryItems

        return components.url
    }
}
