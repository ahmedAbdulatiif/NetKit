import NetKit
import Foundation

/// `HomeServicesUseCase` is responsible for handling the retrieval of home services and caching them.
/// This class demonstrates the use of async functions for performing API requests
/// and caching the result, providing an example of chaining multiple async operations.
class HomeServicesUseCase: BaseUseCase<[Service]> {
    
    /// The request object used to perform the API call to fetch home services.
    let request: HomeServicesRequest
    
    /// The mapper object used to convert the API response into a list of `Service` entities.
    let mapper: HomeServicesMapper
    
    /// The number of items to be retrieved for home services.
    let numberOfItems: String
    
    /// Initializes the `HomeServicesUseCase` with the provided number of items.
    /// - Parameters:
    ///   - numberOfItems: The number of items to be retrieved for home services.
    init(numberOfItems: String) {
        self.numberOfItems = numberOfItems
        self.mapper = HomeServicesMapper()
        self.request = HomeServicesRequest(numberOfItems: numberOfItems)
        super.init()
    }
    
    /// Processes the retrieval and caching of home services.
    /// - Returns: An array of `Service` objects after being processed and cached.
    override func process() async throws -> [Service] {
        // Perform the operation to retrieve the home services data.
        let services = try await fetchHomeServices()
        // Cache the services data locally and return the cached services.
        // This demonstrates the use of two async functions in a single process.
        let cachedServices = try await cache(services: services)
        return cachedServices
    }
    
    /// Performs the API request to fetch home services.
    /// - Returns: An array of `Service` objects obtained from the API response.
    private func fetchHomeServices() async throws -> [Service] {
        try await perform(apiRequest: request, mapper: mapper)
    }
    
    /// Caches the retrieved services data locally.
    /// - Parameters:
    ///   - services: The list of services to be cached.
    /// - Returns: The same list of services after caching (for demonstration purposes).
    private func cache(services: [Service]) async throws -> [Service] {
        // Simulating an async cache operation using UserDefaults.
        // This is just a placeholder for demonstration purposes; no need for async or throws here.
        let usrdf = UserDefaults.standard
        usrdf.set(services, forKey: "services")
        return services
    }
}
