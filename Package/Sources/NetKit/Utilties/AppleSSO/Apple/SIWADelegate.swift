//
//  SIWADelegate.swift
//  Magento kernel
//
//  Created by Ahmad Mahmoud on 8/11/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

protocol SIWADelegate: AnyObject {
    func didGetAppleUser(_ user: AppleUser)
    func didFailToGetAppleUser(_ error: Error)
    func didGetSignInWithAppleError(_ error: String)
}
