import Foundation

struct User: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let email: String
    var profile: UserProfile
    let createdAt: Date

    init(
        id: UUID = UUID(),
        email: String,
        profile: UserProfile,
        createdAt: Date = .now
    ) {
        self.id = id
        self.email = email
        self.profile = profile
        self.createdAt = createdAt
    }

    var memberSince: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: createdAt)
    }
}
