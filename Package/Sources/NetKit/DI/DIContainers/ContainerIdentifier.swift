//
//  Identifiers .swift
//  Magento kernel
//
//  Created by MSZ on 3/28/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

extension AppResolverName {
    public static var local = Self("Local")
    public static var remote = Self("remote")

    public static var graph = Self("graph")
    public static var magentoCartManager = Self("magentoCartManager")

    public static var rest = Self("rest")
    
    public static var basicCaching = Self("basicCaching")
    public static var secureCaching = Self("secureCaching")
}
