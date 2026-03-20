import Foundation

final class MockNotificationService: NotificationServiceProtocol, @unchecked Sendable {
    private let store: MockDataStore

    init(store: MockDataStore) {
        self.store = store
    }

    func fetchNotifications(page: Int) async throws -> [AppNotification] {
        try await Task.sleep(for: .milliseconds(350))
        let pageSize = 10
        let sorted = store.notifications.sorted { $0.createdAt > $1.createdAt }
        let start = (page - 1) * pageSize
        guard start < sorted.count else { return [] }
        let end = min(start + pageSize, sorted.count)
        return Array(sorted[start..<end])
    }

    func markAsRead(_ notificationId: UUID) async throws {
        try await Task.sleep(for: .milliseconds(300))
        guard let index = store.notifications.firstIndex(where: { $0.id == notificationId }) else {
            throw ServiceError.notFound
        }
        store.notifications[index].isRead = true
    }

    func markAllAsRead() async throws {
        try await Task.sleep(for: .milliseconds(400))
        for index in store.notifications.indices {
            store.notifications[index].isRead = true
        }
    }

    func unreadCount() async throws -> Int {
        try await Task.sleep(for: .milliseconds(300))
        return store.notifications.filter { !$0.isRead }.count
    }

    func registerForPushNotifications(deviceToken: Data) async throws {
        try await Task.sleep(for: .milliseconds(300))
        // Mock: acknowledge token registration
    }
}
