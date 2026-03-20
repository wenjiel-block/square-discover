import Foundation

enum NotificationType: String, Codable, Hashable, Sendable {
    case orderUpdate
    case newContent
    case newFollower
    case newLike
    case newComment
    case promotion

    var systemImage: String {
        switch self {
        case .orderUpdate: return "bag.fill"
        case .newContent: return "play.rectangle.fill"
        case .newFollower: return "person.badge.plus"
        case .newLike: return "heart.fill"
        case .newComment: return "bubble.left.fill"
        case .promotion: return "tag.fill"
        }
    }

    var displayName: String {
        switch self {
        case .orderUpdate: return "Order Update"
        case .newContent: return "New Content"
        case .newFollower: return "New Follower"
        case .newLike: return "New Like"
        case .newComment: return "New Comment"
        case .promotion: return "Promotion"
        }
    }
}

struct AppNotification: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let type: NotificationType
    let title: String
    let body: String
    let imageURL: URL?
    let deepLink: String?
    var isRead: Bool
    let createdAt: Date

    init(
        id: UUID = UUID(),
        type: NotificationType,
        title: String,
        body: String,
        imageURL: URL? = nil,
        deepLink: String? = nil,
        isRead: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.imageURL = imageURL
        self.deepLink = deepLink
        self.isRead = isRead
        self.createdAt = createdAt
    }

    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: .now)
    }

    mutating func markAsRead() {
        isRead = true
    }
}
