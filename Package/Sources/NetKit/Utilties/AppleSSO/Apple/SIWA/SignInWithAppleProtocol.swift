//
//  SignInWithAppleProtocol.swift
//  Magento kernel
//
//  Created by Ahmad Mahmoud on 8/22/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import UIKit
import AuthenticationServices

typealias LoginValidityClosure = ((_ isLoggedIn: Bool, _ wasLoggedInBefore: Bool) -> Void)

protocol SignInWithAppleProtocol {

    var siwaButton: UIControl? { get }
    var delegate: SIWADelegate? { get }
    var presentingViewController: UIViewController? { get }

    init(_ siwaButton: UIControl, _ presentingViewController: UIViewController, _ delegate: SIWADelegate)

    func appleSignInTapped()

    func shoudEnableKeychainSignIn() -> Bool

    static func checkForLoginValidity(userID: String, completion: @escaping LoginValidityClosure)
    /*
     This scenario is highly unlikely but still possible,
     what if in the midst of using your app, the user go to the Settings app
     and revoke the Apple sign-in for your app and return to your app, To handle this use case
     We should observe notification with name:
     ASAuthorizationAppleIDProvider.credentialRevokedNotification
     in NotificationCenter to check if user has revoked his sign-in or not.
     */
    static func observeForceLogout(observer: Any, selector: Selector)

    static func logout(completion: @escaping () -> Void)
}
