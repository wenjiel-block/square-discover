import Foundation

final class MockUserService: UserServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func fetchProfile(userId: UUID) async throws -> UserProfile {
        try await Task.sleep(for: .milliseconds(350))
        guard let profile = MockUsers.all.first(where: { $0.id == userId }) else {
            throw ServiceError.notFound
        }
        return profile
    }

    func updateProfile(_ profile: UserProfile) async throws -> UserProfile {
        try await Task.sleep(for: .milliseconds(400))
        if var user = store.currentUser, user.profile.id == profile.id {
            user.profile = profile
            store.currentUser = user
        }
        return profile
    }

    func fetchUserContent(userId: UUID, page: Int) async throws -> [FeedItem] {
        try await Task.sleep(for: .milliseconds(400))
        let pageSize = 10
        let filtered = store.feedItems.filter { $0.author.id == userId }
        let start = (page - 1) * pageSize
        guard start < filtered.count else { return [] }
        let end = min(start + pageSize, filtered.count)
        return Array(filtered[start..<end])
    }

    func followUser(_ userId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        // Mock: just acknowledge the follow
    }

    func unfollowUser(_ userId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        // Mock: just acknowledge the unfollow
    }
}
