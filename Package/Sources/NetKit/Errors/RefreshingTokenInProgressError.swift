//
//  RefreshingTokenInProgressError.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 19/04/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation

/// Error indicates that you are trying to fire an HTTP request while token is being refreshed
struct RefreshingTokenInProgressError: Error {}
