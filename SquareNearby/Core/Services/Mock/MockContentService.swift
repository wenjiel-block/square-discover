import Foundation

final class MockContentService: ContentServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func createPost(
        merchantId: UUID,
        menuItemId: UUID?,
        media: [MediaContent],
        caption: String
    ) async throws -> FeedItem {
        try await Task.sleep(for: .milliseconds(500))

        guard let currentUser = store.currentUser else {
            throw ServiceError.unauthorized
        }

        guard let merchant = store.merchants.first(where: { $0.id == merchantId }) else {
            throw ServiceError.notFound
        }

        guard let firstMedia = media.first else {
            throw ServiceError.invalidInput("At least one media item is required.")
        }

        var menuItemTag: MenuItem?
        if let menuItemId {
            menuItemTag = MockMenuItems.menuItem(for: menuItemId)
        }

        let feedItem = FeedItem(
            author: currentUser.profile,
            merchant: merchant,
            content: firstMedia,
            caption: caption,
            createdAt: .now,
            menuItemTag: menuItemTag
        )

        store.feedItems.insert(feedItem, at: 0)
        return feedItem
    }

    func deletePost(_ postId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        guard let index = store.feedItems.firstIndex(where: { $0.id == postId }) else {
            throw ServiceError.notFound
        }
        store.feedItems.remove(at: index)
    }

    func fetchComments(feedItemId: UUID, page: Int) async throws -> [Comment] {
        try await Task.sleep(for: .milliseconds(350))
        // Return some generated mock comments
        let users = MockUsers.all
        let comments: [Comment] = [
            Comment(
                author: users[1],
                text: "This looks incredible! Adding to my list.",
                likeCount: 12,
                createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: .now)!
            ),
            Comment(
                author: users[2],
                text: "Went here last week and it was just as good as it looks!",
                likeCount: 8,
                createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!
            ),
            Comment(
                author: users[3],
                text: "How long was the wait?",
                likeCount: 3,
                createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: .now)!
            ),
            Comment(
                author: users[5],
                text: "My mouth is watering just looking at this.",
                likeCount: 15,
                createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: .now)!
            ),
            Comment(
                author: users[7],
                text: "Pro tip: go during off-peak hours for no wait!",
                likeCount: 21,
                createdAt: Calendar.current.date(byAdding: .hour, value: -8, to: .now)!
            ),
        ]

        let pageSize = 10
        let start = (page - 1) * pageSize
        guard start < comments.count else { return [] }
        let end = min(start + pageSize, comments.count)
        return Array(comments[start..<end])
    }

    func addComment(feedItemId: UUID, text: String) async throws -> Comment {
        try await Task.sleep(for: .milliseconds(400))

        guard let currentUser = store.currentUser else {
            throw ServiceError.unauthorized
        }

        let comment = Comment(
            author: currentUser.profile,
            text: text,
            createdAt: .now
        )

        // Increment comment count on the feed item
        if let index = store.feedItems.firstIndex(where: { $0.id == feedItemId }) {
            store.feedItems[index].commentCount += 1
        }

        return comment
    }

    func deleteComment(_ commentId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        // Mock: acknowledge deletion
    }
}
