//
//  ErrorModel.swift
//  Magento kernel
//
//  Created by MSZ on 2/13/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

public struct APIErrorModel: APIErrorModelProtocol {

    public var code: Int? {
        return mCode
    }

    public var errorDetail: String? {
        return mErrorDetail
    }

    public var errorType: String? {
        return mErrorType
    }

    private let mCode: Int?
    private let mErrorDetail: String?
    private let mErrorType: String?

    public init(code: Int, errorDetail: String) {
        self.mCode = code
        self.mErrorDetail  = errorDetail
        self.mErrorType = ""
    }
}

public protocol APIErrorModelProtocol: Codable {
    var code: Int? { get }
    var errorDetail: String? { get }
    var errorType: String? { get }

    init(code: Int, errorDetail: String)
}
