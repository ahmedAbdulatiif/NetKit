import SwiftUI
import Combine

protocol HomeServicesViewModelProtocol: ObservableObject {

    var state: HomeServicesViewState { get }

    func viewAllServices()
}

enum EmailFieldState {
    case active
    case error
    case defaultState
}

final class HomeServicesViewModel: HomeServicesViewModelProtocol {

    // MARK: - Private Properties

    private let servicesUseCase: HomeServicesUseCase

    // MARK: - Internal Properties

    @Published private(set) var state: HomeServicesViewState = .mainView

    // MARK: - Localization

    private(set) lazy var screenTitle = "Screen Title"
    private(set) lazy var headerTitle = "headerTitle"

    // MARK: - Initialiser

    init(servicesUseCase: HomeServicesUseCase) {
        self.servicesUseCase = servicesUseCase
        getAllServices()
    }

    func viewAllServices() {
    
    }

    // MARK: - Private Methods

    private func getAllServices() {
        Task {
            do {
                let fetchedServices = try await servicesUseCase.execute()
                
                DispatchQueue.main.async {
                    self.state = .ready
                    
                }
            } catch {
                DispatchQueue.main.async {
                   
                }
            }
        }
    }

}
