import Foundation

struct Review: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let author: UserProfile
    let merchantId: UUID
    let rating: Int
    let text: String
    let media: [MediaContent]
    let menuItemTags: [MenuItem]
    var likeCount: Int
    let createdAt: Date

    init(
        id: UUID = UUID(),
        author: UserProfile,
        merchantId: UUID,
        rating: Int,
        text: String = "",
        media: [MediaContent] = [],
        menuItemTags: [MenuItem] = [],
        likeCount: Int = 0,
        createdAt: Date = .now
    ) {
        self.id = id
        self.author = author
        self.merchantId = merchantId
        self.rating = min(max(rating, 1), 5)
        self.text = text
        self.media = media
        self.menuItemTags = menuItemTags
        self.likeCount = likeCount
        self.createdAt = createdAt
    }

    var starDisplay: String {
        String(repeating: "\u{2605}", count: rating) +
        String(repeating: "\u{2606}", count: 5 - rating)
    }

    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: .now)
    }

    var hasMedia: Bool {
        !media.isEmpty
    }

    var hasMenuItemTags: Bool {
        !menuItemTags.isEmpty
    }
}
