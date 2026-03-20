import Foundation

enum DietaryTag: String, Codable, Hashable, CaseIterable, Identifiable, Sendable {
    case vegetarian
    case vegan
    case glutenFree
    case dairyFree
    case nutFree
    case spicy
    case halal
    case kosher

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .vegetarian: return "Vegetarian"
        case .vegan: return "Vegan"
        case .glutenFree: return "Gluten-Free"
        case .dairyFree: return "Dairy-Free"
        case .nutFree: return "Nut-Free"
        case .spicy: return "Spicy"
        case .halal: return "Halal"
        case .kosher: return "Kosher"
        }
    }

    var systemImage: String {
        switch self {
        case .vegetarian: return "leaf.fill"
        case .vegan: return "leaf.circle.fill"
        case .glutenFree: return "wheat.bundle.slash"
        case .dairyFree: return "drop.triangle"
        case .nutFree: return "allergens"
        case .spicy: return "flame.fill"
        case .halal: return "checkmark.seal.fill"
        case .kosher: return "star.circle.fill"
        }
    }
}
