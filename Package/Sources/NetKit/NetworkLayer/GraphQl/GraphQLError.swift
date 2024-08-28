//
//  GraphQLError.swift
//  Magento kernel
//
//  Created by MSZ on 3/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

struct GraphQLError: Error, Codable {
    private var object: [String: Any] = [:]

    enum CodingKeys: String, CodingKey {
        case object = "token"
    }

    public init(_ object: [String: Any]) {
        self.object = object
    }

    init(_ message: String) {
        self.init(["message": message])
    }

    /// GraphQL servers may provide additional entries as they choose to produce more helpful or machine‐readable errors.
    public subscript<T>(key: String) -> T? {
        return object[key] as? T
    }
    public subscript(key: String) -> Any? {
        return object[key]
    }

    /// A description of the error.
    public var message: String {
        self["message"] ?? "API Error"
    }

    /// A list of locations in the requested GraphQL document associated with the error.
    public var locations: [Location]? {
        return (self["locations"] as? [[String: Any]])?.compactMap(Location.init)
    }

    /// A dictionary which services can use however they see fit to provide additional information in errors to clients.
    public var extensions: [String: Any]? {
        return self["extensions"] as? [String: Any]
    }

    /// Represents a location in a GraphQL document.
    public struct Location {
        /// The line number of a syntax element.
        public let line: Int
        /// The column number of a syntax element.
        public let column: Int

        init?(_ object: [String: Any]) {
            guard let line = object["line"] as? Int, let column = object["column"] as? Int else { return nil }
            self.line = line
            self.column = column
        }
    }

    init(from decoder: Decoder) throws {
        self.object = [:]
    }

    func encode(to encoder: Encoder) throws { }

}

extension GraphQLError: CustomStringConvertible {
    public var description: String {
        return self.message
    }
}

extension GraphQLError: LocalizedError {
    public var errorDescription: String? {
        return self.description
    }
}

extension GraphQLError {
    enum Keys: String {
        case userNotAuthorized = "The current customer isn't authorized."
        case allowedToLoggedInOnly = "The request is allowed for logged in customer"
    }
}
