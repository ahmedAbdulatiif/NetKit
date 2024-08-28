//
//  SupportedSignInWithApple.swift
//  Magento kernel
//
//  Created by Ahmad Mahmoud on 8/22/20.
//  Copyright © 2020 Robusta. All rights reserved.
//
//  Ref: https://fluffy.es/sign-in-with-apple-tutorial-ios/

import UIKit
import AuthenticationServices

class SupportedSignInWithApple: NSObject, ASAuthorizationControllerDelegate, SignInWithAppleProtocol {

    private(set) weak var delegate: SIWADelegate?
    private(set) weak var presentingViewController: UIViewController?
    private(set) weak var siwaButton: UIControl?
    private lazy var authorizationController: ASAuthorizationController = {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        var requests: [ASAuthorizationRequest] = [request]
        if shoudEnableKeychainSignIn() {
            let authorizationPasswordProvider = ASAuthorizationPasswordProvider()
            let authorizationPasswordRequest = authorizationPasswordProvider.createRequest()
            requests.append(authorizationPasswordRequest)
        }
        return ASAuthorizationController(authorizationRequests: requests)
    }()
    // Just for shortening the protocol name since it is too long.
    private typealias ASACPP = ASAuthorizationControllerPresentationContextProviding

    required init(_ siwaButton: UIControl,
                  _ presentingViewController: UIViewController,
                  _ delegate: SIWADelegate) {
        super.init()
        self.delegate = delegate
        self.siwaButton = siwaButton
        self.presentingViewController = presentingViewController
        self.siwaButton!.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
    }

    // ASAuthorizationControllerDelegate Delegates
    /*
     The reason email and name might be nil is that user
     might decline to reveal these information during the Apple sign-in prompt,
     or the user has already signed in previously.
     If a user has previously signed in to your app using Apple ID,
     and he tap on the "Sign in with Apple" button again, the dialog will look different
     and when the user sign in this time, didCompleteWithAuthorization will be called as expected,
     but the email and name will be nil, as Apple expects your app to have already
     store the user's name and email when user first logged in.
     This behaviour is confirmed by Apple staff in this disccusion :
     https://forums.developer.apple.com/thread/121496#379297
     Note:
     Even deleting the app and installing again won't make your app able to
     retrieve back the name and email attributes of user but we can reset this behaviour by
     revoking the Apple Sign-In permission in from the phone Settings.
     */
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        /*
         The reason of using the code if let casting condition, is to cast the authorization
         credential as ASAuthorizationAppleIDCredential.
         There are other types of credentials such as
         Single-Sign-On for enterprise (ASAuthorizationSingleSignOnCredential),
         or password based credential (ASPasswordCredential)
         **/
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let appleUser = appleIDCredential.toAppleUser()
            delegate?.didGetAppleUser(appleUser)
        } else if let applePasswordCredential = authorization.credential as? ASPasswordCredential {
            // Do anything with the password.
        }
    }

    func shoudEnableKeychainSignIn() -> Bool { return false }

    @objc func appleSignInTapped() {
        // Show Sign-in with Apple dialog
        do {
            try getASAuthorizationController().performRequests()
        } catch {
            print("SIWA Error " + error.localizedDescription)
        }
    }

    private func getASAuthorizationController() throws -> ASAuthorizationController {
        // This will ask the view controller which window to present the ASAuthorizationController
        if let authPresentationController = presentingViewController as? ASACPP {
            authorizationController.presentationContextProvider = authPresentationController
            authorizationController.delegate = self
            return authorizationController
        }
        let viewControllerName = String(describing: type(of: presentingViewController))
        let errorMessage = "You need to make your view controller " + viewControllerName + "conform to ASAuthorizationControllerPresentationContextProviding protocol"
        throw NSError(domain: errorMessage, code: 0)
    }

    static func checkForLoginValidity(userID: String,
                                      completion: @escaping (_ isLoggedIn: Bool, _ wasLoggedInBefore: Bool) -> Void) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: { credentialState, _ in
            switch credentialState {
            case .authorized:
                print("User remains logged in")
                completion(true, true)
            case .revoked:
                print("User logged in before but revoked")
                completion(false, true)
            case .notFound:
                print("User wasn't logged in before")
                completion(false, false)
            default:
                print("Unknown state")
                completion(false, false)
            }
        })
    }

    // Sometimes, this function returns error for a valid user ID. (May happens if you are testing with iPhone simulator)
    // Ref: https://stackoverflow.com/questions/61952355/sign-in-with-apple-asauthorizationappleidprovider-already-signed-in-but-notfou
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else {
            return
        }
        let errorType: ASAuthorizationErrorEnum
        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
            errorType = .canceled
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
            errorType = .unknown
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Respone")
            errorType = .invalidResponse
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
            errorType = .notHandled
        case .failed:
            // authorization failed
            print("Failed")
            errorType = .failed
        @unknown default:
            print("Default")
            errorType = .unknown
        }
        delegate?.didFailToGetAppleUser(error)
    }

    static func observeForceLogout(observer: Any, selector: Selector) {
        // Call the function appleIDStateRevoked if user revoke the sign in in Settings app
        let notificationKey = ASAuthorizationAppleIDProvider.credentialRevokedNotification
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: notificationKey,
                                               object: nil)
    }

    static func logout(completion: @escaping () -> Void) {
        // ToDo :- To implement
    }
}
