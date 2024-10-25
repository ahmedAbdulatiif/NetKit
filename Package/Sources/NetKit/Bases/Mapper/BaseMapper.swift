//
//  BaseMapper.swift
//  NetworkLayer
//
//  Created by Ahmed Hussein on 07/08/2022.
//

import Foundation

open class BaseMapper<T> {
    public init() {}
    
    open func parse(_ data: Data) throws -> T {
        fatalError("You must implement this function in the subclass")
    }
    
    public final func map(_ data: Data) async throws -> T {
        // You can simply call parse, as `map` is now async and can throw
        return try parse(data)
    }
    
    public final func decode<OUTPUT: Decodable>(data: Data) throws -> OUTPUT {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try jsonDecoder.decode(OUTPUT.self, from: data)
        } catch let error {
            print(error)
            throw APIManagerError.decodingFailed
        }
    }
}
