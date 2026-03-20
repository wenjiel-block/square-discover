import Foundation

struct MockReviews {
    private static let users = MockUsers.all

    private static func user(_ index: Int) -> UserProfile {
        users[index % users.count]
    }

    static let all: [Review] = [
        // La Taqueria reviews
        Review(
            author: user(4), // taco_tuesday_365
            merchantId: MockMerchants.laTaqueriaId,
            rating: 5,
            text: "Hands down the best burrito in San Francisco. The carne asada is perfectly seasoned and the no-rice philosophy means you get nothing but pure, delicious filling. James Beard Award was well deserved.",
            likeCount: 87,
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        ),
        Review(
            author: user(2), // sf_eats
            merchantId: MockMerchants.laTaqueriaId,
            rating: 4,
            text: "Incredible tacos. The al pastor is my favorite -- great pineapple flavor without being too sweet. Only thing is the line can be brutal during lunch rush. Worth the wait though.",
            likeCount: 45,
            createdAt: Calendar.current.date(byAdding: .day, value: -10, to: .now)!
        ),
        Review(
            author: user(0), // alex_eats_sf
            merchantId: MockMerchants.laTaqueriaId,
            rating: 5,
            text: "Been coming here for years and it never disappoints. The carnitas burrito is my comfort food. Pro tip: get the super with guac. Cash only so come prepared.",
            likeCount: 32,
            createdAt: Calendar.current.date(byAdding: .day, value: -20, to: .now)!
        ),

        // Sakura Ramen reviews
        Review(
            author: user(3), // ramen_hunter
            merchantId: MockMerchants.sakuraRamenId,
            rating: 5,
            text: "As someone who has eaten ramen in Tokyo, Osaka, and Fukuoka, I can say this is the closest thing to authentic tonkotsu broth I've found in the Bay Area. Rich, creamy, and deeply flavored.",
            likeCount: 134,
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        ),
        Review(
            author: user(1), // foodie_sarah
            merchantId: MockMerchants.sakuraRamenId,
            rating: 4,
            text: "The spicy miso ramen is excellent. Great depth of flavor and the noodles have perfect chew. Gyoza are also worth ordering. Cozy atmosphere that makes you feel like you're in a real ramen-ya.",
            likeCount: 67,
            createdAt: Calendar.current.date(byAdding: .day, value: -8, to: .now)!
        ),

        // Nonna's Kitchen reviews
        Review(
            author: user(8), // global_palate
            merchantId: MockMerchants.nonnasKitchenId,
            rating: 5,
            text: "Former chef here and I have to say -- the cacio e pepe at Nonna's is absolutely flawless. The emulsification of the pecorino and pasta water is textbook perfect. The pappardelle bolognese is also extraordinary. This is as close to eating in Rome as you'll get in SF.",
            likeCount: 203,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        Review(
            author: user(1), // foodie_sarah
            merchantId: MockMerchants.nonnasKitchenId,
            rating: 5,
            text: "Date night perfection. The truffle mushroom ravioli is heavenly and the tiramisu is the best I've had outside of Italy. Wine selection is thoughtfully curated too. Reservation recommended.",
            likeCount: 156,
            createdAt: Calendar.current.date(byAdding: .day, value: -5, to: .now)!
        ),
        Review(
            author: user(0), // alex_eats_sf
            merchantId: MockMerchants.nonnasKitchenId,
            rating: 4,
            text: "The Margherita pizza is wood-fired to perfection. Love the leopard spotting on the crust. Slightly pricey but you're paying for quality ingredients and handmade everything.",
            likeCount: 78,
            createdAt: Calendar.current.date(byAdding: .day, value: -14, to: .now)!
        ),

        // The Burger Joint reviews
        Review(
            author: user(6), // burger_boy_bay
            merchantId: MockMerchants.burgerJointId,
            rating: 4,
            text: "Finally a burger joint that does smash burgers RIGHT. Crispy edges, melty American cheese, and that secret sauce is addictive. Fries are solid too. No-frills vibes, just great food.",
            likeCount: 91,
            createdAt: Calendar.current.date(byAdding: .day, value: -4, to: .now)!
        ),
        Review(
            author: user(2), // sf_eats
            merchantId: MockMerchants.burgerJointId,
            rating: 4,
            text: "The BBQ Bacon Burger is a beast. Great quality beef and the onion rings on top are a nice touch. Oreo cookie shake is dangerously good. Casual counter-service spot, perfect for a quick meal.",
            likeCount: 54,
            createdAt: Calendar.current.date(byAdding: .day, value: -12, to: .now)!
        ),

        // Bombay Spice reviews
        Review(
            author: user(5), // spice_queen_sf
            merchantId: MockMerchants.bombaySpiceId,
            rating: 5,
            text: "Finally an Indian restaurant that doesn't water down the spice for American palates! The vindaloo is properly fiery and the butter chicken has incredible depth. The garlic naan is also pillowy and perfect.",
            likeCount: 112,
            createdAt: Calendar.current.date(byAdding: .day, value: -6, to: .now)!
        ),
        Review(
            author: user(8), // global_palate
            merchantId: MockMerchants.bombaySpiceId,
            rating: 4,
            text: "Solid Indian food with authentic flavors. The tandoori chicken is properly charred and juicy. The biryani is fragrant with whole spices. Lunch buffet is a great value if you want to try a bit of everything.",
            likeCount: 67,
            createdAt: Calendar.current.date(byAdding: .day, value: -15, to: .now)!
        ),

        // Pho Saigon reviews
        Review(
            author: user(7), // pho_real_sf
            merchantId: MockMerchants.phoSaigonId,
            rating: 5,
            text: "This pho hits different because they actually take the time to simmer the broth for a full 24 hours. You can taste the star anise and charred ginger. Portions are huge and prices are fair.",
            likeCount: 189,
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        ),
        Review(
            author: user(2), // sf_eats
            merchantId: MockMerchants.phoSaigonId,
            rating: 4,
            text: "Great neighborhood pho spot. The rare beef pho is my go-to. Banh mi is also surprisingly excellent with a perfectly crusty baguette. Service is fast and efficient.",
            likeCount: 56,
            createdAt: Calendar.current.date(byAdding: .day, value: -9, to: .now)!
        ),

        // Bangkok Street reviews
        Review(
            author: user(5), // spice_queen_sf
            merchantId: MockMerchants.bangkokStreetId,
            rating: 4,
            text: "The pad thai here has legitimate wok hei flavor which is so rare to find. Green curry is aromatic and rich. Mango sticky rice is the perfect ending. Great value for the quality.",
            likeCount: 78,
            createdAt: Calendar.current.date(byAdding: .day, value: -7, to: .now)!
        ),

        // Addis Ababa reviews
        Review(
            author: user(8), // global_palate
            merchantId: MockMerchants.addisAbabaId,
            rating: 4,
            text: "Beautiful communal dining experience. The injera is perfectly spongy with a pleasant tang, and the doro wat has complex layers of berbere spice. Vegetarian combo is also excellent.",
            likeCount: 43,
            createdAt: Calendar.current.date(byAdding: .day, value: -11, to: .now)!
        ),
    ]

    static let byMerchant: [String: [Review]] = {
        Dictionary(grouping: all) { $0.merchantId.uuidString }
    }()
}
