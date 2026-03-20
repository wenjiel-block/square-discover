import Foundation

/// Defines the interface for fetching and interacting with the social feed.
protocol FeedServiceProtocol: AnyObject, Sendable {

    /// Fetches a paginated feed of items.
    /// - Parameters:
    ///   - page: The page number (1-indexed).
    ///   - pageSize: The number of items per page.
    /// - Returns: An array of feed items for the requested page.
    func fetchFeed(page: Int, pageSize: Int) async throws -> [FeedItem]

    /// Fetches feed items associated with a specific merchant.
    /// - Parameters:
    ///   - merchantId: The unique identifier of the merchant.
    ///   - page: The page number (1-indexed).
    /// - Returns: An array of feed items for the given merchant.
    func fetchFeedForMerchant(_ merchantId: UUID, page: Int) async throws -> [FeedItem]

    /// Likes a feed item on behalf of the current user.
    /// - Parameter feedItemId: The unique identifier of the feed item to like.
    func likeFeedItem(_ feedItemId: UUID) async throws

    /// Removes a like from a feed item on behalf of the current user.
    /// - Parameter feedItemId: The unique identifier of the feed item to unlike.
    func unlikeFeedItem(_ feedItemId: UUID) async throws

    /// Reports a feed item for violating community guidelines.
    /// - Parameters:
    ///   - feedItemId: The unique identifier of the feed item to report.
    ///   - reason: A description of why the item is being reported.
    func reportFeedItem(_ feedItemId: UUID, reason: String) async throws
}
