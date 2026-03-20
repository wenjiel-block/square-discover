import Foundation

/// Defines the interface for managing in-app and push notifications.
protocol NotificationServiceProtocol: AnyObject, Sendable {

    /// Fetches notifications for the current user, paginated.
    /// - Parameter page: The page number (1-indexed).
    /// - Returns: An array of notifications for the requested page.
    func fetchNotifications(page: Int) async throws -> [AppNotification]

    /// Marks a single notification as read.
    /// - Parameter notificationId: The unique identifier of the notification.
    func markAsRead(_ notificationId: UUID) async throws

    /// Marks all of the current user's notifications as read.
    func markAllAsRead() async throws

    /// Returns the number of unread notifications for the current user.
    /// - Returns: The unread notification count.
    func unreadCount() async throws -> Int

    /// Registers a device token for push notifications.
    /// - Parameter deviceToken: The APNs device token data.
    func registerForPushNotifications(deviceToken: Data) async throws
}
