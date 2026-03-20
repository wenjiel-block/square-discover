import Foundation

struct MockUsers {
    // MARK: - Stable User IDs

    static let loggedInUserId = UUID(uuidString: "B0000001-0001-0001-0001-000000000001")!
    static let sarahId = UUID(uuidString: "B0000001-0001-0001-0001-000000000002")!
    static let marcusId = UUID(uuidString: "B0000001-0001-0001-0001-000000000003")!
    static let emikoId = UUID(uuidString: "B0000001-0001-0001-0001-000000000004")!
    static let carlosId = UUID(uuidString: "B0000001-0001-0001-0001-000000000005")!
    static let priyaId = UUID(uuidString: "B0000001-0001-0001-0001-000000000006")!
    static let jakeId = UUID(uuidString: "B0000001-0001-0001-0001-000000000007")!
    static let lilyId = UUID(uuidString: "B0000001-0001-0001-0001-000000000008")!
    static let tylerOwnId = UUID(uuidString: "B0000001-0001-0001-0001-000000000009")!

    // MARK: - User Profiles

    static let loggedInProfile = UserProfile(
        id: loggedInUserId,
        displayName: "Alex Chen",
        username: "alex_eats_sf",
        avatarURL: URL(string: "https://picsum.photos/seed/user0/200/200"),
        bio: "Software engineer by day, food explorer by night. SF native.",
        postCount: 42,
        followerCount: 1280,
        followingCount: 345
    )

    static let loggedInUser = User(
        id: loggedInUserId,
        email: "alex.chen@example.com",
        profile: loggedInProfile,
        createdAt: Calendar.current.date(byAdding: .month, value: -8, to: .now)!
    )

    static let all: [UserProfile] = [
        loggedInProfile,
        UserProfile(
            id: sarahId,
            displayName: "Sarah Kim",
            username: "foodie_sarah",
            avatarURL: URL(string: "https://picsum.photos/seed/user1/200/200"),
            bio: "Professional food photographer. DM for collabs!",
            postCount: 312,
            followerCount: 15400,
            followingCount: 820
        ),
        UserProfile(
            id: marcusId,
            displayName: "Marcus Johnson",
            username: "sf_eats",
            avatarURL: URL(string: "https://picsum.photos/seed/user2/200/200"),
            bio: "Eating my way through every neighborhood in San Francisco. 78/117 done.",
            postCount: 587,
            followerCount: 32100,
            followingCount: 1200
        ),
        UserProfile(
            id: emikoId,
            displayName: "Emiko Tanaka",
            username: "ramen_hunter",
            avatarURL: URL(string: "https://picsum.photos/seed/user3/200/200"),
            bio: "On a quest to find the best ramen outside of Japan. Bay Area edition.",
            postCount: 156,
            followerCount: 8900,
            followingCount: 430
        ),
        UserProfile(
            id: carlosId,
            displayName: "Carlos Rivera",
            username: "taco_tuesday_365",
            avatarURL: URL(string: "https://picsum.photos/seed/user4/200/200"),
            bio: "Every day is taco Tuesday if you believe hard enough.",
            postCount: 365,
            followerCount: 22300,
            followingCount: 675
        ),
        UserProfile(
            id: priyaId,
            displayName: "Priya Patel",
            username: "spice_queen_sf",
            avatarURL: URL(string: "https://picsum.photos/seed/user5/200/200"),
            bio: "Spicy food enthusiast. If it doesn't make me cry, it's not spicy enough.",
            postCount: 198,
            followerCount: 11200,
            followingCount: 560
        ),
        UserProfile(
            id: jakeId,
            displayName: "Jake Morrison",
            username: "burger_boy_bay",
            avatarURL: URL(string: "https://picsum.photos/seed/user6/200/200"),
            bio: "Burgers, beers, and bay area vibes. No salad, no problem.",
            postCount: 89,
            followerCount: 4500,
            followingCount: 230
        ),
        UserProfile(
            id: lilyId,
            displayName: "Lily Nguyen",
            username: "pho_real_sf",
            avatarURL: URL(string: "https://picsum.photos/seed/user7/200/200"),
            bio: "Vietnamese-American sharing my family's food traditions. Pho is love.",
            postCount: 234,
            followerCount: 19800,
            followingCount: 910
        ),
        UserProfile(
            id: tylerOwnId,
            displayName: "Tyler Okonkwo",
            username: "global_palate",
            avatarURL: URL(string: "https://picsum.photos/seed/user8/200/200"),
            bio: "Former chef turned food writer. Tasting menus are my love language.",
            postCount: 421,
            followerCount: 27600,
            followingCount: 1050
        ),
    ]

    /// Look up a profile by user ID.
    static func profile(for id: UUID) -> UserProfile? {
        all.first { $0.id == id }
    }
}
