import Foundation

final class MockFeedService: FeedServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func fetchFeed(page: Int, pageSize: Int) async throws -> [FeedItem] {
        try await Task.sleep(for: .milliseconds(400))
        let start = (page - 1) * pageSize
        let items = store.feedItems
        guard start < items.count else { return [] }
        let end = min(start + pageSize, items.count)
        return Array(items[start..<end])
    }

    func fetchFeedForMerchant(_ merchantId: UUID, page: Int) async throws -> [FeedItem] {
        try await Task.sleep(for: .milliseconds(350))
        let pageSize = 10
        let filtered = store.feedItems.filter { $0.merchant.id == merchantId }
        let start = (page - 1) * pageSize
        guard start < filtered.count else { return [] }
        let end = min(start + pageSize, filtered.count)
        return Array(filtered[start..<end])
    }

    func likeFeedItem(_ feedItemId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        if let index = store.feedItems.firstIndex(where: { $0.id == feedItemId }) {
            store.feedItems[index].isLikedByCurrentUser = true
            store.feedItems[index].likeCount += 1
            store.likedFeedItemIds.insert(feedItemId.uuidString)
        }
    }

    func unlikeFeedItem(_ feedItemId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        if let index = store.feedItems.firstIndex(where: { $0.id == feedItemId }) {
            store.feedItems[index].isLikedByCurrentUser = false
            store.feedItems[index].likeCount = max(0, store.feedItems[index].likeCount - 1)
            store.likedFeedItemIds.remove(feedItemId.uuidString)
        }
    }

    func reportFeedItem(_ feedItemId: UUID, reason: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
        // In a mock, just acknowledge the report silently.
    }
}
