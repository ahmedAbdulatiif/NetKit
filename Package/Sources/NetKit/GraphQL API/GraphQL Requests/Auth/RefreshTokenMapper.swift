//
//  RefreshTokenMapper.swift
//  Mazaya
//
//  Created by Ahmed Hussein on 14/08/2023.
//  Copyright © 2023 Robusta. All rights reserved.
//

import Foundation

class RefreshTokenMapper: BaseGraphQLMapper<CustomerToken> {
    
    private struct LoginResponse: Decodable {
        let customerToken: CustomerTokenResponse?
    }
    
    private struct CustomerTokenResponse: Decodable {
        let token: String
        let refreshToken: String
    }
    
    override func parse(_ data: Data) throws -> CustomerToken {
        let data: LoginResponse = try decode(data: data)
        return CustomerToken (
            token: data.customerToken?.token ?? "",
            refreshToken: data.customerToken?.refreshToken ?? ""
        )
    }
}
