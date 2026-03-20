import SwiftUI

struct LoginView: View {
    @Bindable var viewModel: AuthViewModel
    @Environment(\.services) private var services

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Brand Header
            VStack(spacing: 12) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.brandPrimary)

                Text("Square Nearby")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(Color.brandSecondary)

                Text("Discover local flavors")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 48)

            // Form Fields
            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 12))

                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                    .padding()
                    .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)

            // Error Message
            if let error = viewModel.error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .padding(.horizontal, Constants.Layout.horizontalPadding)
            }

            // Login Button
            Button {
                Task {
                    await viewModel.login(using: services.authService)
                }
            } label: {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Login")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(Color.brandPrimary, in: RoundedRectangle(cornerRadius: 12))
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .padding(.top, 24)

            Spacer()

            // Toggle to Sign Up
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .foregroundStyle(.secondary)

                Button("Sign Up") {
                    viewModel.toggleMode()
                }
                .fontWeight(.semibold)
                .foregroundStyle(Color.brandPrimary)
            }
            .font(.subheadline)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
        .environment(\.services, .mock)
}
