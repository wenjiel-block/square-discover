import Foundation

struct MockFeedItems {
    private static let merchants = MockMerchants.all
    private static let users = MockUsers.all

    private static func user(_ index: Int) -> UserProfile {
        users[index % users.count]
    }

    private static func merchant(_ index: Int) -> Merchant {
        merchants[index % merchants.count]
    }

    static let all: [FeedItem] = [
        // 1 - Video: Ramen
        FeedItem(
            author: user(3), // ramen_hunter
            merchant: merchant(1), // Sakura Ramen
            content: MediaContent(
                type: .video,
                url: URL(string: "https://example.com/videos/ramen_pour.mp4")!,
                thumbnailURL: URL(string: "https://picsum.photos/seed/feed1/800/1200"),
                aspectRatio: 0.5625,
                durationSeconds: 28
            ),
            caption: "This tonkotsu ramen is absolutely insane. 18-hour broth and you can TASTE every minute of it. The chashu just melts in your mouth.",
            likeCount: 2847,
            commentCount: 156,
            shareCount: 89,
            createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!
        ),
        // 2 - Image: Tacos
        FeedItem(
            author: user(4), // taco_tuesday_365
            merchant: merchant(0), // La Taqueria
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed2/800/1000"),
                aspectRatio: 0.8
            ),
            caption: "Best tacos in the Mission district, no debate. The carne asada here is on another level. No rice in the burrito either, just pure filling.",
            likeCount: 4213,
            commentCount: 287,
            shareCount: 145,
            createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: .now)!
        ),
        // 3 - Video: Pasta making
        FeedItem(
            author: user(8), // global_palate
            merchant: merchant(2), // Nonna's Kitchen
            content: MediaContent(
                type: .video,
                url: URL(string: "https://example.com/videos/pasta_making.mp4")!,
                thumbnailURL: URL(string: "https://picsum.photos/seed/feed3/800/1200"),
                aspectRatio: 0.5625,
                durationSeconds: 45
            ),
            caption: "Watching Nonna herself roll out fresh pappardelle for the bolognese. This is the real deal -- four generations of Italian cooking magic.",
            likeCount: 6102,
            commentCount: 342,
            shareCount: 278,
            createdAt: Calendar.current.date(byAdding: .hour, value: -8, to: .now)!
        ),
        // 4 - Image: Burger
        FeedItem(
            author: user(6), // burger_boy_bay
            merchant: merchant(8), // The Burger Joint
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed4/800/800"),
                aspectRatio: 1.0
            ),
            caption: "Double smash burger with that perfect cheese pull. The secret sauce is unreal. This spot doesn't miss.",
            likeCount: 1892,
            commentCount: 98,
            shareCount: 67,
            createdAt: Calendar.current.date(byAdding: .hour, value: -12, to: .now)!
        ),
        // 5 - Image: Indian spread
        FeedItem(
            author: user(5), // spice_queen_sf
            merchant: merchant(5), // Bombay Spice
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed5/800/600"),
                aspectRatio: 1.33
            ),
            caption: "Ordered the butter chicken extra spicy and they actually delivered. Plus the garlic naan is pillowy perfection right out of the tandoor.",
            likeCount: 3456,
            commentCount: 201,
            shareCount: 112,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        // 6 - Video: Korean BBQ sizzle
        FeedItem(
            author: user(1), // foodie_sarah
            merchant: merchant(6), // Seoul Kitchen
            content: MediaContent(
                type: .video,
                url: URL(string: "https://example.com/videos/kbbq_sizzle.mp4")!,
                thumbnailURL: URL(string: "https://picsum.photos/seed/feed6/800/1200"),
                aspectRatio: 0.5625,
                durationSeconds: 15
            ),
            caption: "The sizzle of bulgogi hitting the grill is peak ASMR. Seoul Kitchen never disappoints with the banchan spread too -- 8 side dishes!",
            likeCount: 5678,
            commentCount: 312,
            shareCount: 198,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        // 7 - Image: Pho
        FeedItem(
            author: user(7), // pho_real_sf
            merchant: merchant(7), // Pho Saigon
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed7/800/800"),
                aspectRatio: 1.0
            ),
            caption: "This pho reminds me of my grandmother's recipe. The broth is clear but incredibly deep in flavor. 24-hour simmer is no joke.",
            likeCount: 7234,
            commentCount: 445,
            shareCount: 312,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        // 8 - Image: Mediterranean mezze
        FeedItem(
            author: user(2), // sf_eats
            merchant: merchant(9), // Olive & Fig
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed8/800/600"),
                aspectRatio: 1.33
            ),
            caption: "This mezze platter is a work of art. The hummus is silky smooth and that falafel has the crunchiest exterior I've ever had.",
            likeCount: 2103,
            commentCount: 134,
            shareCount: 78,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        ),
        // 9 - Video: Thai wok fire
        FeedItem(
            author: user(5), // spice_queen_sf
            merchant: merchant(4), // Bangkok Street
            content: MediaContent(
                type: .video,
                url: URL(string: "https://example.com/videos/wok_fire.mp4")!,
                thumbnailURL: URL(string: "https://picsum.photos/seed/feed9/800/1200"),
                aspectRatio: 0.5625,
                durationSeconds: 22
            ),
            caption: "The wok hay at Bangkok Street is REAL. Look at that flame! This pad thai has that perfect smoky charred flavor you can only get from a blazing hot wok.",
            likeCount: 4567,
            commentCount: 267,
            shareCount: 189,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        ),
        // 10 - Image: Ethiopian injera
        FeedItem(
            author: user(8), // global_palate
            merchant: merchant(10), // Addis Ababa
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed10/800/800"),
                aspectRatio: 1.0
            ),
            caption: "Ethiopian food is the ultimate communal experience. Tearing into injera loaded with doro wat and kitfo -- eating with your hands just hits different.",
            likeCount: 1567,
            commentCount: 89,
            shareCount: 56,
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        ),
        // 11 - Image: Szechuan hot pot
        FeedItem(
            author: user(5), // spice_queen_sf
            merchant: merchant(3), // Szechuan Garden
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed11/800/1000"),
                aspectRatio: 0.8
            ),
            caption: "My lips are still numb from the Szechuan peppercorns and I wouldn't have it any other way. The mapo tofu here has the perfect mala kick.",
            likeCount: 2890,
            commentCount: 178,
            shareCount: 92,
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        ),
        // 12 - Video: Caribbean jerk chicken
        FeedItem(
            author: user(2), // sf_eats
            merchant: merchant(11), // Caribbean Flame
            content: MediaContent(
                type: .video,
                url: URL(string: "https://example.com/videos/jerk_chicken.mp4")!,
                thumbnailURL: URL(string: "https://picsum.photos/seed/feed12/800/1200"),
                aspectRatio: 0.5625,
                durationSeconds: 35
            ),
            caption: "Caribbean Flame bringing the heat with jerk chicken straight off the smoker. The scotch bonnet marinade is no joke. Pair it with fried plantains and you're golden.",
            likeCount: 1234,
            commentCount: 76,
            shareCount: 45,
            createdAt: Calendar.current.date(byAdding: .day, value: -4, to: .now)!
        ),
        // 13 - Image: Tiramisu close-up
        FeedItem(
            author: user(1), // foodie_sarah
            merchant: merchant(2), // Nonna's Kitchen
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed13/800/1000"),
                aspectRatio: 0.8
            ),
            caption: "Nonna's tiramisu deserves its own zip code. Layer after layer of espresso-soaked perfection. I'll be dreaming about this tonight.",
            likeCount: 3890,
            commentCount: 223,
            shareCount: 156,
            createdAt: Calendar.current.date(byAdding: .day, value: -4, to: .now)!
        ),
        // 14 - Image: Banh mi
        FeedItem(
            author: user(7), // pho_real_sf
            merchant: merchant(7), // Pho Saigon
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed14/800/600"),
                aspectRatio: 1.33
            ),
            caption: "Pho Saigon's banh mi might be even better than their pho (don't tell grandma I said that). The bread is perfectly crusty and the pickled daikon is on point.",
            likeCount: 2456,
            commentCount: 167,
            shareCount: 98,
            createdAt: Calendar.current.date(byAdding: .day, value: -5, to: .now)!
        ),
        // 15 - Video: Gyoza cooking
        FeedItem(
            author: user(3), // ramen_hunter
            merchant: merchant(1), // Sakura Ramen
            content: MediaContent(
                type: .video,
                url: URL(string: "https://example.com/videos/gyoza_sizzle.mp4")!,
                thumbnailURL: URL(string: "https://picsum.photos/seed/feed15/800/1200"),
                aspectRatio: 0.5625,
                durationSeconds: 18
            ),
            caption: "The gyoza at Sakura Ramen are pan-fried to crispy golden perfection. That sizzle when they flip them is everything. Ponzu dipping sauce ties it all together.",
            likeCount: 1789,
            commentCount: 101,
            shareCount: 72,
            createdAt: Calendar.current.date(byAdding: .day, value: -6, to: .now)!
        ),
        // 16 - Image: Bibimbap
        FeedItem(
            author: user(0), // alex_eats_sf (logged in user)
            merchant: merchant(6), // Seoul Kitchen
            content: MediaContent(
                type: .image,
                url: URL(string: "https://picsum.photos/seed/feed16/800/800"),
                aspectRatio: 1.0
            ),
            caption: "Stone pot bibimbap with that perfect crispy rice on the bottom. Mixed it all up with gochujang and it was heaven. Seoul Kitchen is my new go-to.",
            likeCount: 987,
            commentCount: 54,
            shareCount: 31,
            createdAt: Calendar.current.date(byAdding: .day, value: -7, to: .now)!
        ),
    ]
}
