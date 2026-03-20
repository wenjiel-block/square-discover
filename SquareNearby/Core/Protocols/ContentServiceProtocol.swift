import Foundation

/// Defines the interface for creating and managing user-generated content (posts and comments).
protocol ContentServiceProtocol: AnyObject, Sendable {

    /// Creates a new post (feed item) associated with a merchant and optionally a menu item.
    /// - Parameters:
    ///   - merchantId: The unique identifier of the merchant featured in the post.
    ///   - menuItemId: An optional identifier of a specific menu item being highlighted.
    ///   - media: The media content (images/videos) for the post.
    ///   - caption: The text caption for the post.
    /// - Returns: The newly created feed item.
    func createPost(
        merchantId: UUID,
        menuItemId: UUID?,
        media: [MediaContent],
        caption: String
    ) async throws -> FeedItem

    /// Deletes a post authored by the current user.
    /// - Parameter postId: The unique identifier of the post to delete.
    func deletePost(_ postId: UUID) async throws

    /// Fetches comments on a feed item, paginated.
    /// - Parameters:
    ///   - feedItemId: The unique identifier of the feed item.
    ///   - page: The page number (1-indexed).
    /// - Returns: An array of comments for the feed item.
    func fetchComments(feedItemId: UUID, page: Int) async throws -> [Comment]

    /// Adds a comment to a feed item.
    /// - Parameters:
    ///   - feedItemId: The unique identifier of the feed item to comment on.
    ///   - text: The comment text.
    /// - Returns: The newly created comment.
    func addComment(feedItemId: UUID, text: String) async throws -> Comment

    /// Deletes a comment authored by the current user.
    /// - Parameter commentId: The unique identifier of the comment to delete.
    func deleteComment(_ commentId: UUID) async throws
}
