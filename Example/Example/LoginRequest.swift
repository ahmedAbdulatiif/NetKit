//
//  File.swift
//  
//
//  Created by Ahmed Hussein on 11/08/2024.
//

import NetKit

class LoginRequest: BaseAPIRequest {
    
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        super.init()
        self.path = "/login"
        self.method = .post
        self.authorization = .bearerToken
    }
    
    override var queryBody: Any? {
        return [
            "username": username,
            "password": password
        ]
    }
}
