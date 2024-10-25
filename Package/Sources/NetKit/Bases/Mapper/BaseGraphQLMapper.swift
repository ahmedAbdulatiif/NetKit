//
//  BaseMapper.swift
//  NetworkLayer
//
//  Created by Ahmed Hussein on 07/08/2022.
//

import Foundation

open class BaseGraphQLMapper<T> {
    public init() {}
    
    open func parse(_ data: Data) throws -> T {
        fatalError("You must implement this function in the subclass")
    }
    
    public final func map(_ data: Data) async throws -> T {
        // Since map is now async, you can directly call parse, which can throw errors.
        return try parse(data)
    }
    
    public final func decode<OUTPUT: Decodable>(data: Data) throws -> OUTPUT {
        if let graphQlModel = try? JSONDecoder().decode(GraphQlModel<OUTPUT>.self, from: data) {
            if let data = graphQlModel.data, graphQlModel.errors.isEmpty {
                return data
            } else {
                let errors = !graphQlModel.errors.isEmpty ?
                graphQlModel.errors : [GraphQLError("APIFailureError".localized)]
                throw GraphQLManagerError.errors(errors: errors)
            }
        } else {
            #if DEBUG
            do {
                _ = try JSONDecoder().decode(GraphQlModel<OUTPUT>.self, from: data)
            } catch {
                print(String(data: data, encoding: .utf8) ?? "")
                print(OUTPUT.self)
                print(error)
            }
            #endif
            let errors = [GraphQLError("APIFailureError".localized)]
            throw GraphQLManagerError.errors(errors: errors)
        }
    }
}
