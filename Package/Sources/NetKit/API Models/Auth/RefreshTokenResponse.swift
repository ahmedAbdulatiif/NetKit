//
//  RefreshToken.swift
//  Magento kernel
//
//  Created by Aya Fayad on 6/17/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

struct RefreshTokenResponse: Decodable {
    let customerToken: CustomerToken?
}
