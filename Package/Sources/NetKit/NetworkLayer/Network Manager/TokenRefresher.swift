//
//  TokenRefresher.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 11/04/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

import Alamofire
import Foundation

typealias AppResult<T> = Swift.Result<T, Error>

class TokenRefresher {
    
    struct NotificationName {
        static let sessionExpired = NSNotification.Name("sessionExpiredChanged")
    }
    
    private let mapper: RefreshTokenMapper
    private let sessionService: SessionService
    private let decodingService: DecodingService
    private(set) var isRefreshing = false
    private let lock: NSLock
    
    init(sessionService: SessionService,
         decodingService: DecodingService) {
        self.sessionService = sessionService
        self.decodingService = decodingService
        self.mapper = RefreshTokenMapper()
        self.lock = NSLock()
    }
    
    /// Refreshes token and saves it to the current session
    func refreshToken(completion: @escaping (_ isSuccess: Bool) -> Void) {
        self.refreshToken { (res: AppResult<CustomerToken>) in
            switch res {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    /// Refreshes token and saves it to the current session
    func refreshToken(completion: @escaping (AppResult<CustomerToken>) -> Void) {
        guard !isRefreshing else { return }
        lock.lock(); defer { lock.unlock() }
        guard let refreshToken = sessionService.loadToken()?.refreshToken else {
            let failureMsg = "Refresh Token Not Found"
            let error: APIManagerError = .refreshTokenError(failureMsg)
            completion(.failure(error))
            print(failureMsg)
            return
        }
        isRefreshing = true
        print("[OperationName: RefreshTokenQuery]")
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        AF.request(request.requestURL).responseData { [weak self] response in
            guard let self = self else { return }
            self.lock.lock(); defer { self.lock.unlock() }
            if let tokens = self.decodeTokens(fromResponse: response) {
                self.cacheTokens(tokens)
                completion(.success(tokens))
            } else {
                let statusCode = response.response?.statusCode ?? -1
                let failureMsg = "Unable to refresh token, Status Code: \(statusCode)"
                self.sessionService.removeAll()
                let error: APIManagerError = .refreshTokenError(failureMsg)
                completion(.failure(error))
                print(failureMsg)
                NotificationCenter.default.post(name: NotificationName.sessionExpired,
                                                object: nil,
                                                userInfo: nil)
            }
            self.isRefreshing = false
        }
    }
    
    /// Decodes given Alamofire response and saves tokens into current user session
    private func decodeTokens(fromResponse response: AFDataResponse<Data>) -> CustomerToken? {
        if let data = response.data {
            return try? mapper.parse(data)
        } else {
            return nil
        }
    }
    
    private func cacheTokens(_ tokens: CustomerToken) {
        sessionService.save(token: tokens)
    }
}
