import Combine
import SwiftUI

enum HomeServicesViewState {
    case mainView
    case ready
    case loading
    case error
}

struct HomeServicesView<ViewModel: HomeServicesViewModelProtocol>: View {
    // MARK: - Private Properties

    @ObservedObject private var viewModel: ViewModel

    // MARK: - Initialiser

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    var body: some View {
        view(for: viewModel.state)
    }

    // MARK: - Setup Functions

    @ViewBuilder
    private func view(for state: HomeServicesViewState) -> some View {
        switch state {
        case .ready:
            readyStateView
        case .loading:
            Text("Loading...")
        case .mainView:
            mainContent
        case .error:
            mainContent
        }
    }
}

// MARK: - UI Components

private extension HomeServicesView {
    var mainContent: some View {
        ZStack {
            VStack(alignment: .leading, spacing: ResetPasswordViewConstants.verticalSpacing) {
                VStack(alignment: .leading, spacing: ResetPasswordViewConstants.internalVerticalSpacing) {
                    Text("Enter your new password")
                    errorLabel
                }
                Spacer()
            }.padding(.horizontal, ResetPasswordViewConstants.horizontalPadding)
        }.padding(.top, ResetPasswordViewConstants.topPadding)
    }

    var readyStateView: some View {
        VStack(alignment: .center, spacing: ResetPasswordViewConstants.verticalSpacing) {
            Spacer()
        }.padding(.horizontal, ResetPasswordViewConstants.successMessageHorizontalPadding)
            .padding(.top, ResetPasswordViewConstants.successMessageTopPadding)
    }

    var errorLabel: some View {
         Text("Error")
    }

}

// MARK: - Constants

private enum ResetPasswordViewConstants {
    static let topPadding: CGFloat = 20
    static let verticalSpacing: CGFloat = 20
    static let internalVerticalSpacing: CGFloat = 8
    static let horizontalPadding: CGFloat = 16
    static let instructionFontSize: CGFloat = 18
    static let errorFontSize: CGFloat = 14
    static let textFieldHeight: CGFloat = 50
    static let buttonHeight: CGFloat = 50
    static let successMessageHorizontalPadding: CGFloat = 20
    static let successMessageTopPadding: CGFloat = 20

    static let errorMessageColor: Color = Color.red
}

// MARK: - Constants

private enum HomeServicesViewLocalization {
    static let titke = "homeServices.title".localized
}
