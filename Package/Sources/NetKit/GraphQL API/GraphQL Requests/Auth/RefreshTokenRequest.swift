//
//  RefreshTokenRequest.swift
//  Magento kernel
//
//  Created by Aya Fayad on 6/17/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

class RefreshTokenRequest: BaseGraphQlRequest {
    
    private let refreshToken: String
    
    init(refreshToken: String) {
        self.refreshToken = refreshToken
        super.init()
    }
    
}
