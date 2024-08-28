//
//  LoggingUtility.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 06/03/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

public func print(_ items: Any...) {
    #if DEBUG || BETA
    Swift.print(items)
    #endif
}
