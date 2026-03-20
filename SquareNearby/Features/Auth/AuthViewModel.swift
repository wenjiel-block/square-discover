import Foundation

@Observable
final class AuthViewModel {
    var email: String = ""
    var password: String = ""
    var displayName: String = ""
    var isLoading: Bool = false
    var error: String?
    var isLoginMode: Bool = true

    @MainActor
    func login(using authService: any AuthServiceProtocol) async {
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please enter both email and password."
            return
        }

        isLoading = true
        error = nil

        do {
            _ = try await authService.login(email: email, password: password)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    @MainActor
    func signUp(using authService: any AuthServiceProtocol) async {
        guard !displayName.isEmpty else {
            error = "Please enter a display name."
            return
        }
        guard !email.isEmpty, !password.isEmpty else {
            error = "Please enter both email and password."
            return
        }
        guard password.count >= 8 else {
            error = "Password must be at least 8 characters."
            return
        }

        isLoading = true
        error = nil

        do {
            _ = try await authService.signUp(
                email: email,
                password: password,
                displayName: displayName
            )
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    func toggleMode() {
        isLoginMode.toggle()
        error = nil
    }
}
