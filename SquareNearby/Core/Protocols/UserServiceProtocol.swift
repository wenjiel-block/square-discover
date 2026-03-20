import Foundation

/// Defines the interface for user profile management and social interactions.
protocol UserServiceProtocol: AnyObject, Sendable {

    /// Fetches the public profile for a user.
    /// - Parameter userId: The unique identifier of the user.
    /// - Returns: The user's profile.
    func fetchProfile(userId: UUID) async throws -> UserProfile

    /// Updates the current user's profile with the provided data.
    /// - Parameter profile: The updated profile data.
    /// - Returns: The saved user profile as confirmed by the server.
    func updateProfile(_ profile: UserProfile) async throws -> UserProfile

    /// Fetches feed content created by a specific user, paginated.
    /// - Parameters:
    ///   - userId: The unique identifier of the user.
    ///   - page: The page number (1-indexed).
    /// - Returns: An array of feed items authored by the user.
    func fetchUserContent(userId: UUID, page: Int) async throws -> [FeedItem]

    /// Follows a user on behalf of the current user.
    /// - Parameter userId: The unique identifier of the user to follow.
    func followUser(_ userId: UUID) async throws

    /// Unfollows a user on behalf of the current user.
    /// - Parameter userId: The unique identifier of the user to unfollow.
    func unfollowUser(_ userId: UUID) async throws
}
