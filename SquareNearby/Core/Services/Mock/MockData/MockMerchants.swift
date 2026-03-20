import Foundation

struct MockMerchants {
    // MARK: - Stable Merchant IDs

    static let laTaqueriaId = UUID(uuidString: "A0000001-0001-0001-0001-000000000001")!
    static let sakuraRamenId = UUID(uuidString: "A0000001-0001-0001-0001-000000000002")!
    static let nonnasKitchenId = UUID(uuidString: "A0000001-0001-0001-0001-000000000003")!
    static let szechuanGardenId = UUID(uuidString: "A0000001-0001-0001-0001-000000000004")!
    static let bangkokStreetId = UUID(uuidString: "A0000001-0001-0001-0001-000000000005")!
    static let bombaySpiceId = UUID(uuidString: "A0000001-0001-0001-0001-000000000006")!
    static let seoulKitchenId = UUID(uuidString: "A0000001-0001-0001-0001-000000000007")!
    static let phoSaigonId = UUID(uuidString: "A0000001-0001-0001-0001-000000000008")!
    static let burgerJointId = UUID(uuidString: "A0000001-0001-0001-0001-000000000009")!
    static let oliveFigId = UUID(uuidString: "A0000001-0001-0001-0001-00000000000A")!
    static let addisAbabaId = UUID(uuidString: "A0000001-0001-0001-0001-00000000000B")!
    static let caribbeanFlameId = UUID(uuidString: "A0000001-0001-0001-0001-00000000000C")!

    // MARK: - Standard Business Hours

    private static let standardWeekdayHours: [BusinessHours] = (2...6).map { day in
        BusinessHours(dayOfWeek: day, openTime: "11:00", closeTime: "22:00")
    }

    private static let standardWeekendHours: [BusinessHours] = [
        BusinessHours(dayOfWeek: 1, openTime: "10:00", closeTime: "22:00"),
        BusinessHours(dayOfWeek: 7, openTime: "10:00", closeTime: "23:00")
    ]

    private static let standardHours: [BusinessHours] = standardWeekdayHours + standardWeekendHours

    private static let extendedHours: [BusinessHours] = (1...7).map { day in
        BusinessHours(dayOfWeek: day, openTime: "10:00", closeTime: "00:00")
    }

    private static let lunchDinnerHours: [BusinessHours] = (2...6).map { day in
        BusinessHours(dayOfWeek: day, openTime: "11:30", closeTime: "21:30")
    } + [
        BusinessHours(dayOfWeek: 1, openTime: "12:00", closeTime: "21:00"),
        BusinessHours(dayOfWeek: 7, openTime: "11:30", closeTime: "22:00")
    ]

    // MARK: - All Merchants

    static let all: [Merchant] = [
        Merchant(
            id: laTaqueriaId,
            name: "La Taqueria",
            description: "Iconic Mission District taqueria famous for its carne asada and carnitas burritos. No rice in the burritos, just pure quality fillings wrapped in a warm flour tortilla.",
            cuisineTypes: [.mexican],
            location: Location(latitude: 37.7509, longitude: -122.4180, distanceMiles: 0.3),
            address: "2889 Mission St, San Francisco, CA 94110",
            phoneNumber: "(415) 285-7117",
            rating: 4.7,
            reviewCount: 2340,
            priceLevel: .budget,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant1/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo1/200/200"),
            isVerified: true,
            hours: standardHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 15,
            tags: ["Cash Only", "Counter Service", "James Beard Award"]
        ),
        Merchant(
            id: sakuraRamenId,
            name: "Sakura Ramen",
            description: "Authentic Japanese ramen house specializing in rich tonkotsu broth simmered for 18 hours. Hand-pulled noodles made fresh daily.",
            cuisineTypes: [.japanese],
            location: Location(latitude: 37.7857, longitude: -122.4098, distanceMiles: 0.8),
            address: "1581 Webster St, San Francisco, CA 94115",
            phoneNumber: "(415) 567-4903",
            rating: 4.5,
            reviewCount: 876,
            priceLevel: .moderate,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant2/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo2/200/200"),
            isVerified: true,
            hours: lunchDinnerHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 20,
            tags: ["Handmade Noodles", "Late Night", "Sake Bar"]
        ),
        Merchant(
            id: nonnasKitchenId,
            name: "Nonna's Kitchen",
            description: "Family-owned Italian trattoria serving recipes passed down through four generations. Handmade pasta, wood-fired pizzas, and a curated selection of Italian wines.",
            cuisineTypes: [.italian],
            location: Location(latitude: 37.7980, longitude: -122.4075, distanceMiles: 1.2),
            address: "1998 Union St, San Francisco, CA 94123",
            phoneNumber: "(415) 921-8800",
            rating: 4.8,
            reviewCount: 1523,
            priceLevel: .upscale,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant3/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo3/200/200"),
            isVerified: true,
            hours: lunchDinnerHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 25,
            tags: ["Date Night", "Wine Selection", "Outdoor Seating"]
        ),
        Merchant(
            id: szechuanGardenId,
            name: "Szechuan Garden",
            description: "Bold and fiery Szechuan cuisine featuring authentic mapo tofu, dan dan noodles, and mouth-numbing hot pot. Spice levels that don't compromise on flavor.",
            cuisineTypes: [.chinese],
            location: Location(latitude: 37.7941, longitude: -122.4078, distanceMiles: 0.6),
            address: "1335 Clement St, San Francisco, CA 94118",
            phoneNumber: "(415) 752-8833",
            rating: 4.3,
            reviewCount: 654,
            priceLevel: .moderate,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant4/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo4/200/200"),
            isVerified: false,
            hours: extendedHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 18,
            tags: ["Spicy", "Family Style", "Hot Pot"]
        ),
        Merchant(
            id: bangkokStreetId,
            name: "Bangkok Street",
            description: "Street-style Thai food with explosive flavors. Known for pad thai cooked in a blazing wok, green curry, and mango sticky rice that transports you to Chinatown, Bangkok.",
            cuisineTypes: [.thai],
            location: Location(latitude: 37.7614, longitude: -122.4197, distanceMiles: 0.5),
            address: "3235 24th St, San Francisco, CA 94110",
            phoneNumber: "(415) 550-7813",
            rating: 4.4,
            reviewCount: 432,
            priceLevel: .budget,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant5/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo5/200/200"),
            isVerified: true,
            hours: standardHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 12,
            tags: ["Fast Service", "Vegan Options", "Wok-Fired"]
        ),
        Merchant(
            id: bombaySpiceId,
            name: "Bombay Spice",
            description: "Rich, aromatic Indian cuisine featuring tandoori specialties, biryani cooked in clay pots, and a legendary butter chicken. Freshly baked naan from a traditional tandoor oven.",
            cuisineTypes: [.indian],
            location: Location(latitude: 37.7749, longitude: -122.4194, distanceMiles: 1.0),
            address: "542 Valencia St, San Francisco, CA 94110",
            phoneNumber: "(415) 861-1900",
            rating: 4.6,
            reviewCount: 789,
            priceLevel: .moderate,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant6/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo6/200/200"),
            isVerified: true,
            hours: standardHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 20,
            tags: ["Tandoor Oven", "Lunch Buffet", "Vegetarian Friendly"]
        ),
        Merchant(
            id: seoulKitchenId,
            name: "Seoul Kitchen",
            description: "Modern Korean restaurant offering sizzling bibimbap, Korean fried chicken, and BBQ platters. All served with an array of housemade banchan side dishes.",
            cuisineTypes: [.korean],
            location: Location(latitude: 37.7834, longitude: -122.4090, distanceMiles: 0.9),
            address: "1640 Post St, San Francisco, CA 94115",
            phoneNumber: "(415) 563-7200",
            rating: 4.2,
            reviewCount: 567,
            priceLevel: .moderate,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant7/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo7/200/200"),
            isVerified: false,
            hours: lunchDinnerHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 22,
            tags: ["BBQ", "Banchan", "Soju Selection"]
        ),
        Merchant(
            id: phoSaigonId,
            name: "Pho Saigon",
            description: "Beloved neighborhood pho shop with bone broth simmered for 24 hours. Generous portions of pho, banh mi, and vermicelli bowls at unbeatable prices.",
            cuisineTypes: [.vietnamese],
            location: Location(latitude: 37.7818, longitude: -122.4093, distanceMiles: 0.4),
            address: "1247 Polk St, San Francisco, CA 94109",
            phoneNumber: "(415) 673-3163",
            rating: 4.5,
            reviewCount: 1102,
            priceLevel: .budget,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant8/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo8/200/200"),
            isVerified: true,
            hours: extendedHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 10,
            tags: ["24-Hour Broth", "Quick Service", "Cash Friendly"]
        ),
        Merchant(
            id: burgerJointId,
            name: "The Burger Joint",
            description: "No-frills burger spot crafting smash burgers with locally sourced beef, melty American cheese, and a secret sauce. Hand-cut fries and thick shakes round out the menu.",
            cuisineTypes: [.american],
            location: Location(latitude: 37.7694, longitude: -122.4862, distanceMiles: 1.5),
            address: "700 Haight St, San Francisco, CA 94117",
            phoneNumber: "(415) 864-8643",
            rating: 4.1,
            reviewCount: 938,
            priceLevel: .budget,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant9/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo9/200/200"),
            isVerified: true,
            hours: extendedHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 12,
            tags: ["Smash Burgers", "Milkshakes", "Late Night"]
        ),
        Merchant(
            id: oliveFigId,
            name: "Olive & Fig",
            description: "Sun-drenched Mediterranean bistro with mezze platters, grilled lamb, and falafel wraps. Everything is drizzled with house-pressed olive oil imported from Crete.",
            cuisineTypes: [.mediterranean],
            location: Location(latitude: 37.7953, longitude: -122.4219, distanceMiles: 1.1),
            address: "2417 California St, San Francisco, CA 94115",
            phoneNumber: "(415) 345-3900",
            rating: 4.6,
            reviewCount: 412,
            priceLevel: .moderate,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant10/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo10/200/200"),
            isVerified: true,
            hours: lunchDinnerHours,
            isCurrentlyOpen: false,
            estimatedPickupTime: 18,
            tags: ["Healthy", "Gluten-Free Options", "Patio Dining"]
        ),
        Merchant(
            id: addisAbabaId,
            name: "Addis Ababa",
            description: "Communal Ethiopian dining at its finest. Injera bread topped with rich stews like doro wat and kitfo. Eat with your hands the way it was meant to be enjoyed.",
            cuisineTypes: [.ethiopian],
            location: Location(latitude: 37.7633, longitude: -122.4547, distanceMiles: 1.8),
            address: "1560 Haight St, San Francisco, CA 94117",
            phoneNumber: "(415) 252-7601",
            rating: 4.4,
            reviewCount: 321,
            priceLevel: .moderate,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant11/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo11/200/200"),
            isVerified: false,
            hours: standardHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 25,
            tags: ["Communal Dining", "Vegan Options", "Cultural Experience"]
        ),
        Merchant(
            id: caribbeanFlameId,
            name: "Caribbean Flame",
            description: "Island vibes with jerk chicken, oxtail stew, and plantains that crisp up to golden perfection. Wash it all down with a homemade sorrel drink or rum punch.",
            cuisineTypes: [.caribbean],
            location: Location(latitude: 37.7627, longitude: -122.4132, distanceMiles: 0.7),
            address: "3101 Mission St, San Francisco, CA 94110",
            phoneNumber: "(415) 647-2300",
            rating: 3.9,
            reviewCount: 218,
            priceLevel: .budget,
            heroImageURL: URL(string: "https://picsum.photos/seed/merchant12/800/600"),
            logoURL: URL(string: "https://picsum.photos/seed/logo12/200/200"),
            isVerified: false,
            hours: standardHours,
            isCurrentlyOpen: true,
            estimatedPickupTime: 15,
            tags: ["Jerk Chicken", "Rum Drinks", "Reggae Vibes"]
        ),
    ]

    /// Convenience lookup by merchant ID.
    static func merchant(for id: UUID) -> Merchant? {
        all.first { $0.id == id }
    }
}
