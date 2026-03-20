import Foundation

struct FeedItem: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let author: UserProfile
    let merchant: Merchant
    let content: MediaContent
    let caption: String
    var likeCount: Int
    var commentCount: Int
    var shareCount: Int
    var isLikedByCurrentUser: Bool
    var isSavedByCurrentUser: Bool
    let createdAt: Date
    let menuItemTag: MenuItem?

    init(
        id: UUID = UUID(),
        author: UserProfile,
        merchant: Merchant,
        content: MediaContent,
        caption: String = "",
        likeCount: Int = 0,
        commentCount: Int = 0,
        shareCount: Int = 0,
        isLikedByCurrentUser: Bool = false,
        isSavedByCurrentUser: Bool = false,
        createdAt: Date = .now,
        menuItemTag: MenuItem? = nil
    ) {
        self.id = id
        self.author = author
        self.merchant = merchant
        self.content = content
        self.caption = caption
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.shareCount = shareCount
        self.isLikedByCurrentUser = isLikedByCurrentUser
        self.isSavedByCurrentUser = isSavedByCurrentUser
        self.createdAt = createdAt
        self.menuItemTag = menuItemTag
    }

    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: .now)
    }

    var formattedLikeCount: String {
        Self.formatCount(likeCount)
    }

    var formattedCommentCount: String {
        Self.formatCount(commentCount)
    }

    var formattedShareCount: String {
        Self.formatCount(shareCount)
    }

    var hasEngagement: Bool {
        likeCount > 0 || commentCount > 0 || shareCount > 0
    }

    private static func formatCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return String(format: "%.1fM", Double(count) / 1_000_000)
        } else if count >= 1_000 {
            return String(format: "%.1fK", Double(count) / 1_000)
        }
        return "\(count)"
    }
}
