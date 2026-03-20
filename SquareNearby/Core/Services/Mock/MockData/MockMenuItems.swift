import Foundation

struct MockMenuItems {
    // MARK: - Customization Helpers

    private static func sizeCustomization() -> MenuItemCustomization {
        MenuItemCustomization(
            name: "Size",
            options: [
                CustomizationOption(name: "Small", additionalPriceCents: 0),
                CustomizationOption(name: "Medium", additionalPriceCents: 200),
                CustomizationOption(name: "Large", additionalPriceCents: 400),
            ],
            isRequired: true,
            maxSelections: 1
        )
    }

    private static func spiceLevelCustomization() -> MenuItemCustomization {
        MenuItemCustomization(
            name: "Spice Level",
            options: [
                CustomizationOption(name: "Mild"),
                CustomizationOption(name: "Medium"),
                CustomizationOption(name: "Hot"),
                CustomizationOption(name: "Extra Hot"),
            ],
            isRequired: true,
            maxSelections: 1
        )
    }

    private static func proteinCustomization() -> MenuItemCustomization {
        MenuItemCustomization(
            name: "Protein",
            options: [
                CustomizationOption(name: "Chicken", additionalPriceCents: 0),
                CustomizationOption(name: "Beef", additionalPriceCents: 200),
                CustomizationOption(name: "Shrimp", additionalPriceCents: 300),
                CustomizationOption(name: "Tofu", additionalPriceCents: 0),
            ],
            isRequired: true,
            maxSelections: 1
        )
    }

    private static func toppingsCustomization() -> MenuItemCustomization {
        MenuItemCustomization(
            name: "Extra Toppings",
            options: [
                CustomizationOption(name: "Extra Cheese", additionalPriceCents: 150),
                CustomizationOption(name: "Avocado", additionalPriceCents: 200),
                CustomizationOption(name: "Bacon", additionalPriceCents: 250),
                CustomizationOption(name: "Fried Egg", additionalPriceCents: 150),
            ],
            isRequired: false,
            maxSelections: 4
        )
    }

    private static func ramenToppingsCustomization() -> MenuItemCustomization {
        MenuItemCustomization(
            name: "Extra Toppings",
            options: [
                CustomizationOption(name: "Extra Chashu", additionalPriceCents: 300),
                CustomizationOption(name: "Soft-Boiled Egg", additionalPriceCents: 200),
                CustomizationOption(name: "Corn", additionalPriceCents: 100),
                CustomizationOption(name: "Extra Noodles", additionalPriceCents: 200),
                CustomizationOption(name: "Nori (3 pcs)", additionalPriceCents: 100),
            ],
            isRequired: false,
            maxSelections: 5
        )
    }

    private static func noodleTypeCustomization() -> MenuItemCustomization {
        MenuItemCustomization(
            name: "Noodle Type",
            options: [
                CustomizationOption(name: "Thin"),
                CustomizationOption(name: "Regular"),
                CustomizationOption(name: "Thick"),
            ],
            isRequired: true,
            maxSelections: 1
        )
    }

    // MARK: - La Taqueria Menu

    private static let laTaqueriaMenu: [MenuCategory] = [
        MenuCategory(
            name: "Burritos",
            sortOrder: 0,
            items: [
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Carne Asada Burrito",
                    description: "Grilled steak with pinto beans, salsa, sour cream, cheese, and guacamole in a flour tortilla.",
                    priceCents: 1399,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT1/400/300"),
                    isPopular: true,
                    customizations: [spiceLevelCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Carnitas Burrito",
                    description: "Slow-braised pork shoulder with beans, salsa, sour cream, and cheese.",
                    priceCents: 1299,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT2/400/300"),
                    isPopular: true
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Chicken Burrito",
                    description: "Grilled chicken with pinto beans, salsa, sour cream, cheese, and guacamole.",
                    priceCents: 1199,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT3/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Veggie Burrito",
                    description: "Grilled peppers, onions, beans, rice, salsa, cheese, sour cream, and guacamole.",
                    priceCents: 1099,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT4/400/300"),
                    dietaryTags: [.vegetarian]
                ),
            ]
        ),
        MenuCategory(
            name: "Tacos",
            sortOrder: 1,
            items: [
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Carne Asada Taco",
                    description: "Two corn tortillas with grilled steak, onions, cilantro, and salsa verde.",
                    priceCents: 499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT5/400/300"),
                    isPopular: true
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Al Pastor Taco",
                    description: "Spit-roasted pork with pineapple, onions, and cilantro on corn tortillas.",
                    priceCents: 499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT6/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Carnitas Taco",
                    description: "Slow-braised pork with onions, cilantro, and your choice of salsa.",
                    priceCents: 499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT7/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Lengua Taco",
                    description: "Tender braised beef tongue with onion and cilantro.",
                    priceCents: 549,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT8/400/300")
                ),
            ]
        ),
        MenuCategory(
            name: "Plates",
            sortOrder: 2,
            items: [
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Super Nachos",
                    description: "Tortilla chips loaded with beans, cheese, sour cream, guacamole, and your choice of meat.",
                    priceCents: 1299,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT9/400/300"),
                    customizations: [proteinCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Quesadilla",
                    description: "Flour tortilla filled with melted cheese and your choice of meat.",
                    priceCents: 999,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT10/400/300"),
                    customizations: [proteinCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Taco Plate",
                    description: "Three tacos of your choice served with rice and beans.",
                    priceCents: 1599,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT11/400/300")
                ),
            ]
        ),
        MenuCategory(
            name: "Drinks",
            sortOrder: 3,
            items: [
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Horchata",
                    description: "Traditional Mexican rice drink with cinnamon and vanilla.",
                    priceCents: 399,
                    imageURL: URL(string: "https://picsum.photos/seed/menuLT12/400/300"),
                    dietaryTags: [.dairyFree],
                    customizations: [sizeCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Jamaica",
                    description: "Hibiscus flower iced tea, sweetened with cane sugar.",
                    priceCents: 349,
                    dietaryTags: [.vegan, .glutenFree],
                    customizations: [sizeCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.laTaqueriaId,
                    name: "Mexican Coca-Cola",
                    description: "Made with real cane sugar in a glass bottle.",
                    priceCents: 299
                ),
            ]
        ),
    ]

    // MARK: - Sakura Ramen Menu

    private static let sakuraRamenMenu: [MenuCategory] = [
        MenuCategory(
            name: "Ramen",
            sortOrder: 0,
            items: [
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Tonkotsu Ramen",
                    description: "Rich pork bone broth simmered 18 hours with chashu, soft-boiled egg, green onion, and nori.",
                    priceCents: 1699,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR1/400/300"),
                    isPopular: true,
                    customizations: [noodleTypeCustomization(), ramenToppingsCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Spicy Miso Ramen",
                    description: "Fermented soybean broth with ground pork, bean sprouts, corn, and chili oil.",
                    priceCents: 1799,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR2/400/300"),
                    isPopular: true,
                    dietaryTags: [.spicy],
                    customizations: [noodleTypeCustomization(), spiceLevelCustomization(), ramenToppingsCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Shoyu Ramen",
                    description: "Light soy sauce-based broth with chicken, bamboo shoots, egg, and scallions.",
                    priceCents: 1599,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR3/400/300"),
                    customizations: [noodleTypeCustomization(), ramenToppingsCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Veggie Ramen",
                    description: "Mushroom and kelp broth with tofu, seasonal vegetables, and sesame oil.",
                    priceCents: 1499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR4/400/300"),
                    dietaryTags: [.vegetarian, .vegan],
                    customizations: [noodleTypeCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Tsukemen (Dipping Ramen)",
                    description: "Thick noodles served cold alongside a rich, concentrated dipping broth.",
                    priceCents: 1899,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR5/400/300")
                ),
            ]
        ),
        MenuCategory(
            name: "Appetizers",
            sortOrder: 1,
            items: [
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Gyoza (6 pcs)",
                    description: "Pan-fried pork and cabbage dumplings with ponzu dipping sauce.",
                    priceCents: 899,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR6/400/300"),
                    isPopular: true
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Edamame",
                    description: "Steamed soybeans sprinkled with sea salt.",
                    priceCents: 599,
                    dietaryTags: [.vegetarian, .vegan, .glutenFree]
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Karaage Chicken",
                    description: "Japanese fried chicken marinated in ginger and soy, served with kewpie mayo.",
                    priceCents: 999,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR7/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Takoyaki (6 pcs)",
                    description: "Octopus balls topped with takoyaki sauce, mayo, and bonito flakes.",
                    priceCents: 899,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR8/400/300")
                ),
            ]
        ),
        MenuCategory(
            name: "Rice Bowls",
            sortOrder: 2,
            items: [
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Chashu Don",
                    description: "Sliced pork belly over rice with a soft-boiled egg and pickled ginger.",
                    priceCents: 1399,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR9/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Katsu Curry Rice",
                    description: "Crispy chicken cutlet with Japanese curry sauce and steamed rice.",
                    priceCents: 1499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuSR10/400/300")
                ),
            ]
        ),
        MenuCategory(
            name: "Drinks",
            sortOrder: 3,
            items: [
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Ramune Soda",
                    description: "Japanese marble soda in original, strawberry, or melon flavor.",
                    priceCents: 349
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Hot Green Tea",
                    description: "Freshly brewed sencha green tea.",
                    priceCents: 249,
                    dietaryTags: [.vegan, .glutenFree]
                ),
                MenuItem(
                    merchantId: MockMerchants.sakuraRamenId,
                    name: "Asahi Draft",
                    description: "Crisp Japanese lager on draft. Must be 21+.",
                    priceCents: 699
                ),
            ]
        ),
    ]

    // MARK: - Nonna's Kitchen Menu

    private static let nonnasKitchenMenu: [MenuCategory] = [
        MenuCategory(
            name: "Pasta",
            sortOrder: 0,
            items: [
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Cacio e Pepe",
                    description: "Handmade tonnarelli with pecorino romano and cracked black pepper.",
                    priceCents: 2199,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK1/400/300"),
                    isPopular: true,
                    dietaryTags: [.vegetarian]
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Bolognese",
                    description: "Slow-simmered beef and pork ragu over fresh pappardelle. Nonna's original recipe.",
                    priceCents: 2399,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK2/400/300"),
                    isPopular: true
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Truffle Mushroom Ravioli",
                    description: "Handmade ravioli stuffed with porcini and ricotta, finished with truffle butter.",
                    priceCents: 2699,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK3/400/300"),
                    dietaryTags: [.vegetarian]
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Vongole",
                    description: "Linguine with fresh Manila clams, white wine, garlic, and chili flakes.",
                    priceCents: 2499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK4/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Amatriciana",
                    description: "Bucatini with guanciale, San Marzano tomatoes, and pecorino.",
                    priceCents: 2299,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK5/400/300")
                ),
            ]
        ),
        MenuCategory(
            name: "Pizza",
            sortOrder: 1,
            items: [
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Margherita",
                    description: "San Marzano tomato, fresh mozzarella, basil, and extra virgin olive oil. Wood-fired.",
                    priceCents: 1899,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK6/400/300"),
                    isPopular: true,
                    dietaryTags: [.vegetarian]
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Prosciutto e Rucola",
                    description: "Prosciutto di Parma, arugula, shaved parmesan, and lemon vinaigrette.",
                    priceCents: 2199,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK7/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Quattro Formaggi",
                    description: "Mozzarella, gorgonzola, fontina, and parmesan with a drizzle of honey.",
                    priceCents: 2099,
                    dietaryTags: [.vegetarian]
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Diavola",
                    description: "Spicy salami, mozzarella, and chili oil on a tomato base.",
                    priceCents: 2099,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK8/400/300"),
                    dietaryTags: [.spicy]
                ),
            ]
        ),
        MenuCategory(
            name: "Antipasti",
            sortOrder: 2,
            items: [
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Burrata",
                    description: "Creamy burrata with heirloom tomatoes, basil, and aged balsamic.",
                    priceCents: 1799,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK9/400/300"),
                    dietaryTags: [.vegetarian, .glutenFree]
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Calamari Fritti",
                    description: "Lightly fried squid with marinara and lemon aioli.",
                    priceCents: 1499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK10/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Bruschetta",
                    description: "Toasted bread topped with diced tomatoes, garlic, basil, and olive oil.",
                    priceCents: 1199,
                    dietaryTags: [.vegan]
                ),
            ]
        ),
        MenuCategory(
            name: "Dolci",
            sortOrder: 3,
            items: [
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Tiramisu",
                    description: "Classic layered dessert with espresso-soaked ladyfingers and mascarpone cream.",
                    priceCents: 1399,
                    imageURL: URL(string: "https://picsum.photos/seed/menuNK11/400/300"),
                    isPopular: true,
                    dietaryTags: [.vegetarian]
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Panna Cotta",
                    description: "Vanilla bean panna cotta with seasonal berry compote.",
                    priceCents: 1199,
                    dietaryTags: [.vegetarian, .glutenFree]
                ),
                MenuItem(
                    merchantId: MockMerchants.nonnasKitchenId,
                    name: "Affogato",
                    description: "Vanilla gelato drowned in a shot of hot espresso.",
                    priceCents: 899,
                    dietaryTags: [.vegetarian, .glutenFree]
                ),
            ]
        ),
    ]

    // MARK: - The Burger Joint Menu

    private static let burgerJointMenu: [MenuCategory] = [
        MenuCategory(
            name: "Burgers",
            sortOrder: 0,
            items: [
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Classic Smash Burger",
                    description: "Double-patty smash burger with American cheese, lettuce, tomato, pickles, and secret sauce.",
                    priceCents: 1299,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ1/400/300"),
                    isPopular: true,
                    customizations: [toppingsCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "BBQ Bacon Burger",
                    description: "Smash patty with cheddar, crispy bacon, onion rings, and smoky BBQ sauce.",
                    priceCents: 1499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ2/400/300"),
                    isPopular: true
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Mushroom Swiss Burger",
                    description: "Beef patty with sauteed mushrooms, Swiss cheese, and garlic aioli.",
                    priceCents: 1399,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ3/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Veggie Burger",
                    description: "House-made black bean and quinoa patty with avocado, sprouts, and chipotle mayo.",
                    priceCents: 1199,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ4/400/300"),
                    dietaryTags: [.vegetarian]
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Spicy Jalape\u{00F1}o Burger",
                    description: "Double patty with pepper jack cheese, jalape\u{00F1}os, habanero sauce, and pickled onions.",
                    priceCents: 1399,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ5/400/300"),
                    dietaryTags: [.spicy]
                ),
            ]
        ),
        MenuCategory(
            name: "Sides",
            sortOrder: 1,
            items: [
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Hand-Cut Fries",
                    description: "Crispy hand-cut fries with sea salt. Served with ketchup.",
                    priceCents: 499,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ6/400/300"),
                    dietaryTags: [.vegan, .glutenFree],
                    customizations: [sizeCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Onion Rings",
                    description: "Beer-battered onion rings served with ranch dipping sauce.",
                    priceCents: 599,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ7/400/300"),
                    dietaryTags: [.vegetarian]
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Loaded Cheese Fries",
                    description: "Hand-cut fries smothered in cheddar sauce, bacon bits, and green onion.",
                    priceCents: 799,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ8/400/300")
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Coleslaw",
                    description: "Creamy housemade coleslaw with apple cider vinegar dressing.",
                    priceCents: 399,
                    dietaryTags: [.vegetarian, .glutenFree]
                ),
            ]
        ),
        MenuCategory(
            name: "Shakes",
            sortOrder: 2,
            items: [
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Vanilla Shake",
                    description: "Thick vanilla bean milkshake made with real ice cream.",
                    priceCents: 699,
                    imageURL: URL(string: "https://picsum.photos/seed/menuBJ9/400/300"),
                    dietaryTags: [.vegetarian],
                    customizations: [sizeCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Chocolate Shake",
                    description: "Rich chocolate milkshake topped with whipped cream.",
                    priceCents: 699,
                    dietaryTags: [.vegetarian],
                    customizations: [sizeCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Strawberry Shake",
                    description: "Fresh strawberry milkshake with real fruit blended in.",
                    priceCents: 749,
                    dietaryTags: [.vegetarian],
                    customizations: [sizeCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Oreo Cookie Shake",
                    description: "Vanilla shake blended with crushed Oreo cookies and chocolate drizzle.",
                    priceCents: 799,
                    isPopular: true,
                    dietaryTags: [.vegetarian],
                    customizations: [sizeCustomization()]
                ),
            ]
        ),
        MenuCategory(
            name: "Drinks",
            sortOrder: 3,
            items: [
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Fountain Soda",
                    description: "Coke, Diet Coke, Sprite, or Dr Pepper.",
                    priceCents: 299,
                    dietaryTags: [.vegan],
                    customizations: [sizeCustomization()]
                ),
                MenuItem(
                    merchantId: MockMerchants.burgerJointId,
                    name: "Fresh Lemonade",
                    description: "House-squeezed lemonade with a hint of mint.",
                    priceCents: 399,
                    dietaryTags: [.vegan, .glutenFree],
                    customizations: [sizeCustomization()]
                ),
            ]
        ),
    ]

    // MARK: - By Merchant Lookup

    static let byMerchant: [String: [MenuCategory]] = [
        MockMerchants.laTaqueriaId.uuidString: laTaqueriaMenu,
        MockMerchants.sakuraRamenId.uuidString: sakuraRamenMenu,
        MockMerchants.nonnasKitchenId.uuidString: nonnasKitchenMenu,
        MockMerchants.burgerJointId.uuidString: burgerJointMenu,
    ]

    /// Flat list of all menu items across all merchants.
    static var allItems: [MenuItem] {
        byMerchant.values.flatMap { categories in
            categories.flatMap(\.items)
        }
    }

    /// Look up a single menu item by ID across all merchants.
    static func menuItem(for id: UUID) -> MenuItem? {
        allItems.first { $0.id == id }
    }
}
