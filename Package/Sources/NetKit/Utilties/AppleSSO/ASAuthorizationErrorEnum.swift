//
//  ASAuthorizationErrorEnum.swift
//  Magento kernel
//
//  Created by Ahmad Mahmoud on 8/11/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

@objc
enum ASAuthorizationErrorEnum: Int {
    case canceled, unknown, invalidResponse, notHandled, failed, revoked
}
