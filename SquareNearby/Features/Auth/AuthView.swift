import SwiftUI

struct AuthView: View {
    @State private var viewModel = AuthViewModel()
    @Environment(\.services) private var services

    var body: some View {
        Group {
            if viewModel.isLoginMode {
                LoginView(viewModel: viewModel)
            } else {
                SignUpView(viewModel: viewModel)
            }
        }
        .animation(.easeInOut(duration: Constants.Animation.standard), value: viewModel.isLoginMode)
    }
}

#Preview {
    AuthView()
        .environment(\.services, .mock)
}
