//
//  File.swift
//  
//
//  Created by Ahmed Hussein on 11/08/2024.
//

import Foundation
import NetKit

class LoginMapper: BaseMapper<User> {
    private struct LoginResponse: Decodable {
        let firstname: String?
        let lastname: String?
        let email: String?
    }
    
    override func parse(_ data: Data) throws -> User {
        let response: LoginResponse = try decode(data: data)
        let fullname = [
            response.firstname,
            response.lastname
        ].compactMap { $0 }.joined(separator: " ")
        let email = response.email ?? ""
        return User(name: fullname, email: email)
    }
}
