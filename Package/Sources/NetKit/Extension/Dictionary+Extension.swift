//
//  Dictionary+Extension.swift
//  El-Araby
//
//  Created by MSZ on 6/7/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any? {
    func withNestedNilValuesRemoved() -> [String: Any] {
        var filtered = [String: Any]()
        for (key, value) in self {
            if value != nil && !(value is NSNull) {
                if let value  = value as? [String: Any?] {
                    let value  = value.withNestedNilValuesRemoved()
                    if value.count != 0 {
                        filtered[key] = value
                    }
                } else {
                    filtered[key] = value
                }
            }
        }
        return filtered
    }
}
