//
//  Response.swift
//  Magento kernel
//
//  Created by Aya Fayad on 3/21/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

struct CustomerToken: Codable {

    let token: String?
    let refreshToken: String?
}
