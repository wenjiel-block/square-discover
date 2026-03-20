import Foundation

@Observable
final class NotificationsViewModel {
    var notifications: [AppNotification] = []
    var isLoading: Bool = false
    var error: String?

    @MainActor
    func loadNotifications(using notificationService: any NotificationServiceProtocol) async {
        isLoading = true
        error = nil

        do {
            notifications = try await notificationService.fetchNotifications(page: 1)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    @MainActor
    func markAsRead(id: UUID, using notificationService: any NotificationServiceProtocol) async {
        do {
            try await notificationService.markAsRead(id)
            if let index = notifications.firstIndex(where: { $0.id == id }) {
                notifications[index].markAsRead()
            }
        } catch {
            self.error = error.localizedDescription
        }
    }

    @MainActor
    func markAllAsRead(using notificationService: any NotificationServiceProtocol) async {
        do {
            try await notificationService.markAllAsRead()
            for index in notifications.indices {
                notifications[index].markAsRead()
            }
        } catch {
            self.error = error.localizedDescription
        }
    }

    var hasUnread: Bool {
        notifications.contains { !$0.isRead }
    }
}
