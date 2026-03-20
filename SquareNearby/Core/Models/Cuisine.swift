import Foundation

enum Cuisine: String, Codable, Hashable, CaseIterable, Identifiable, Sendable {
    case mexican
    case japanese
    case italian
    case chinese
    case thai
    case indian
    case korean
    case vietnamese
    case american
    case mediterranean
    case ethiopian
    case caribbean
    case brazilian
    case french
    case soul
    case fusion
    case bakery
    case coffee

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .mexican: return "🇲🇽"
        case .japanese: return "🇯🇵"
        case .italian: return "🇮🇹"
        case .chinese: return "🇨🇳"
        case .thai: return "🇹🇭"
        case .indian: return "🇮🇳"
        case .korean: return "🇰🇷"
        case .vietnamese: return "🇻🇳"
        case .american: return "🇺🇸"
        case .mediterranean: return "🫒"
        case .ethiopian: return "🇪🇹"
        case .caribbean: return "🌴"
        case .brazilian: return "🇧🇷"
        case .french: return "🇫🇷"
        case .soul: return "🍗"
        case .fusion: return "🔥"
        case .bakery: return "🥐"
        case .coffee: return "☕"
        }
    }

    var displayName: String {
        switch self {
        case .mexican: return "Mexican"
        case .japanese: return "Japanese"
        case .italian: return "Italian"
        case .chinese: return "Chinese"
        case .thai: return "Thai"
        case .indian: return "Indian"
        case .korean: return "Korean"
        case .vietnamese: return "Vietnamese"
        case .american: return "American"
        case .mediterranean: return "Mediterranean"
        case .ethiopian: return "Ethiopian"
        case .caribbean: return "Caribbean"
        case .brazilian: return "Brazilian"
        case .french: return "French"
        case .soul: return "Soul Food"
        case .fusion: return "Fusion"
        case .bakery: return "Bakery"
        case .coffee: return "Coffee"
        }
    }
}
