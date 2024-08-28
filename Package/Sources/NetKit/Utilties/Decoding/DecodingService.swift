//
//  DecodingService.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 03/04/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation

public protocol DecodingService {
    typealias EncodingStrategy = JSONEncoder.KeyEncodingStrategy
    typealias DecodingStrategy = JSONDecoder.KeyDecodingStrategy
    var encoder: JSONEncoder { get }
    var encodingStrategy: EncodingStrategy { get }
    var decoder: JSONDecoder { get }
    var decodingStrategy: DecodingStrategy { get }
    func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T
    func decodeReturningNilOnFailure<T: Decodable>(_ data: Data, to: T.Type) -> T?
    func decodeToDictionary(_ data: Data) throws -> [String: Any]
    func decodeToDictionaryReturningNilOnFailure(_ data: Data) -> [String: Any]?
    func encode<T: Encodable>(_ obj: T) throws -> Data
    func encodeReturningNilOnFailure<T: Encodable>(_ obj: T) -> Data?
}

open class AppDecodingService: DecodingService {
    
    public var encoder: JSONEncoder { self._encoder }
    public var encodingStrategy: EncodingStrategy {
        self._encodingStrategy
    }
    public var decoder: JSONDecoder { self._decoder }
    public var decodingStrategy: DecodingStrategy {
        self._decodingStrategy
    }
    //
    private let _encodingStrategy: EncodingStrategy
    private let _decodingStrategy: DecodingStrategy
    private lazy var _encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = self.encodingStrategy
        return encoder
    }()
    private lazy var _decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = self.decodingStrategy
        return decoder
    }()
    
    public init(encodingStrategy: EncodingStrategy,
                decodingStrategy: DecodingStrategy) {
        self._encodingStrategy = encodingStrategy
        self._decodingStrategy = decodingStrategy
    }
    
    public func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        return try decoder.decode(type.self, from: data)
    }
    
    public func decodeReturningNilOnFailure<T: Decodable>(_ data: Data, to type: T.Type) -> T? {
        do {
            return try self.decode(data, to: type)
        } catch {
            print(error)
            return nil
        }
    }
    
    public func decodeToDictionary(_ data: Data) throws -> [String: Any] {
        guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw UnKnownError(reason: "Casting to dict failed")
        }
        return dict
    }
    
    public func decodeToDictionaryReturningNilOnFailure(_ data: Data) -> [String: Any]? {
        do {
            return try self.decodeToDictionary(data)
        } catch {
            print(error)
            return nil
        }
    }
    
    public func encode<T: Encodable>(_ obj: T) throws -> Data {
        return try encoder.encode(obj)
    }
    
    public func encodeReturningNilOnFailure<T: Encodable>(_ obj: T) -> Data? {
        do {
            return try encoder.encode(obj)
        } catch {
            print(error)
            return nil
        }
    }
}
