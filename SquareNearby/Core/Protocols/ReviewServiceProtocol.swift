import Foundation

/// Defines the interface for reading and writing merchant reviews.
protocol ReviewServiceProtocol: AnyObject, Sendable {

    /// Fetches reviews for a merchant, paginated.
    /// - Parameters:
    ///   - merchantId: The unique identifier of the merchant.
    ///   - page: The page number (1-indexed).
    /// - Returns: An array of reviews for the merchant.
    func fetchReviews(merchantId: UUID, page: Int) async throws -> [Review]

    /// Creates a new review for a merchant.
    /// - Parameters:
    ///   - merchantId: The unique identifier of the merchant being reviewed.
    ///   - rating: The star rating (typically 1-5).
    ///   - text: The review body text.
    ///   - media: Optional media content to attach to the review.
    ///   - menuItemIds: Optional identifiers of menu items referenced in the review.
    /// - Returns: The newly created review.
    func createReview(
        merchantId: UUID,
        rating: Int,
        text: String,
        media: [MediaContent]?,
        menuItemIds: [UUID]?
    ) async throws -> Review

    /// Deletes a review authored by the current user.
    /// - Parameter reviewId: The unique identifier of the review to delete.
    func deleteReview(_ reviewId: UUID) async throws

    /// Likes a review on behalf of the current user.
    /// - Parameter reviewId: The unique identifier of the review to like.
    func likeReview(_ reviewId: UUID) async throws
}
