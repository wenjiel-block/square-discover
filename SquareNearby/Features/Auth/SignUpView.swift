import SwiftUI

struct SignUpView: View {
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

                Text("Create Account")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(Color.brandSecondary)

                Text("Join the local food community")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 48)

            // Form Fields
            VStack(spacing: 16) {
                TextField("Display Name", text: $viewModel.displayName)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 12))

                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 12))

                SecureField("Password", text: $viewModel.password)
                    .textContentType(.newPassword)
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

            // Sign Up Button
            Button {
                Task {
                    await viewModel.signUp(using: services.authService)
                }
            } label: {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Create Account")
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

            // Toggle to Login
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundStyle(.secondary)

                Button("Log In") {
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
    SignUpView(viewModel: AuthViewModel())
        .environment(\.services, .mock)
}
