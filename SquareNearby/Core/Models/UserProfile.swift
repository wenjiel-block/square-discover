import Foundation

struct UserProfile: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    var displayName: String
    var username: String
    var avatarURL: URL?
    var bio: String?
    var postCount: Int
    var followerCount: Int
    var followingCount: Int

    init(
        id: UUID = UUID(),
        displayName: String,
        username: String,
        avatarURL: URL? = nil,
        bio: String? = nil,
        postCount: Int = 0,
        followerCount: Int = 0,
        followingCount: Int = 0
    ) {
        self.id = id
        self.displayName = displayName
        self.username = username
        self.avatarURL = avatarURL
        self.bio = bio
        self.postCount = postCount
        self.followerCount = followerCount
        self.followingCount = followingCount
    }

    var formattedFollowerCount: String {
        Self.formatCount(followerCount)
    }

    var formattedFollowingCount: String {
        Self.formatCount(followingCount)
    }

    var formattedPostCount: String {
        Self.formatCount(postCount)
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
