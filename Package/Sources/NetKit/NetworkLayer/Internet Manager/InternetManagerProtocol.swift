//
//  InternetManagerProtocol.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

protocol InternetManagerProtocol: AnyObject {
    func  isInternetConnectionAvailable () -> Bool
}
