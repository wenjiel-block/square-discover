import Foundation

struct CustomizationOption: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let additionalPriceCents: Int

    init(
        id: UUID = UUID(),
        name: String,
        additionalPriceCents: Int = 0
    ) {
        self.id = id
        self.name = name
        self.additionalPriceCents = additionalPriceCents
    }

    var formattedAdditionalPrice: String? {
        guard additionalPriceCents > 0 else { return nil }
        let dollars = Double(additionalPriceCents) / 100.0
        return String(format: "+$%.2f", dollars)
    }
}

struct MenuItemCustomization: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let options: [CustomizationOption]
    let isRequired: Bool
    let maxSelections: Int

    init(
        id: UUID = UUID(),
        name: String,
        options: [CustomizationOption] = [],
        isRequired: Bool = false,
        maxSelections: Int = 1
    ) {
        self.id = id
        self.name = name
        self.options = options
        self.isRequired = isRequired
        self.maxSelections = maxSelections
    }

    var allowsMultipleSelections: Bool {
        maxSelections > 1
    }
}

struct MenuItem: Codable, Identifiable, Hashable, Sendable {
    let id: UUID
    let merchantId: UUID
    let name: String
    let description: String
    let priceCents: Int
    let imageURL: URL?
    var isAvailable: Bool
    let isPopular: Bool
    let dietaryTags: [DietaryTag]
    let customizations: [MenuItemCustomization]

    init(
        id: UUID = UUID(),
        merchantId: UUID,
        name: String,
        description: String = "",
        priceCents: Int,
        imageURL: URL? = nil,
        isAvailable: Bool = true,
        isPopular: Bool = false,
        dietaryTags: [DietaryTag] = [],
        customizations: [MenuItemCustomization] = []
    ) {
        self.id = id
        self.merchantId = merchantId
        self.name = name
        self.description = description
        self.priceCents = priceCents
        self.imageURL = imageURL
        self.isAvailable = isAvailable
        self.isPopular = isPopular
        self.dietaryTags = dietaryTags
        self.customizations = customizations
    }

    var formattedPrice: String {
        let dollars = Double(priceCents) / 100.0
        return String(format: "$%.2f", dollars)
    }

    var hasCustomizations: Bool {
        !customizations.isEmpty
    }

    var requiredCustomizations: [MenuItemCustomization] {
        customizations.filter(\.isRequired)
    }

    var optionalCustomizations: [MenuItemCustomization] {
        customizations.filter { !$0.isRequired }
    }
}
