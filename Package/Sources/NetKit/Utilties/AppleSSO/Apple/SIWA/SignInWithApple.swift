//
//  SignInWithApple.swift
//  Magento kernel
//
//  Created by Ahmad Mahmoud on 8/11/20.
//  Copyright © 2020 Robusta. All rights reserved.
//
// Ref: https://fluffy.es/sign-in-with-apple-tutorial-ios/

import UIKit
import AuthenticationServices

/*
 How to use:
 1. Implement : SIWADelegate
 2. Call : SignInWithApple(siwaButton: button, presentingViewController: self, delegate: self) from any view controller.
 */

// This class `SignInWithApple` should be used when implementing sign in with Apple, The other classes: `SupportedSignInWithApple` & `LegacySignInWithApple`, are there to support both old and new iOS versions.
class SignInWithApple {

    private let siwa: SignInWithAppleProtocol

    required init( siwaButton: UIControl, presentingViewController: UIViewController, delegate: SIWADelegate) {
        siwa = SupportedSignInWithApple(siwaButton, presentingViewController, delegate)
    }

    // Call this in AppDelegate
    static func checkForLoginValidity(userID: String, completion: @escaping LoginValidityClosure) {
        SupportedSignInWithApple.checkForLoginValidity(userID: userID, completion: completion)
    }

    // Call this in AppDelegate
    static func observeForceLogout(observer: Any, selector: Selector) {
        SupportedSignInWithApple.observeForceLogout(observer: observer, selector: selector)
    }

    static func logout(completion: @escaping () -> Void) {
        SupportedSignInWithApple.logout(completion: completion)
    }
}
