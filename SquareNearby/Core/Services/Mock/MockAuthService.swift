import Foundation

final class MockAuthService: AuthServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    var isAuthenticated: Bool {
        store.currentUser != nil
    }

    var currentUser: User? {
        store.currentUser
    }

    func login(email: String, password: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(500))

        // Accept any non-empty credentials in mock
        guard !email.isEmpty, !password.isEmpty else {
            throw ServiceError.invalidInput("Email and password are required.")
        }

        let user = MockUsers.loggedInUser
        store.currentUser = user
        return user
    }

    func signUp(email: String, password: String, displayName: String) async throws -> User {
        try await Task.sleep(for: .milliseconds(500))

        guard !email.isEmpty, !password.isEmpty, !displayName.isEmpty else {
            throw ServiceError.invalidInput("All fields are required.")
        }

        let profile = UserProfile(
            displayName: displayName,
            username: displayName.lowercased().replacingOccurrences(of: " ", with: "_"),
            avatarURL: URL(string: "https://picsum.photos/seed/newuser/200/200")
        )

        let user = User(email: email, profile: profile)
        store.currentUser = user
        return user
    }

    func logout() async throws {
        try await Task.sleep(for: .milliseconds(300))
        store.currentUser = nil
    }

    func refreshSession() async throws {
        try await Task.sleep(for: .milliseconds(300))
        // Mock: session is always valid if there is a current user
        guard store.currentUser != nil else {
            throw ServiceError.unauthorized
        }
    }
}
