import Foundation

final class MockReviewService: ReviewServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func fetchReviews(merchantId: UUID, page: Int) async throws -> [Review] {
        try await Task.sleep(for: .milliseconds(400))
        let pageSize = 10
        let merchantReviews = store.reviews[merchantId.uuidString] ?? []
        let sorted = merchantReviews.sorted { $0.createdAt > $1.createdAt }
        let start = (page - 1) * pageSize
        guard start < sorted.count else { return [] }
        let end = min(start + pageSize, sorted.count)
        return Array(sorted[start..<end])
    }

    func createReview(
        merchantId: UUID,
        rating: Int,
        text: String,
        media: [MediaContent]?,
        menuItemIds: [UUID]?
    ) async throws -> Review {
        try await Task.sleep(for: .milliseconds(500))

        guard let currentUser = store.currentUser else {
            throw ServiceError.unauthorized
        }

        let review = Review(
            author: currentUser.profile,
            merchantId: merchantId,
            rating: rating,
            text: text,
            media: media ?? [],
            createdAt: .now
        )

        var merchantReviews = store.reviews[merchantId.uuidString] ?? []
        merchantReviews.insert(review, at: 0)
        store.reviews[merchantId.uuidString] = merchantReviews

        return review
    }

    func deleteReview(_ reviewId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        for (merchantKey, reviews) in store.reviews {
            if let index = reviews.firstIndex(where: { $0.id == reviewId }) {
                var mutable = reviews
                mutable.remove(at: index)
                store.reviews[merchantKey] = mutable
                return
            }
        }
        throw ServiceError.notFound
    }

    func likeReview(_ reviewId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        for (merchantKey, reviews) in store.reviews {
            if let index = reviews.firstIndex(where: { $0.id == reviewId }) {
                var mutable = reviews
                mutable[index].likeCount += 1
                store.reviews[merchantKey] = mutable
                return
            }
        }
        throw ServiceError.notFound
    }
}
