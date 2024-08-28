//
//  ErrorModel.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

struct APIErrorModel: APIErrorModelProtocol {

    var code: Int? {
        return mCode
    }

    var errorDetail: String? {
        return mErrorDetail
    }

    var errorType: String? {
        return mErrorType
    }

    let mCode: Int?
    let mErrorDetail: String?
    let mErrorType: String?

    init(code: Int, errorDetail: String) {
        self.mCode = code
        self.mErrorDetail  = errorDetail
        self.mErrorType = ""

    }
}
protocol APIErrorModelProtocol: Codable {

    var code: Int? {get }
    var errorDetail: String? {get}
    var errorType: String? {get}

    init(code: Int, errorDetail: String)
}
