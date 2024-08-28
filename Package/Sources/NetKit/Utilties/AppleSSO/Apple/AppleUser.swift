//
//  AppleUser.swift
//  Magento kernel
//
//  Created by Ahmad Mahmoud on 8/11/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

struct AppleUser: CustomStringConvertible {

    var userID: String!
    var email: String?
    // Also the given name
    var firstName: String?
    // Also the family name
    var lastName: String?
    var nickName: String?
    /* Token (Identity token) is useful for server side, the app can send the token and authorizationCode to the server for verification purpose.
     */
    var token: String?
    var authorizationCode: String?
    var description: String {

        return "\(firstName ?? "") \(lastName ?? "") \n \(userID ?? "") \n \(email ?? "") \n \(token ?? "")"
    }

}
import AuthenticationServices

@available(iOS 13.0, *)
extension ASAuthorizationAppleIDCredential {
    func toAppleUser() -> AppleUser {
        let appleIDCredential = self
        var appleUser = AppleUser()
        // unique ID for each user, this uniqueID will always be returned
        let userID = appleIDCredential.user
        appleUser.userID = userID
        /*
         If the user choose to hide their email,
         Apple will generate a private relay email address for them,
         which ends with @privaterelay.apple.id.com, you can send email to
         this email address and Apple will forward it to the actual user's email.
         */
        // optional, might be nil
        let email = appleIDCredential.email
        appleUser.email = email
        // optional, might be nil
        let givenName = appleIDCredential.fullName?.givenName
        appleUser.firstName = givenName
        // optional, might be nil
        let familyName = appleIDCredential.fullName?.familyName
        appleUser.lastName = familyName
        // optional, might be nil
        let nickName = appleIDCredential.fullName?.nickname
        appleUser.nickName = nickName
        // IdentityToken is useful for server side, The App can send the identityToken
        // and authorizationCode to the server for verification purpose.
        if let token = appleIDCredential.identityToken {
            let identityToken = String(bytes: token, encoding: .utf8)
            appleUser.token = identityToken
        }
        if let code = appleIDCredential.authorizationCode {
            let authorizationCode = String(bytes: code, encoding: .utf8)
            appleUser.authorizationCode = authorizationCode
        }
        return appleUser
    }
}
