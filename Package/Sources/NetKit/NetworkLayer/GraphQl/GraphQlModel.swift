//
//  GraphQlModel.swift
//  Magento kernel
//
//  Created by MSZ on 3/14/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

struct GraphQlModel<T: Decodable>: Decodable {
    
    var data: T?
    let errors: [GraphQLError]
    
    enum CodingKeys: String, CodingKey {
        case data
        case errors
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try? values.decodeIfPresent(T.self, forKey: .data)
        if let errors = try? values.decodeIfPresent([Any].self, forKey: .errors), errors.count != 0 {
            let errors =  errors.compactMap({ $0 as? [String: Any]})
            self.errors = errors.map({GraphQLError($0)})
        } else {
            self.errors = [GraphQLError]()
        }
    }
    
    func encode(to encoder: Encoder) throws { }
}
