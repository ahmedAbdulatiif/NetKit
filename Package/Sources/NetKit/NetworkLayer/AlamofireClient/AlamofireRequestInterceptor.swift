//
//  AlamofireRequestInterceptor.swift
//  PremiereCinemas
//
//  Created by Youssef El-Ansary on 13/03/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireRequestInterceptor: RequestInterceptor {
    
    // MARK: - Variables
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    //
    private let baseURL: String
    private let refreshTokenFullUrl: String
    private let tokenRefresher: TokenRefresher
    private let sessionService: SessionService
    
    // MARK: - Init
    init(baseURL: String,
         refreshTokenFullUrl: String,
         tokenRefresher: TokenRefresher,
         sessionService: SessionService) {
        self.baseURL = baseURL
        self.refreshTokenFullUrl = refreshTokenFullUrl
        self.tokenRefresher = tokenRefresher
        self.sessionService = sessionService
    }
    
    // MARK: - Adapter
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard !tokenRefresher.isRefreshing else {
            completion(.failure(RefreshingTokenInProgressError()))
            return
        }
        var urlRequest = urlRequest
        setHeaders(forRequest: &urlRequest, setToken: false)
        completion(.success(urlRequest))
    }
    
    // MARK: - Request Retrier
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        if error is RefreshingTokenInProgressError {
            requestsToRetry.append(completion)
            return
        }
        guard shouldRefreshToken(request: request) else {
            completion(.doNotRetryWithError(error))
            return
        }
        requestsToRetry.append(completion)
        self.tokenRefresher.refreshToken { [weak self] (isSuccess: Bool) in
            guard let strongSelf = self else { return }
            guard isSuccess else {
                completion(.doNotRetryWithError(error))
                return
            }
            strongSelf.requestsToRetry.forEach { $0(.retry) }
            strongSelf.requestsToRetry.removeAll()
        }
    }
    
    // MARK: - Private Helpers
    /// If the sent request is to our API and is not a refresh token request to Append default headers
    private func setHeaders(forRequest request: inout URLRequest, setToken: Bool) {
        guard let urlString = request.url?.absoluteString,
              urlString.hasPrefix(baseURL),
              urlString != refreshTokenFullUrl else { return }
        let languageCode = LanguageHandler.currentLanguage().code
        request.setValue(languageCode, forHTTPHeaderField: "Language")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = sessionService.loadToken()?.token, setToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
    
    private func shouldRefreshToken(request: Request) -> Bool {
        let statusCode = request.statusCode ?? 0
        return statusCode == 401 && !sessionService.isGuest()
    }
}
