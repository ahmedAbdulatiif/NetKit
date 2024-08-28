//
//  AlamofireMonitor.swift
//  PremiereCinemas
//
//  Created by Youssef El-Ansary on 13/03/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireMonitor: EventMonitor {
    
    public func requestDidResume(_ request: Request) {
        print("🚀 Running request")
        let httpRequest = request.request
        let url = httpRequest.flatMap { $0.url?.description } ?? "No URL"
        print("HTTP URL: " + url)
        let headers = httpRequest.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? "No HTTP Headers"
        print("HTTP Headers: " + headers)
        let method = httpRequest.flatMap { $0.method.map { $0.rawValue } } ?? "No HTTP Method"
        print("HTTP Method: " + method)
        let endpoint = httpRequest?.urlRequest?.url?.absoluteURL.path ?? "No endpoint"
        print("HTTP Endpoint: " + endpoint)
        print("Request body: ")
        if let httpBody = httpRequest?.urlRequest?.httpBody {
            print(String(decoding: httpBody, as: UTF8.self))
        }
        else {
            print("No Request body")
        }
    }

    public func requestIsRetrying(_ request: Request) {
        let httpRequest = request.request
        print("⚡️Retrying request")
        print(httpRequest.debugDescription)
    }
    
    public func request(_ request: DataRequest,
                        didValidateRequest urlRequest: URLRequest?,
                        response: HTTPURLResponse,
                        data: Data?,
                        withResult result: Request.ValidationResult) {
        print("⚡️⚡️ Response:")
        guard let data = data else {
            print("NULL")
            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            debugPrint(json)
        }
        catch {
            debugPrint("Invalid JSON")
        }
        print("⚡️⚡️ Status code: \(response.statusCode)")
        print(data)
    }
    
    public func request<Value>(_ request: DataRequest,
                               didParseResponse response: DataResponse<Value, AFError>) {
        switch response.result {
        case .success(_):
            print("⚡️ Response parsing finished successfully")
        case .failure(let error):
            print("⚡️ Response parsing finished with error : \n \(String(describing: error.errorDescription))")
        }
    }
    
    public func requestDidSuspend(_ request: Request) {
        print("⚡️ Request Suspended")
    }
    
    public func requestDidCancel(_ request: Request) {
        print("⚡️ Request Cancelled")
    }
}
