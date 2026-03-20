import Foundation

enum PriceLevel: Int, Codable, Hashable, CaseIterable, Sendable {
    case budget = 1
    case moderate = 2
    case upscale = 3
    case premium = 4

    var display: String {
        String(repeating: "$", count: rawValue)
    }

    var displayName: String {
        switch self {
        case .budget: return "Budget-Friendly"
        case .moderate: return "Moderate"
        case .upscale: return "Upscale"
        case .premium: return "Premium"
        }
    }
}
