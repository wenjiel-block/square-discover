import Foundation

/// Defines the interface for authentication and session management.
protocol AuthServiceProtocol: AnyObject, Sendable {

    /// Whether the user currently has a valid authenticated session.
    var isAuthenticated: Bool { get }

    /// The currently authenticated user, or `nil` if not signed in.
    var currentUser: User? { get }

    /// Authenticates a user with email and password credentials.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The authenticated user.
    func login(email: String, password: String) async throws -> User

    /// Creates a new user account and signs them in.
    /// - Parameters:
    ///   - email: The new user's email address.
    ///   - password: The new user's password.
    ///   - displayName: The display name for the new account.
    /// - Returns: The newly created and authenticated user.
    func signUp(email: String, password: String, displayName: String) async throws -> User

    /// Signs the current user out and clears session data.
    func logout() async throws

    /// Refreshes the current authentication session token.
    func refreshSession() async throws
}
