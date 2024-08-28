

import NetKit
import Foundation

/// `LoginUseCase` is responsible for handling the login process and caching the user.
/// This class demonstrates the use of async functions for performing API requests
/// and caching the result, providing an example of chaining multiple async operations.
class LoginUseCase: BaseUseCase<User> {
    
    /// The request object used to perform the login API call.
    let request: LoginRequest
    
    /// The mapper object used to convert the API response into a `User` entity.
    let mapper: LoginMapper
    
    /// The username provided by the user for login.
    let username: String
    
    /// The password provided by the user for login.
    let password: String
    
    /// Initializes the `LoginUseCase` with the provided username and password.
    /// - Parameters:
    ///   - username: The username provided by the user.
    ///   - password: The password provided by the user.
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.mapper = LoginMapper()
        self.request = LoginRequest(username: username, password: password)
        super.init()
    }
    
    override func process() async throws -> User {
        // Perform the login operation and obtain the user data.
        let user = try await login()
        // Cache the user data locally and return the cached user.
        // This demonstrates the use of two async functions in a single process.
        let cachedUser = try await cache(user: user)
        return cachedUser
    }
    
    private func login() async throws -> User {
        try await perform(apiRequest: request, mapper: mapper)
    }
    
    private func cache(user: User) async throws -> User {
        // Simulating an async cache operation using UserDefaults.
        // This is just a placeholder for demonstration purposes no need for async or throws here.
        let usrdf = UserDefaults.standard
        usrdf.set("user", forKey: "user")
        return user
    }
}
