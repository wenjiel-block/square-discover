import Foundation

struct Comment: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let author: UserProfile
    let text: String
    var likeCount: Int
    let createdAt: Date

    init(
        id: UUID = UUID(),
        author: UserProfile,
        text: String,
        likeCount: Int = 0,
        createdAt: Date = .now
    ) {
        self.id = id
        self.author = author
        self.text = text
        self.likeCount = likeCount
        self.createdAt = createdAt
    }

    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: .now)
    }
}
